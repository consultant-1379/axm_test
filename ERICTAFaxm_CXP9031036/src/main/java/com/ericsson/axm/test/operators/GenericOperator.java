package com.ericsson.axm.test.operators;

import java.io.FileNotFoundException;
import java.util.ArrayList;

import com.ericsson.cifwk.taf.tools.cli.Shell;
import com.ericsson.oss.taf.hostconfigurator.HostGroup;

public interface GenericOperator {

	void initialize();

	/**
	 * Send a file to a remote server
	 * 
	 * @param hostname
	 */
	void sendFileRemotely(String fileName, String remoteFileLocation)
			throws FileNotFoundException;

	/**
	 * Delete a file from remote server
	 * 
	 * @param hostname
	 */
	void deleteRemoteFile(String fileName, String remoteFileLocation)
			throws FileNotFoundException;

	String executeCommandAndGetOuput(String commands, int timeout);

	ArrayList execute_nodes(String path);

	void getFile() throws FileNotFoundException;
	
	String expect(String expectedText);// throws TimeoutException;//recent
		
	void expectClose(int timeout);// throws TimeoutException;//recent
	
	void scriptInput(String message);//recent
	
	String read();
	
	void writeln(String command);//recent
	
	int getExitValue();//recent
	
	boolean isClosed(); //throws TimeoutException;

	void disconnect();
	
	String expect(String expectedText, long timeout);
}
