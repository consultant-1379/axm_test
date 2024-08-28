package com.ericsson.axm.test.cases;


import java.io.*;
import java.nio.file.Files;
import java.util.ArrayList;

import org.testng.annotations.Test;

import com.ericsson.cifwk.taf.TestCase;
import com.ericsson.cifwk.taf.TorTestCaseHelper;
import com.ericsson.cifwk.taf.annotations.*;
import com.ericsson.cifwk.taf.guice.OperatorRegistry;
import com.ericsson.cifwk.taf.tools.cli.Shell;
import com.ericsson.axm.test.operators.GenericOperator;
import com.google.inject.Inject;

public class NNI_NM_KGB extends TorTestCaseHelper implements TestCase {

	@Inject
	OperatorRegistry<GenericOperator> operatorRegistry;
	//private String command;
	int initial_core; 
	
	@TestId(id = "OSS-13420_Func_3", title = "Verify the connectivity for the selected prototype")
	@Test(groups = {"KGB"})
	@Context(context = {Context.CLI})
	@DataDriven(name = "nnicheck")
	public void preExecuteMethod(@Input("host") String host, @Input("scriptName") String scriptName,
			@Input("remoteScriptPath") String remotePath,
			@Input("timeout") int timeout,
			@Input("Node_type") String Node_type,
			@Output("output") String expected) {

		          	GenericOperator operator = operatorRegistry.provide(GenericOperator.class);
                                operator.initialize();
               			try
                                {
                                                System.out.println("sending\n");
                                                operator.sendFileRemotely(scriptName, remotePath);
						operator.sendFileRemotely("test_connection.tcl", remotePath);
                                }
                                catch (FileNotFoundException e)
                                {
                                                e.printStackTrace();
                                }
			//	operator.initialize();
                                String command = null;
                                String actual=null;
				String flag=null;
				String flag1=null;
				String flag2=null;
                                System.out.println("done\n");
					if(scriptName.endsWith(".pl"))
					{
						command = "/usr/local/bin/perl " + remotePath + scriptName;
 					}	
					else if(scriptName.endsWith(".sh"))
					{
						command = "/bin/sh " + remotePath + scriptName;
					}	 
                               		actual = operator.executeCommandAndGetOuput(command,timeout);
                                	System.out.println("Actual value = " + actual);
                                	assertTrue(actual.contains(expected));
}
}
