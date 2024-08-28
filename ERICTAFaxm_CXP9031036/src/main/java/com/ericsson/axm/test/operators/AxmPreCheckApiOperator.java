package com.ericsson.axm.test.operators;

import java.io.File;
import java.util.*;
import java.util.Map.Entry;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import java.sql.Timestamp;
import org.apache.log4j.Logger;

import com.ericsson.cifwk.taf.ApiOperator;
import com.ericsson.cifwk.taf.data.*;
import com.ericsson.cifwk.taf.handlers.RemoteFileHandler;
import com.ericsson.cifwk.taf.tools.cli.CLI;
import com.ericsson.cifwk.taf.tools.cli.CLICommandHelper;
import com.ericsson.cifwk.taf.utils.FileFinder;
import com.ericsson.oss.taf.hostconfigurator.HostGroup;
import com.ericsson.axm.test.apiGetter.AxmRemoteCommandExecutor;
import com.ericsson.axm.test.apiGetter.AxmApiGetter;
import com.ericsson.cifwk.taf.tools.cli.handlers.impl.RemoteObjectHandler;

public class AxmPreCheckApiOperator implements ApiOperator {

	private static Logger log = Logger.getLogger(AxmPreCheckApiOperator.class);;

	private final boolean isShowDetails = true;

	private String consoleMessage;

	private static final String FAILED = "FAILED";

	private static final String PASSED = "OK";
	private static AxmRemoteCommandExecutor preCheckSshRemoteCommandExecutor = AxmApiGetter.getRemoteCommandExecutor(AxmApiGetter.getHostMaster());
	private static RemoteObjectHandler remoteExecutor = AxmApiGetter.getRemoteObjectHandler(AxmApiGetter.getHostMaster());
	private static final String TRIGGER_PATH = "/netsim/inst/POC/";
	private static final String FileName = "simulationTextFile.txt";



	public boolean simulationOperator(String networkElement, String script){

		CLICommandHelper sshExecutor  = new CLICommandHelper(HostGroup.getAllNetsims().get(0));
		 
		String neList[] = networkElement.split(";");

		String initialCommand = "rm -rf " + TRIGGER_PATH + FileName + " | touch " + TRIGGER_PATH + FileName;
		
		log.info("Creating file on the path :  " +  TRIGGER_PATH);
		sshExecutor.execute(initialCommand);

		for(String ne : neList ){
			sshExecutor.execute("echo " + ne + " >> " + TRIGGER_PATH + FileName);
		}
		log.info("Waiting for the script to execute....");
		String result =  sshExecutor.execute(". " + TRIGGER_PATH + script + " " + TRIGGER_PATH + FileName);
		
		log.info("Result from the script = " + result);
		
		if(result.contains("0")){
			
			return true;
		}
		return false;
	}

	/**
	 * Restarting Cex Mc
	 * @param oss_cex
	 */
	public void restartMc() {

		preCheckSshRemoteCommandExecutor.simplExec(
				"/opt/ericsson/nms_cif_sm/bin/smtool cold pms_seg -reason=other -reasontext=TAF_RUN");
		try{
			log.info("<font color=purple><B>1> Restarting pms & Waiting for 3 minutes...</B></font>");
			Thread.sleep(180000);
		}catch (InterruptedException e){
			log.debug(e.getMessage());
		}
	}

	private void checkDoesFtpServiceExist(final LinkedHashMap<String, String> outputMap,
			final LinkedHashMap<String, String> unexpectedResultMap, final String ftpServerName,
			final String[] ftpServices) {

		String line;
		String myCmdString;
		myCmdString = "/opt/ericsson/nms_cif_cs/etc/unsupported/bin/cstest -s ONRM_CS lt FtpService | grep "
				+ ftpServerName;

		final String checkFtpService = preCheckSshRemoteCommandExecutor.simplExec(myCmdString);

		final Pattern pattern = Pattern.compile("FtpService=(.*)");
		final StringBuilder sbServices = new StringBuilder();
		final Scanner scanner = new Scanner(checkFtpService);
		while (scanner.hasNextLine() && (line = scanner.nextLine()) != null) {

			final String key = parseLine(line, 0, pattern);
			log.info("Key ==> " + key);
			log.info("Value ==> " + line);
			outputMap.put("FtpService-" + key, line);
			sbServices.append(key + ",");
		}
		final String servicesStr = sbServices.toString();
		for (final String serviceKey : ftpServices) {
			if (!servicesStr.contains(serviceKey)) {
				log.info("<font color=red>FtpService Not Found ==> " + serviceKey + "</font");
				unexpectedResultMap.put(serviceKey, "FtpService Not Found");
			}
		}
	}


