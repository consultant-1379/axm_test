package com.ericsson.axm.test.operators;

import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Logger;

import com.ericsson.cifwk.taf.annotations.Context;
import com.ericsson.cifwk.taf.annotations.Operator;
import com.ericsson.cifwk.taf.data.*;
import com.ericsson.cifwk.taf.utils.FileFinder;
import com.google.inject.Singleton;
import com.ericsson.oss.taf.hostconfigurator.HostGroup;
import com.ericsson.cifwk.taf.tools.cli.handlers.impl.RemoteObjectHandler;
import com.ericsson.cifwk.taf.tools.cli.CLICommandHelper;
import com.ericsson.cifwk.taf.tools.cli.TimeoutException;

@Operator(context = Context.CLI)
@Singleton
public class CLIOperator implements GenericOperator {

	Host host = HostGroup.getOssmaster();
	User operUser = new User(host.getUser(UserType.OPER),
			host.getPass(UserType.OPER), UserType.OPER);
	CLICommandHelper cliCommandHelper = new CLICommandHelper(host, operUser);
	RemoteObjectHandler remoteObjectHandler; 
	Logger logger = Logger.getLogger(CLIOperator.class);

	@Override
	public void initialize() {
		logger.info("Environment setup...");
		logger.info("The host server is :" + host);
		logger.info("The user server is :" + operUser);
		logger.info(cliCommandHelper.execute("ls -lrt /home/nmsadm/script/"));
		String output = cliCommandHelper.getStdOut().replace(" ", "");
		logger.info("output");
		boolean contains = output.contains("Nosuchfileordirectory");
		if (contains == true) {
			logger.info(cliCommandHelper.execute("mkdir /home/nmsadm/script"));
		}
		logger.info("ls -lrt /home/nmsadm");
		logger.info(cliCommandHelper
				.execute("chmod -R 777 /home/nmsadm/script/"));
		logger.info("script folder permission changed");
		logger.info(cliCommandHelper
				.execute("chown -R nmsadm /home/nmsadm/script/"));
		// logger.info(cliCommandHelper.execute("chmod 777 /home/nmsadm/script/test_connection.tcl"));
		logger.info("Initialize done");
	}

	@Override
	public void sendFileRemotely(String fileName, String fileServerLocation)
			throws FileNotFoundException {
		remoteObjectHandler = new RemoteObjectHandler(host, operUser);
		List<String> fileLocation = FileFinder.findFile(fileName);
		logger.info("Local File Location :: " + fileLocation.get(0));
		String remoteFileLocation = fileServerLocation; // unix address
		//logger.info("Remote File Location :: " + remoteFileLocation);
		remoteObjectHandler.copyLocalFileToRemote(fileLocation.get(0),
				remoteFileLocation);
		logger.debug("Copied " + fileName + " to " + remoteFileLocation
				+ " on remote host");
		logger.info("Copied " + fileName + " to " + remoteFileLocation
                                + " on remote host");

		// executeCommand("dos2unix /home/nmsadm/script/Pre_check.sh");
		logger.info(cliCommandHelper.execute("dos2unix /home/nmsadm/script/"
				+ fileName + " " + "/home/nmsadm/script/" + fileName));
		logger.info(cliCommandHelper
				.execute("chmod 777 /home/nmsadm/script/test_connection.tcl"));
		remoteObjectHandler = null;
	}

	@Override
	public void deleteRemoteFile(String fileName, String fileServerLocation)
                        throws FileNotFoundException {
		remoteObjectHandler = new RemoteObjectHandler(host, operUser);
		String remoteFileLocation = fileServerLocation;
		logger.info("Deleting File Location :: " + remoteFileLocation
				+ fileName);
		remoteObjectHandler.deleteRemoteFile(remoteFileLocation + fileName);
		logger.debug("Deleted " + fileName + " at location "
				+ remoteFileLocation + " on remote host");
		remoteObjectHandler = null;
	}

