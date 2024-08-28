package com.ericsson.axm.test.cases;

import java.util.List;

import javax.inject.Inject;

import org.testng.annotations.Test;

import com.ericsson.axm.test.operators.Network_ElementConnectivityOperator;
import com.ericsson.cifwk.taf.TestCase;
import com.ericsson.cifwk.taf.TorTestCaseHelper;
import com.ericsson.cifwk.taf.annotations.Context;
import com.ericsson.cifwk.taf.data.Host;
import com.ericsson.cifwk.taf.data.User;
import com.ericsson.cifwk.taf.data.UserType;
import com.ericsson.cifwk.taf.guice.OperatorRegistry;
import com.ericsson.cifwk.taf.tools.cli.handlers.impl.RemoteObjectHandler;
import com.ericsson.cifwk.taf.utils.FileFinder;
import com.ericsson.oss.taf.hostconfigurator.HostGroup;

@SuppressWarnings("deprecation")
public class AxmPreCheckTest extends TorTestCaseHelper implements TestCase {

	@Inject
	private OperatorRegistry<Network_ElementConnectivityOperator> precheckTest;

	final String axmPreCheckDir = "/home/nmsadm/axmtest";
	final String axmPreCheckEAMDir = "/home/nmsadm/eam";
	final String eam = "eam1.tar";
	final String atoss = "ERICatoss-R1A58.pkg.zip";
	final String lpa = "19089-LPA_APR901982_B_R1C01.pkg";
	final String testcase_csv = "AXM_Manual_testcases.csv";

	final int timeout = 300;

	@Context(context = { Context.CLI })
	@Test(groups = { "CDB", "VCDB" } ,priority=1)
	public void verifyPreCheck(){

		Network_ElementConnectivityOperator network_ElementConnectivityOperator =  precheckTest.provide(Network_ElementConnectivityOperator.class);

		try{

			network_ElementConnectivityOperator.initialize();

			//Cleaning the files if exists..
			cleanFiles(network_ElementConnectivityOperator);

			network_ElementConnectivityOperator.scriptInput("mkdir " + axmPreCheckDir);

			network_ElementConnectivityOperator.scriptInput("chmod 777 " + axmPreCheckDir);

			setTestStep("copying " + eam + " file to remote server....");
			assertTrue(sendFileRemotely(eam, axmPreCheckDir));

			setTestStep("copying " + atoss + " file to remote server....");
			assertTrue(sendFileRemotely(atoss, axmPreCheckDir));

			setTestStep("copying " + lpa + " file to remote server....");
			assertTrue(sendFileRemotely(lpa, axmPreCheckDir));

			setTestStep("copying " + testcase_csv + " file to remote server....");
			assertTrue(sendFileRemotely(testcase_csv, axmPreCheckDir));

			network_ElementConnectivityOperator.scriptInput("chmod 777 " + axmPreCheckDir + "/*");

			setTestStep("Executing preInstallation using root user....Please wait!!!");
			preInstallation(network_ElementConnectivityOperator);

			setTestStep("Creating manual report dir...");
			preManualReport(network_ElementConnectivityOperator);

			setTestStep("Restarting managed component...");
			restartManagedComponent(network_ElementConnectivityOperator);

		}catch(Exception e){
			e.printStackTrace();
		}finally{
			//Cleaning the files..
			network_ElementConnectivityOperator.scriptInput("cd -");
			cleanFiles(network_ElementConnectivityOperator);

			network_ElementConnectivityOperator.disconnect();
		}
	}

	@Test(groups = {"CDB", "VCDB"},priority=2)
	@Context(context = { Context.CLI })
	public void simulationTestStart(){

		Network_ElementConnectivityOperator network_ElementConnectivityOperator =  precheckTest.provide(Network_ElementConnectivityOperator.class);

		final String startScript = "triggerStart.sh";
		final String ne = "BSC;MSC;MSCBC;HLR;VHLR";
		
		final String stopScriptName = "triggerStop.sh";
                final String allNodes = "all";

		setTestcase("OSS-xxxx_Func_1", " Offline Simulation for all Network Element : " + allNodes);
                assertTrue(network_ElementConnectivityOperator.simulationOperator(allNodes, stopScriptName));

		setTestcase("OSS-xxxx_Func_1", " Online Simulation for Network Element : " + ne);
		assertTrue(network_ElementConnectivityOperator.simulationOperator(ne, startScript));

	}
	