	public String checkMCOnline() {

		log.info("<font color=purple><B>1> Start to check required online MCs...</B></font>");

		final LinkedHashMap<String, String> outputMap = new LinkedHashMap<String, String>();
		final LinkedHashMap<String, String> unexpectedResultMap = new LinkedHashMap<String, String>();
		final String mcs = "ONRM_CS,Seg_masterservice_CS,pms_reg,pms_seg";

		final String command = "/opt/ericsson/bin/smtool ";
		final String option = "list ";
		final String[] requiredMCs = mcs.trim().split(",");
		String testResult;

		try {

			for (final String mc : requiredMCs) {

				final String checkMcCommand = command + option + mc;
				final String checkMCs = preCheckSshRemoteCommandExecutor.simplExec(checkMcCommand);
				preCheckSshRemoteCommandExecutor.simplExec("rm -rf ~/cex ~/ocp");

				final Scanner scanner = new Scanner(checkMCs);
				String line = null;
				while (scanner.hasNextLine() && (line = scanner.nextLine()) != null) {
					boolean mcFound = false;
					// for (final String mc : requiredMCs) {
					if (line.toLowerCase().contains(mc.toLowerCase())) {
						mcFound = true;
						if (line.toLowerCase().contains("started".toLowerCase())) {
							// the mc is online
							outputMap.put(mc, "started");
						}
						else {
							// the mc is installed but not online
							final int index = line.lastIndexOf(" ");
							unexpectedResultMap.put(mc, line.substring(index));
							mcFound = false;
							break;
						}
						break;
					}
					if (!mcFound) {
						unexpectedResultMap.put("Unknown", line);
					}
				}
			}
		}
		catch (final Exception e) {
			unexpectedResultMap.put("EXCEPTION ", e.toString());
		}

		if (outputMap.size() == requiredMCs.length && unexpectedResultMap.size() == 0) {

			log.info("<font color=green>The pre-check on required online MCs is SUCCESSFUL. </font>");
			testResult = PASSED;
		}
		else {
			consoleMessage = "Pre-check on required online MCs is failed. See problems as below:";
			testResult = failTestCase(unexpectedResultMap, consoleMessage);
		}
		consoleMessage = "Online MCs:";
		printOutDetails(outputMap, consoleMessage);
		return testResult;

	}


	private int scanThroughLineToFindOsgiBundles(final StringBuilder sb, final Scanner scanner, final String result) {

		String line = null;

		final String[] bundleKeywords = new String[] { "cex","utilities","common","service","nsd","manager","cp" };
		final LinkedHashMap<String, String> outputMap = new LinkedHashMap<String, String>();
		final Pattern pattern = Pattern.compile("(com.+)_[\\d|\\.]{5}");
		System.out.println("pattern" + pattern);

		int count = 0;

		while (scanner.hasNextLine() && (line = scanner.nextLine()) != null) {
			for (final String keyword : bundleKeywords) {
				if (line.contains(keyword)) {
					final String key = MyFixtureHelper.parseLine(line, 2, pattern);
					outputMap.put(key, line);
					count++;
					break;
				}
			}
		}
		consoleMessage = "Relevant OsgiBundles Online\n";
		printOutDetails(outputMap, consoleMessage);
		return count;

	}

	private String failTestCase(final LinkedHashMap<String, String> unexpectedResultMap, final String consoleMessage) {

		String testResult;
		final StringBuilder sb = new StringBuilder(consoleMessage + "\r\n");
		for (final Entry<String, String> pair : unexpectedResultMap.entrySet()) {
			sb.append(String.format("%1$s: %2$s\r\n", pair.getKey(), pair.getValue()));
		}
		log.error(sb.toString().replaceAll("\r\n$", ""));

		testResult = FAILED;
		return testResult;
	}

	private void printOutDetails(final LinkedHashMap<String, String> outputMap, final String consoleMessage) {

		if (isShowDetails) {
			final StringBuilder sb = new StringBuilder(consoleMessage + "\r\n");
			for (final Entry<String, String> entry : outputMap.entrySet()) {
				sb.append(String.format("%1$s: %2$s\r\n", entry.getKey(), entry.getValue()));
			}

			log.info(sb.toString());
		}
	}

	static String parseLine(final String line, final int index, final Pattern pattern) {

		String key = null;

		final String[] arr = line.trim().split("\\s+");

		final String tmp = arr[index];
		if (pattern != null) {
			final Matcher m = pattern.matcher(tmp);
			if (m.find()) {
				key = m.group(1);
			}
			else {
				key = "[KeyNotFound: " + line + "]";
			}

		}
		else {
			key = tmp;
		}

		return key;
	}

	private static final class MyFixtureHelper {

		static String getCurrentTimeStamp() {

			final java.util.Date date = new java.util.Date();
			return new Timestamp(date.getTime()).toString();
		}

		static void log(final String content) {

			log(LogType.INFO, content);
		}

		static void log(final LogType type, final String content) {

			System.out.println(String.format("[%1$s] - %2$s: %3$s", type, getCurrentTimeStamp(), content));
		}

		static String parseLine(final String line, final int index, final Pattern pattern) {

			String key = null;

			final String[] arr = line.trim().split("\\s+");

			final String tmp = arr[index];
			if (pattern != null) {
				final Matcher m = pattern.matcher(tmp);
				if (m.find()) {
					key = m.group(1);
				}
				else {
					key = "[KeyNotFound: " + line + "]";
				}

			}
			else {
				key = tmp;
			}

			return key;
		}

		enum LogType {
			INFO, WARNING, ERROR;
		}

	}

}

