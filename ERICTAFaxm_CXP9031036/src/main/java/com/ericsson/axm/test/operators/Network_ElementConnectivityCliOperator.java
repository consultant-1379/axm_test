package com.ericsson.axm.test.operators;

import java.io.FileNotFoundException;
import java.util.List;

import org.apache.log4j.Logger;

import com.ericsson.cifwk.taf.annotations.Context;
import com.ericsson.cifwk.taf.annotations.Operator;
import com.ericsson.cifwk.taf.data.DataHandler;
import com.ericsson.cifwk.taf.data.Host;
import com.ericsson.cifwk.taf.data.HostType;
import com.ericsson.cifwk.taf.data.User;
import com.ericsson.cifwk.taf.data.UserType;
import com.ericsson.cifwk.taf.tools.cli.CLI;
import com.ericsson.cifwk.taf.tools.cli.CLICommandHelper;
import com.ericsson.cifwk.taf.tools.cli.Shell;
import com.ericsson.cifwk.taf.tools.cli.TimeoutException;
import com.ericsson.cifwk.taf.tools.cli.handlers.impl.RemoteObjectHandler;
import com.ericsson.cifwk.taf.utils.FileFinder;
import com.ericsson.oss.taf.hostconfigurator.HostGroup;

@SuppressWarnings("deprecation")
@Operator(context = Context.CLI)
public class Network_ElementConnectivityCliOperator implements Network_ElementConnectivityOperator {


	Logger logger = Logger.getLogger(Network_ElementConnectivityCliOperator.class);
	private static final String TRIGGER_PATH = "/netsim/inst/POC/";
	private static final String FileName = "simulationTextFile.txt";

	//Host host = DataHandler.getHostByType(HostType.RC);
	Host host = HostGroup.getOssmaster();
	private CLI cli = new CLI(host);
	public User operUser; 
	private Shell shell;

	@Override
	public void initialize() {
		//Host host = DataHandler.getHostByName(hostName);
		//Host host = DataHandler.getHostByType(HostType.RC);
		Host host = HostGroup.getOssmaster();
		System.out.println("The host server is :"+ host);
		operUser = new User(host.getUser(UserType.OPER),host.getPass(UserType.OPER),UserType.OPER);
		System.out.println("The User name is :"+ operUser);
		//CLICommandHelper helper = new CLICommandHelper(host, operUser);
		//helper = new CLICommandHelper(host, operUser);
		//cli = new CLI(host);
		cli = new CLI(host,operUser);
		if(shell == null){
			shell = cli.openShell();
			logger.debug("Creating new shell instance");
		}
	}
	@Override
	public void getFile() throws FileNotFoundException {
		//Host host = DataHandler.getHostByName(hostname);
		//Host host = DataHandler.getHostByType(HostType.RC);
		Host host = HostGroup.getOssmaster();
		RemoteObjectHandler remote = new RemoteObjectHandler(host);
		String fileLocation = "/tmp/nodetest.txt";
		System.out.println(fileLocation);
		String remoteFileLocation = "/home/nmsadm/nodetest.txt";         //unix address
		remote.copyRemoteFileToLocal(remoteFileLocation ,fileLocation);
		logger.debug("Copying " +remoteFileLocation+ " to " +fileLocation);
		System.out.println("transfer done\n");
	}	


	@Override
	public void sendFileRemotely(String fileName, String fileServerLocation) throws FileNotFoundException {
		//Host host = DataHandler.getHostByName(hostname);
		//Host host1 = DataHandler.getHostByType(HostType.RC);
		Host host1 = HostGroup.getOssmaster();
		CLICommandHelper cmdHelper=new CLICommandHelper(host1, host1.getUsers(UserType.ADMIN).get(0));
		Host host = DataHandler.getHostByType(HostType.GATEWAY);

		RemoteObjectHandler remote = new RemoteObjectHandler(host);
		List<String> fileLocation = FileFinder.findFile(fileName);
		System.out.println("Pavan------------>" +fileLocation.get(0));
		String remoteFileLocation = fileServerLocation;         //unix address
		remote.copyLocalFileToRemote(fileLocation.get(0) ,remoteFileLocation);
		System.out.println("scp "+ remoteFileLocation+"/"+fileName+" nmsadm@ossmaster:"+remoteFileLocation);
		cmdHelper.openShell(); 
		cmdHelper.runInteractiveScript("scp "+ remoteFileLocation+"/"+fileName+" nmsadm@ossmaster:"+remoteFileLocation); 
		cmdHelper.expect("Password:"); 
		cmdHelper.interactWithShell("nms27511");
		cmdHelper.disconnect();



		logger.debug("Copying " +fileName+ " to " +remoteFileLocation+ " on remote host");
		//executeCommand("dos2unix /home/nmsadm/script/Pre_check.sh");


	}

