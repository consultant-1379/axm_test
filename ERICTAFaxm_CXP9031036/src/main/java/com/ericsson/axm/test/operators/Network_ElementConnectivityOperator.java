package com.ericsson.axm.test.operators;

import java.io.FileNotFoundException;
import com.ericsson.cifwk.taf.tools.cli.Shell;

public interface Network_ElementConnectivityOperator {
	
	void initialize();

	/**
	 * Send a file to a remote server
	 * @param hostname
	 */
	void sendFileRemotely(String fileName, String remoteFileLocation) throws FileNotFoundException;

	/**
	 * Delete a file from remote server
	 * @param hostname
	 */
	void deleteRemoteFile(String fileName, String remoteFileLocation) throws FileNotFoundException;

	
	/**
     * Create {@link Shell} and execute the command on it<br />
     * Command will be like a single command, or a list of commands that can be executed one after the other
     *
     * @param commands executed commands
     * @return new shell object, representing the shell result of the executed command
     */
	Shell executeCommand(String... commands);
	
	String executeCommandAndGetOuput(String commands,int timeout);
	void getFile() throws FileNotFoundException;	
	String expect(String expectedText);// throws TimeoutException;//recent
		
	void expectClose(int timeout);// throws TimeoutException;//recent
	
	void scriptInput(String message);//recent
	
	String read();
	void writeln(String command);//recent
	
	int getExitValue();//recent
	
	boolean isClosed(); //throws TimeoutException;

	void disconnect();	
	String expect(String expectedText, long timeout);//throws TimeoutException;
	
	/**
	 * @return
	 */
	String execute();
	
	 boolean simulationOperator(String networkElement, String script);

	String scriptOutput(String message);
}