	@Test(groups = {"CDB", "VCDB"})
	@Context(context = { Context.CLI })
	public void simulationTestStop(){

		Network_ElementConnectivityOperator network_ElementConnectivityOperator =  precheckTest.provide(Network_ElementConnectivityOperator.class);

		final String startScript = "triggerStop.sh";
		final String ne = "BSC;MSC;MSCBC;HLR;VHLR";
		setTestcase("OSS-xxxx_Func_1", " Offline Simulation for Network Element : " + ne);
		assertTrue(network_ElementConnectivityOperator.simulationOperator(ne, startScript));

	}
	private void restartManagedComponent(Network_ElementConnectivityOperator network_ElementConnectivityOperator){

		network_ElementConnectivityOperator.scriptInput("/opt/ericsson/bin/smtool -coldrestart "
				+ "eam_common eam_eac_idl eam_handlerAPG30 eam_handlerEMA eam_handlerIp eam_handlerIp_Mgr "
				+ "eam_handlerIpLx eam_handlerIpLx_Mgr eam_handlerMs eam_handlerMs_Mgr eam_handlerMtp eam_handlerText eam_nrma  "
				+ "-reason=other -reasontext=taf_test");
		try {
			Thread.sleep(120000);
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
	}

	private void preManualReport(Network_ElementConnectivityOperator network_ElementConnectivityOperator){

		network_ElementConnectivityOperator.scriptInput("rm -rf /tmp/manual_reports");

		network_ElementConnectivityOperator.scriptInput("mkdir /tmp/manual_reports");

		network_ElementConnectivityOperator.scriptInput("cp " + axmPreCheckDir + "/" + testcase_csv + " " + "/tmp/manual_reports");

	}

	private void preInstallation(Network_ElementConnectivityOperator network_ElementConnectivityOperator){

		String root = "su - root";
		network_ElementConnectivityOperator.writeln(root);
		network_ElementConnectivityOperator.expect("Password:", 30);
		network_ElementConnectivityOperator.scriptInput("shroot12\r");


		network_ElementConnectivityOperator.scriptInput("cd " + axmPreCheckDir);

		network_ElementConnectivityOperator.scriptInput("unzip " + atoss);

		network_ElementConnectivityOperator.scriptInput("ist_run -d ERICatoss-R1A58.pkg -auto -pa -force");
		network_ElementConnectivityOperator.expect("ossmaster{root} #", timeout);

		network_ElementConnectivityOperator.scriptInput("ist_run -d " + lpa + " -force -auto -pa");
		network_ElementConnectivityOperator.expect("ossmaster{root} #", timeout);

		network_ElementConnectivityOperator.scriptInput("tar -xvf " + eam);
		try {
                        Thread.sleep(100000);
                } catch (InterruptedException e) {
                        e.printStackTrace();
                }

		network_ElementConnectivityOperator.scriptInput("gunzip /opt/ericsson/atoss/tas/lib/X86/PERL/perl-5.8.8-sol10-x86-local.gz");
		network_ElementConnectivityOperator.scriptInput("y");

		network_ElementConnectivityOperator.scriptInput("pkgadd -d /opt/ericsson/atoss/tas/lib/X86/PERL/perl-5.8.8-sol10-x86-local");
		network_ElementConnectivityOperator.scriptInput("all");
		network_ElementConnectivityOperator.scriptInput("y");

		network_ElementConnectivityOperator.scriptInput("/opt/ericsson/atoss/tas/PF_SERVCIF/CL/bin/prehandler.pl >& output_of_PF_SERVCIF_CL_prehandler.txt");
		try {
			Thread.sleep(60000);
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
	 	network_ElementConnectivityOperator.scriptInput("mkdir " + axmPreCheckEAMDir);

                network_ElementConnectivityOperator.scriptInput("chmod -R 777 " + axmPreCheckEAMDir);

		network_ElementConnectivityOperator.scriptInput("cp -r /home/nmsadm/axmtest/eam/. /home/nmsadm/eam/.");

                network_ElementConnectivityOperator.scriptInput("chmod -R 777 " + axmPreCheckEAMDir);
                network_ElementConnectivityOperator.scriptInput("chown -R nmsadm " + axmPreCheckEAMDir);
                network_ElementConnectivityOperator.scriptInput("chgrp -R nms " + axmPreCheckEAMDir);
		network_ElementConnectivityOperator.scriptInput("cp -r /opt/ericsson/lib/. /usr/lib/.");



	}
	private boolean sendFileRemotely(String fileName, String fileServerLocation) {

		boolean transfered = true;
		try {
			Host host = HostGroup.getOssmaster();
			User operUser = new User(host.getUser(UserType.OPER),
					host.getPass(UserType.OPER), UserType.OPER);
			RemoteObjectHandler remote = new RemoteObjectHandler(host, operUser);
			List<String> fileLocation = FileFinder.findFile(fileName);
			String remoteFileLocation = fileServerLocation;      
			remote.copyLocalFileToRemote(fileLocation.get(0) ,remoteFileLocation);
		}catch (Exception e) {
			System.out.println(e.getMessage());
			transfered = false;
		}
		return transfered;
	}

	private void cleanFiles(Network_ElementConnectivityOperator network_ElementConnectivityOperator ){
		network_ElementConnectivityOperator.scriptInput("rm -rf " + axmPreCheckDir);
	}
}