	@Override
	public ArrayList execute_nodes(String node_info) {

		// TODO Auto-generated method stub
		String[] array1 = null, array2 = null, array3 = null, array4 = null;
		String[] array = node_info.split("\\^");
		for (int i = 0; i < array.length; i++) {
			array1 = array[0].split(":");
			array2 = array[1].split(":");
			array3 = array[2].split(":");

		}
		// System.out.println("ARRAY1");
		/*
		 * for(int j=1;j<array1.length;j++) {
		 * 
		 * System.out.print(array1[j]+ "  "); } System.out.println();
		 * System.out.println("ARRAY2"); for(int j=1;j<array2.length;j++) {
		 * System.out.print(array2[j]+"  "); } System.out.println();
		 * System.out.println("ARRAY3"); for(int j=1;j<array3.length;j++) {
		 * System.out.print(array3[j]+"  "); }
		 */

		ArrayList<String[]> list = new ArrayList<String[]>();
		list.add(array1);
		list.add(array2);
		list.add(array3);
		int size = (array1.length - 1) + (array2.length - 1)
				+ (array3.length - 1);
		array4 = new String[size];
		int pos = 0; // specifies index at which copying will start in 4th array
		System.arraycopy(array1, 1, array4, pos, array1.length - 1);
		pos += array1.length - 1; // update index to avoid overwriting of data
		System.arraycopy(array2, 1, array4, pos, array2.length - 1);
		pos += array2.length - 1; // update index to avoid overwriting of data
		System.arraycopy(array3, 1, array4, pos, array3.length - 1);
		list.add(array4);
		return list;

	}

	@Override
	public String executeCommandAndGetOuput(String commands, int timeout) {
		cliCommandHelper.execute(commands);
		String output = cliCommandHelper.getStdOut(timeout);
		cliCommandHelper.disconnect();
		System.out.println("--->Command execution op:"+output);
		return output;
	}

	
	
	@Override
	public void disconnect() {
		logger.info("Disconnecting from shell");
		cliCommandHelper.disconnect();
		cliCommandHelper = null;
	}

	@Override
	public String expect(String expectedText) throws TimeoutException {
		logger.debug("Expected return is " + expectedText);
		String found = cliCommandHelper.expect(expectedText);
		// System.out.println("Output of expect is " + found);
		return found;
	}

	@Override
	public String expect(String expectedText, long timeout)
			throws TimeoutException {
		logger.debug("Expected return is " + expectedText);
		String found = cliCommandHelper.expect(expectedText, timeout);
		System.out.println("Output of expect is " + found);
		return found;
	}

	@Override
	public void expectClose(int timeout) throws TimeoutException {
		cliCommandHelper.expectShellClosure(timeout);
	}

	@Override
	public void scriptInput(String message) {
		logger.info("Writing " + message + " to standard in");
		cliCommandHelper.write(message);
	}

	@Override
	public void writeln(String command) {
		String cmd = null;
		cmd = command;
		logger.trace("Writing " + cmd + " to standard input");
		logger.info("Executing commmand " + cmd);
		System.out.println("Executing commmand " + cmd);
		// System.out.println("Shell NULL?:"+(shell==null));
		cliCommandHelper.write(cmd);
	}

	@Override
	public String read() {
		String cmd = null;
		cmd = cliCommandHelper.getStdOut();
		return (cmd);
	}

	@Override
	public int getExitValue() {
		int exitValue = cliCommandHelper.getShellExitValue();
		logger.debug("Getting exit value from shell, exit value is :"
				+ exitValue);
		return exitValue;
	}

	@Override
	public boolean isClosed() throws TimeoutException {
		return cliCommandHelper.isClosed();
	}

	@Override
	public void getFile() throws FileNotFoundException {
		remoteObjectHandler = new RemoteObjectHandler(host, operUser);
		String fileLocation = "/tmp/nodetest.txt";
		logger.info("File Location :: " + fileLocation);
		String remoteFileLocation = "/home/nmsadm/nodetest.txt"; // unix address
		logger.info("Remote File Location :: " + remoteFileLocation);
		remoteObjectHandler.copyRemoteFileToLocal(remoteFileLocation,
				fileLocation);
		logger.debug("Copied " + remoteFileLocation + " to " + fileLocation);
		remoteObjectHandler = null;
	}

}