	@Override
	public void deleteRemoteFile(String fileName, String fileServerLocation) throws FileNotFoundException {
		//Host host = DataHandler.getHostByName(hostname);
		//Host host = DataHandler.getHostByType(HostType.RC);
		Host host = HostGroup.getOssmaster();
		RemoteObjectHandler remoteObjectHandler = new RemoteObjectHandler(host);
		String remoteFileLocation = fileServerLocation;
		remoteObjectHandler.deleteRemoteFile(remoteFileLocation+fileName);
		logger.debug("deleting " +fileName+ " at location " +remoteFileLocation+ " on remote host");
	}



	@Override
	public Shell executeCommand(String... commands) {
		return cli.executeCommand(commands);
	}

	@Override
	public String executeCommandAndGetOuput(String commands,int timeout) {
		//Shell shell1 = executeCommand("dos2unix Pre_check.sh Pre_check.sh");
		Shell shell = executeCommand(commands);
		String output = shell.read(timeout);
		System.out.println(output);
		shell.disconnect();
		return output;
	}


	/* (non-Javadoc)
	 * @see com.ericsson.sut.test.operators.GenericOperator#execute()
	 */
	@Override
	public String execute() {
		// TODO Auto-generated method stub
		return null;
	}
	@Override
	public void disconnect() {
		logger.info("Disconnecting from shell");
		shell.disconnect();
		shell = null;
	}	
	@Override
	public String expect(String expectedText) throws TimeoutException{
		logger.debug("Expected return is " +expectedText);
		String found = shell.expect(expectedText);
		//System.out.println("Output of expect is " + found);
		return found;
	}

	@Override
	public String expect(String expectedText, long timeout) throws TimeoutException{
		logger.debug("Expected return is " +expectedText);
		String found = shell.expect(expectedText,timeout);
		System.out.println("Output of expect is " + found);
		return found;
	}

	@Override
	public void expectClose(int timeout) throws TimeoutException{
		shell.expectClose(timeout);
	}

	@Override
	public void scriptInput(String message) {
		logger.info("Writing " + message + " to standard in");
		shell.writeln(message);
		logger.info("Reading console--->>>" + shell.read());
	}

	@Override
	public String scriptOutput(String message) {
		logger.info("Writing " + message + " to standard in");
		shell.writeln(message);
		return shell.read();
	}
	
	@Override
	public void writeln(String command){
		String cmd = null;
		cmd = command;
		logger.trace("Writing " + cmd + " to standard input");
		logger.info("Executing commmand " + cmd);
		System.out.println("Executing commmand " + cmd);
		//System.out.println("Shell NULL?:"+(shell==null));
		shell.writeln(cmd);
	}
	@Override
	public String read(){
		String cmd=null;
		cmd=shell.read();
		return(cmd);
	}


	@Override
	public int getExitValue(){
		int exitValue = shell.getExitValue();
		logger.debug("Getting exit value from shell, exit value is :" + exitValue);
		return exitValue;
	}

	@Override
	public boolean isClosed() throws TimeoutException{
		return shell.isClosed();
	}

	public boolean simulationOperator(String networkElement, String script){

		try{
			User user = new User("netsim","netsim",UserType.CUSTOM);
			CLICommandHelper sshExecutor  = new CLICommandHelper(HostGroup.getAllNetsims().get(0),user);


			String neList[] = networkElement.split(";");

			String initialCommand = "rm -rf " + TRIGGER_PATH + FileName + " | touch " + TRIGGER_PATH + FileName;

			logger.info("Creating file on the path :  " +  TRIGGER_PATH);
			sshExecutor.execute(initialCommand);

			for(String ne : neList ){
				sshExecutor.execute("echo " + ne + " >> " + TRIGGER_PATH + FileName);
			}
			logger.info("Waiting for the script to execute....");

			String result = sshExecutor.execute("bash " + TRIGGER_PATH + script + " " +  TRIGGER_PATH + FileName);

			logger.info("Result from the script = " + result.toString());
			if(result.toString().contains("0")){

				return true;
			}
		}catch (Exception e){
			logger.debug(e.getMessage());
		}
		return false;
	}


	/*
    public Map<String, String> get(String step) {
        return loadData("Network_ElementConnectivity_CliTestData.csv", step);
    }*/

}

