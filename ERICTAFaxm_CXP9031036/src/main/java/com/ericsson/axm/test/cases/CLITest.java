package com.ericsson.axm.test.cases;

import java.io.*;
import java.nio.file.Files;
import java.util.ArrayList;

import org.testng.annotations.Test;
import org.apache.log4j.Logger;

import com.ericsson.cifwk.taf.TestCase;
import com.ericsson.cifwk.taf.TorTestCaseHelper;
import com.ericsson.cifwk.taf.annotations.*;
import com.ericsson.cifwk.taf.guice.OperatorRegistry;
import com.ericsson.cifwk.taf.tools.cli.Shell;
import com.ericsson.axm.test.operators.GenericOperator;
import com.google.inject.Inject;

public class CLITest extends TorTestCaseHelper implements TestCase {

	@Inject
	OperatorRegistry<GenericOperator> operatorRegistry;

	private GenericOperator getOperator() {
		return operatorRegistry.provide(GenericOperator.class);
	}

	// private String command;
	int initial_core;
	Logger logger = Logger.getLogger(CLITest.class);

	@TestId(id = "OSS-13420_Func_3", title = "Verify the connectivity for the selected prototype")
	@Test(groups = { "KGB" })
	@Context(context = { Context.CLI })
	@DataDriven(name = "precheck")
	public void preExecuteMethod(@Input("host") String host,
			@Input("scriptName") String scriptName,
			@Input("remoteScriptPath") String remotePath,
			@Input("timeout") int timeout,
			@Input("Node_type") String Node_type,
			@Output("output") String expected) {
		try {
			logger.info("Initailizing File Setup....");
			getOperator().initialize();
			logger.info("End of File Setup....");
			System.out.println("sending\n");
			getOperator().sendFileRemotely(scriptName, remotePath);
			getOperator().sendFileRemotely("test_connection.tcl", remotePath);
		} catch (Exception e) {
			e.printStackTrace();
		}
		// operator.initialize();
		String command = null;
		String actual = null;
		String flag = null;
		String flag1 = null;
		String flag2 = null;
		System.out.println("done\n");
		// Coredumps check code
		String core_file = null;
		String temp_core = null;
		int final_core = 0;
		do {
			command = "/usr/bin/ls /ossrc/upgrade/core/ | /usr/bin/wc -l";
			temp_core = getOperator().executeCommandAndGetOuput(command,
					timeout);
			logger.info("the core_dump file = " + temp_core);
			temp_core = temp_core.replaceAll("\\s+", "");
			System.out.println("the core_dump length = " + temp_core);
		} while (temp_core == null || temp_core.length() < 1);
		try {
			initial_core = Integer.parseInt(temp_core);
		} catch (NumberFormatException ex) {
			System.out
					.println("the number of initial core dumps in catch block"
							+ initial_core);
		}
		System.out
				.println("the number of core dump files are before executing the testcase"
						+ initial_core);

		// coredumps end
		if (scriptName.endsWith(".zip")) {
			// command = "/usr/bin/rm -r /home/nmsadm/TAF";
			// actual = operator.executeCommandAndGetOuput(command,timeout);
			command = "/usr/bin/unzip " + remotePath + scriptName;
			actual = getOperator().executeCommandAndGetOuput(command, timeout);
			logger.info("Actual value in zip statement :: " + actual);
			logger.info("Excepted in zip :: " + expected);
			assertTrue(actual.contains(expected));
		} else {
			if (scriptName.endsWith(".pl")) {
				command = "/usr/local/bin/perl " + remotePath + scriptName;
			} else if (scriptName.endsWith(".sh")) {
				command = "/bin/sh " + remotePath + scriptName;
			}
			actual = getOperator().executeCommandAndGetOuput(command, timeout);
			logger.info("Actual value in pl statement :: " + actual);
			logger.info("Excepted in pl :: " + expected);
			// assertTrue(actual.contains(expected));
		}
		// coredumps check
		do {
			command = "/usr/bin/ls /ossrc/upgrade/core/ | /usr/bin/wc -l";
			temp_core = getOperator().executeCommandAndGetOuput(command,
					timeout);
			temp_core = temp_core.replaceAll("\\s+", "");
		} while (temp_core == null || temp_core.length() < 1);
		final_core = Character.getNumericValue(temp_core.charAt(0));
		logger.info("the number of core dump files are After executing the testcase"
				+ final_core);
		int diff = final_core - initial_core;
		while (diff > 0) {
			command = String
					.format("/usr/bin/ls -lrt /ossrc/upgrade/core/ | awk 'NR==%d{print $9}'",
							initial_core + 2);
			core_file = getOperator().executeCommandAndGetOuput(command,
					timeout);
			if ((core_file.contains("ehm")) || (core_file.contains("eac"))
					|| (core_file.contains("ehip"))
					|| (core_file.contains("ehema"))
					|| (core_file.contains("ehap"))
					|| (core_file.contains("eht"))) {
				flag = "FAIL";
				// System.out.println("coredump is produced while executing the testcase "+scriptName);
				// System.out.println("core dump file is " + core_file);
				// assertTrue(flag.contains("PASS"));
			}
			diff--;
		}
		// Coredumps check end
		// here we have to deciside whether the test case is excuted properly
		// with out coredumps or not
		if (flag == "FAIL") {
			System.out
					.println("coredump is produced while executing the testcase "
							+ scriptName);
			logger.info("core dump file is " + core_file);
			assertTrue(flag.contains("PASS"));
		} else {
			logger.info("Test case/script is excuted with out any coredump "
					+ scriptName);
			logger.info("Actual at end :: " + actual);
			logger.info("Expected at end :: " + expected);
			assertTrue(actual.contains(expected));

		}
	}

	@TestId(id = "OSS-13420_Func_3", title = "Verify the connectivity for the selected prototype")
	@Test(groups = { "Acceptance" }, dependsOnMethods = { "preExecuteMethod" })
	@Context(context = { Context.CLI })
	@DataDriven(name = "executeScriptData")
	public void testAxmScripts(@Input("host") String host,
			@Input("scriptName") String scriptName,
			@Input("remoteScriptPath") String remotePath,
			@Input("timeout") int timeout,
			@Input("Node_type") String Node_type,
			@Output("output") String expected) {
		// first initialize your cli
		getOperator().initialize();

		// transfer your scripts
		String actual = null;
		try {
			getOperator().sendFileRemotely(scriptName, remotePath);
		} catch (Exception e) {
			e.printStackTrace();
		}
		// Coredumps check
		String command = null;
		String temp_core = null;
		String core_file = null;
		String flag = null;
		String flag1 = null;
		String flag2 = null;
		int final_core = 0;
		do {
			command = "/usr/bin/ls /ossrc/upgrade/core/ | /usr/bin/wc -l";
			temp_core = getOperator().executeCommandAndGetOuput(command,
					timeout);
			temp_core = temp_core.replaceAll("\\s+", "");
		} while (temp_core == null || temp_core.length() < 1);
		logger.info("the number of core dump files are before executing the testcase"
				+ temp_core);
		int initial_core = Character.getNumericValue(temp_core.charAt(0));
		// core dumps end
		if (scriptName.endsWith(".pl")) {
			command = "/usr/local/bin/perl " + remotePath + scriptName;
		} else if (scriptName.endsWith(".sh")) {
			command = "/bin/sh " + remotePath + scriptName;
		}

		int timeout_per_script = timeout;
		String RR = "/home/nmsadm/taf/testing.txt";
		String ALL_NODES = getOperator().executeCommandAndGetOuput(
				"/bin/cat /home/nmsadm/taf/testing.txt", 25);
		System.out.println("Ananthi:RR-"+RR);
		System.out.println("Ananthi:ALL_NODES-"+ALL_NODES);
		String test_shell=getOperator().executeCommandAndGetOuput("/usr/bin/ls /home/nmsadm/taf/",30);
		System.out.println(test_shell+" TestShell Ananthi");
		System.out.println();
		if (ALL_NODES.contains(RR)) {
			logger.info("Ananthi");
			logger.info("Since no nodes related file is not present on the server we are exisiting the execution of the frame work");
//			System.exit(0);
		}
		/*
		 * Always commented start ArrayList output =
		 * operator.execute_nodes(ALL_NODES); String[] array1=(String[])
		 * output.get(0); String[] array2=(String[]) output.get(1); String[]
		 * array3=(String[]) output.get(2); String [] array4=(String[])
		 * output.get(3); int k=0; System.out.println();
		 * System.out.println("BSC Array "); for(int j=1;j<array1.length;j++) {
		 * 
		 * System.out.print(array1[j]+ "  "); //All_NODES[k]=array1[j]; //k++; }
		 * System.out.println(); System.out.println("BSC_linux Array"); //in
		 * Array Zero-th element is the NODE/array name for(int
		 * j=1;j<array2.length;j++) { System.out.print(array2[j]+"  ");
		 * 
		 * } System.out.println(); System.out.println("MSCBC Array"); for(int
		 * j=1;j<array3.length;j++) { System.out.print(array3[j]+ "  ");
		 * 
		 * } System.out.println(); //XRAJPAS : ALL NODES information
		 * System.out.println("ALL NODES AArray"); for(int j=0;j<
		 * array4.length;j++) { System.out.print(array4[j]+ "  ");
		 * 
		 * } Always commented END
		 */
		flag = "PASS";
		if ((Node_type.equals("MSCBC"))) {
			for (int j = 1; j < 2; j++)// narray3.length;j++)
			{
				// System.out.print(array3[j]+ "  ");
				String MSCBC_NAME = "/bin/cat /home/nmsadm/taf/testing.txt | /bin/cut -d \"^\" -f3 | /bin/cut -d \":\" -f2";
				String mscbc_node_name = getOperator()
						.executeCommandAndGetOuput(MSCBC_NAME,
								timeout_per_script);
				String arr[] = mscbc_node_name.replaceAll("\\s+", "").split(
						"ossmaster", 2);
				mscbc_node_name = arr[0];
				String command1 = command + " " + mscbc_node_name;
				// System.out.print("Test case for the Node : "+array3[j]+
				// "  ");
				actual = getOperator().executeCommandAndGetOuput(command1,
						timeout_per_script);
				logger.info("Actual value in MSCBC :: " + actual);
				logger.info("Expected in MSCBC :: " + expected);
				if (!actual.contains(expected)) {
					logger.info("\nTest case is failed  :MSCBC NODE");
					flag = "Fail";
				}
			}
			// assertTrue(actual.contains(flag));
		} else if ((Node_type.equals("BSC"))) {
			flag = "PASS";
			for (int j = 1; j < 2; j++)// array1.length;j++)
			{
				// System.out.print(array1[j]+ "  ");
				// String command1 = command + " " + array1[j];
				// System.out.print("Test case for the Node : "+array1[j]+
				// "  ");
				String BSC_NAME = "/bin/cat /home/nmsadm/taf/testing.txt | /bin/cut -d \"^\" -f1 | /bin/cut -d \":\" -f2";
				String bsc_node_name = getOperator().executeCommandAndGetOuput(
						BSC_NAME, timeout_per_script);
				String arr[] = bsc_node_name.replaceAll("\\s+", "").split(
						"ossmaster", 2);
				bsc_node_name = arr[0];
				String command1 = command + " " + bsc_node_name;
				actual = getOperator().executeCommandAndGetOuput(command1,
						timeout_per_script);
				logger.info("Actual value in BSC :: " + actual);
				logger.info("Expected in BSC :: " + expected);
				if (!actual.contains(expected)) {
					logger.info("\nTest case is failed  :NO_NODE");
					flag = "Fail";
				}
			}
			// assertTrue(actual.contains(flag));
		} else if ((Node_type.equals("NO_NODE"))) {
			flag = "PASS";
			String command1 = command;
			actual = getOperator().executeCommandAndGetOuput(command1,
					timeout_per_script);
			logger.info("Actual value in NO_NODE :: " + actual);
			logger.info("Expected in NO_NODE :: " + expected);
			if (!actual.contains(expected)) {
				logger.info("\nTest case is failed  :NO_NODE");
				flag = "Fail";
			}
			// assertTrue(actual.contains(flag));
		}

		else if ((Node_type.equals("BSC_LINUX"))) {
			flag = "PASS";
			for (int j = 1; j < 2; j++)// array2.length;j++)
			{
				// System.out.print(array2[j]+ "  ");
				// String command1 = command + " " + array2[j];
				// System.out.print("Test case for the Node : "+array2[j]+
				// "  ");
				String BSCL_NAME = "/bin/cat /home/nmsadm/taf/testing.txt | /bin/cut -d \"^\" -f2 | /bin/cut -d \":\" -f2";
				String bscl_node_name = getOperator()
						.executeCommandAndGetOuput(BSCL_NAME,
								timeout_per_script);
				String arr[] = bscl_node_name.replaceAll("\\s+", "").split(
						"ossmaster", 2);
				bscl_node_name = arr[0];
				String command1 = command + " " + bscl_node_name;
				actual = getOperator().executeCommandAndGetOuput(command1,
						timeout_per_script);
				logger.info("Actual value in BSC_LINUX :: " + actual);
				logger.info("Expected BSC_LINUX :: " + expected);
				if (!actual.contains(expected)) {
					logger.info("\nTest case is failed  :NO_NODE");
					flag = "Fail";
				}
			}
			// assertTrue(actual.contains(flag));
		} else if ((Node_type.equals("ALL_NODES"))) {
			flag = "PASS";
			for (int j = 1; j < 2; j++)// array4.length;j++)
			{
				// System.out.print(array4[j]+ "  ");
				// String command1 = command + " " + array4[j];
				// System.out.print("Test case for the Node : "+array4[j]+
				// "  ");
				String BSCL_NAME = "/bin/cat /home/nmsadm/taf/testing.txt | /bin/cut -d \"^\" -f2 | /bin/cut -d \":\" -f2";
				String bscl_node_name = getOperator()
						.executeCommandAndGetOuput(BSCL_NAME,
								timeout_per_script);
				String arr[] = bscl_node_name.replaceAll("\\s+", "").split(
						"ossmaster", 2);
				bscl_node_name = arr[0];
				String command1 = command + " " + bscl_node_name;
				actual = getOperator().executeCommandAndGetOuput(command1,
						timeout_per_script);
				logger.info("Actual value in ALL_NODES :: " + actual);
				logger.info("Expected in ALL_NODES :: " + expected);
				if (!actual.contains(expected)) {
					System.out.print("\nTest case is failed  :NO_NODE");
					flag = "Fail";
				}
			}
			// assertTrue(actual.contains(flag));
		}
		// Coredumps check
		do {
			command = "/usr/bin/ls /ossrc/upgrade/core/ | /usr/bin/wc -l";
			temp_core = getOperator().executeCommandAndGetOuput(command,
					timeout);
			temp_core = temp_core.replaceAll("\\s+", "");
		} while (temp_core == null || temp_core.length() < 1);
		final_core = Character.getNumericValue(temp_core.charAt(0));
		logger.info("the number of core dump files are After executing the testcase"
				+ final_core);
		int diff = final_core - initial_core;
		while (diff > 0) {
			command = String
					.format("/usr/bin/ls -lrt /ossrc/upgrade/core/ | awk 'NR==%d{print $9}'",
							initial_core + 2);
			core_file = getOperator().executeCommandAndGetOuput(command,
					timeout);
			if ((core_file.contains("ehm")) || (core_file.contains("eac"))
					|| (core_file.contains("ehip"))
					|| (core_file.contains("ehema"))
					|| (core_file.contains("ehap"))
					|| (core_file.contains("eht"))) {
				flag1 = "FAIL";
				// System.out.println("coredump is produced while executing the testcase "+scriptName);
				// System.out.println("core dump file is " + core_file);
				// assertTrue(flag1.contains("PASS"));
			}
			diff--;
		}
		// Coredump check end
		// here we have to deciside whether the test case is excuted properly
		// with out coredumps or not
		if (flag1 == "FAIL") {
			logger.info("coredump is produced while executing the testcase "
					+ scriptName);
			logger.info("core dump file is " + core_file);
			assertTrue(flag1.contains("PASS"));
		} else {
			logger.info("Test case/script is excuted with out any coredump "
					+ scriptName);
			assertTrue(actual.contains(flag));
		}

	}

	@TestId(id = "OSS-13420_Func_3", title = "Verify the connectivity for the selected prototype")
	@Test(groups = { "Acceptance" }, dependsOnMethods = { "testAxmScripts" })
	@Context(context = { Context.CLI })
	@DataDriven(name = "Regression_test_cases")
	public void Regression_suite(@Input("host") String host,
			@Input("scriptName") String scriptName,
			@Input("remoteScriptPath") String remotePath,
			@Input("timeout") int timeout,
			@Input("Node_type") String Node_type,
			@Output("output") String expected) {

		// first initialize your cli
		getOperator().initialize();

		// transfer your scripts
		// Transfering to the path
		String actual = null;
		try {
			getOperator().sendFileRemotely(scriptName, remotePath);
		} catch (Exception e) {
			e.printStackTrace();
		}
		// Coredumps check
		String command = null;
		String core_file = null;
		String temp_core = null;
		String flag = null;
		String flag1 = null;
		String flag2 = null;
		int final_core = 0;

		do {
			command = "/usr/bin/ls /ossrc/upgrade/core/ | /usr/bin/wc -l";
			temp_core = getOperator().executeCommandAndGetOuput(command,
					timeout);
			temp_core = temp_core.replaceAll("\\s+", "");
		} while (temp_core == null || temp_core.length() < 1);
		logger.info("the number of core dump files are before executing the testcase"
				+ temp_core);
		int initial_core = Character.getNumericValue(temp_core.charAt(0));
		// Core dumps check ends
		if (scriptName.endsWith(".pl")) {
			command = "/usr/local/bin/perl " + remotePath + scriptName;
		} else if (scriptName.endsWith(".sh")) {
			command = "/bin/sh " + remotePath + scriptName;
		}
		// System.out.println("here is we need to focus");
		int timeout_per_script = timeout;

		String RR = "/home/nmsadm/taf/testing.txt";

		String ALL_NODES = getOperator().executeCommandAndGetOuput(
				"/bin/cat /home/nmsadm/taf/testing.txt", 25);
	
	if (ALL_NODES.contains(RR)) {

			System.out.println("raja u r not closing this");
			// String Dummy =
			// operator.executeCommandAndGetOuput("/usr/local/bin/perl /home/nmsadm/script/node_poll.pl",100);
			// System.out.println("The node_pool output : "+ Dummy);
	//		System.exit(0);
		}
		/*
		 * ArrayList output = operator.execute_nodes(ALL_NODES);
		 * 
		 * String[] array1=(String[]) output.get(0); String[] array2=(String[])
		 * output.get(1); String[] array3=(String[]) output.get(2); String []
		 * array4=(String[]) output.get(3); int k=0; System.out.println();
		 * System.out.println("BSC Array "); for(int j=1;j<array1.length;j++) {
		 * 
		 * System.out.print(array1[j]+ "  "); //All_NODES[k]=array1[j]; //k++; }
		 * System.out.println(); System.out.println("BSC_linux Array"); //in
		 * Array oth element is the NODE/array name for(int
		 * j=1;j<array2.length;j++) { System.out.print(array2[j]+"  ");
		 * //All_NODES[k]=array2[j]; //k++; } System.out.println();
		 * System.out.println("MSCBC Array"); for(int j=1;j<array3.length;j++) {
		 * System.out.print(array3[j]+"  "); //All_NODES[k]=array3[j]; //k++; }
		 * System.out.println(); //XRAJPAS : ALL NODES information
		 * /*System.out.println("ALL NODES AArray"); for(int
		 * j=0;j<All_NODES.length;j++) { System.out.print(All_NODES[j]+"  ");
		 * 
		 * } // String actual =
		 * operator.executeCommandAndGetOuput(command,timeout_per_script);
		 * System.out.println("Actual value = " + actual);
		 * 
		 * //assertTrue(actual.contains(expected)); //execute scripts
		 * System.out.println("ALL NODES AArray"); for(int j=0;j<
		 * array4.length;j++) { System.out.print(array4[j]+ "  ");
		 * 
		 * }
		 */
		flag = "PASS";

		if ((Node_type.equals("NO_NODE"))) {
			actual = getOperator().executeCommandAndGetOuput(command,
					timeout_per_script);
			logger.info("Actual value in NO_NODE :: " + actual);
			if (!actual.contains(expected)) {
				System.out.print("\nTest case is failed  :NO_NODE");
				flag = "Fail";
			}
			// assertTrue(flag.equals("PASS"));
		} else {
			// String flag="PASS";
			logger.info("Node related test cases are running");
			if (Node_type.equals("BSC")) {
				for (int j = 1; j < 2; j++)// array1.length;j++)
				{
					// System.out.print(array1[j]+ "  ");

					// String command1 = command +" "+ array1[j];
					// System.out.print("Test case for the Node : "+array1[j]+
					// "  ");
					// actual =
					// operator.executeCommandAndGetOuput(command1,timeout_per_script);
					// System.out.println("Actual value = " + actual);
					String BSC_NAME = "/bin/cat /home/nmsadm/taf/testing.txt | /bin/cut -d \"^\" -f1 | /bin/cut -d \":\" -f2";
					String bsc_node_name = getOperator()
							.executeCommandAndGetOuput(BSC_NAME,
									timeout_per_script);
					String arr[] = bsc_node_name.replaceAll("\\s+", "").split(
							"ossmaster", 2);
					bsc_node_name = arr[0];
					String command1 = command + " " + bsc_node_name;
					actual = getOperator().executeCommandAndGetOuput(command1,
							timeout_per_script);
					System.out.println("Actual value = " + actual);

					if (!actual.contains(expected)) {
						System.out
								.print("\nTest case is failed for the Node : "
										+ bsc_node_name + "  ");
						flag = "Fail";
					}
				}
				// assertTrue(flag.equals("PASS"));

			} else if (Node_type.equals("BSC_LINUX")) {
				for (int j = 1; j < 2; j++)// array2.length;j++)
				{
					// System.out.print(array2[j]+ "  ");
					// String command1 = command + " " + array2[j];
					// System.out.print("Test case for the Node : "+array2[j]+
					// "  ");
					// actual =
					// operator.executeCommandAndGetOuput(command1,timeout_per_script);
					// System.out.println("Actual value = " + actual);
					String BSCL_NAME = "/bin/cat /home/nmsadm/taf/testing.txt | /bin/cut -d \"^\" -f2 | /bin/cut -d \":\" -f2";
					String bscl_node_name = getOperator()
							.executeCommandAndGetOuput(BSCL_NAME,
									timeout_per_script);
					String arr[] = bscl_node_name.replaceAll("\\s+", "").split(
							"ossmaster", 2);
					bscl_node_name = arr[0];
					String command1 = command + " " + bscl_node_name;
					actual = getOperator().executeCommandAndGetOuput(command1,
							timeout_per_script);
					logger.info("Actual value = " + actual);

					if (!actual.contains(expected)) {
						logger.info("\nTest case is failed for the Node : "
								+ bscl_node_name + "  ");
						flag = "Fail";
					}
				}
				// assertTrue(flag.equals("PASS"));
			} else if (Node_type.equals("MSCBC")) {
				for (int j = 1; j < 2; j++)// array3.length;j++)
				{
					// System.out.print(array3[j]+ "  ");
					// String command1 = command + " " + array3[j];
					// System.out.print("Test case for the Node : "+array3[j]+
					// "  ");
					// actual =
					// operator.executeCommandAndGetOuput(command1,timeout_per_script);
					// System.out.println("Actual value = " + actual);

					String MSCBC_NAME = "/bin/cat /home/nmsadm/taf/testing.txt | /bin/cut -d \"^\" -f3 | /bin/cut -d \":\" -f2";
					String mscbc_node_name = getOperator()
							.executeCommandAndGetOuput(MSCBC_NAME,
									timeout_per_script);
					String arr[] = mscbc_node_name.replaceAll("\\s+", "")
							.split("ossmaster", 2);
					mscbc_node_name = arr[0];
					String command1 = command + " " + mscbc_node_name;
					actual = getOperator().executeCommandAndGetOuput(command1,
							timeout_per_script);
					System.out.println("Actual value = " + actual);
					if (!actual.contains(expected)) {
						System.out
								.print("\nTest case is failed for the Node : "
										+ mscbc_node_name + "  ");
						flag = "Fail";
					}
				}
				// assertTrue(flag.equals("PASS"));
			}

			else if ((Node_type.equals("ALL_NODES"))) {
				flag = "PASS";
				for (int j = 1; j < 2; j++)// array4.length;j++)
				{
					// System.out.print(array4[j]+ "  ");
					// String command1 = command + " " + array4[j];
					// System.out.print("Test case for the Node : "+array4[j]+
					// "  ");
					// actual =
					// operator.executeCommandAndGetOuput(command1,timeout_per_script);
					// System.out.println("Actual value = " + actual);
					String BSCL_NAME = "/bin/cat /home/nmsadm/taf/testing.txt | /bin/cut -d \"^\" -f2 | /bin/cut -d \":\" -f2";
					String bscl_node_name = getOperator()
							.executeCommandAndGetOuput(BSCL_NAME,
									timeout_per_script);
					String arr[] = bscl_node_name.replaceAll("\\s+", "").split(
							"ossmaster", 2);
					bscl_node_name = arr[0];
					String command1 = command + " " + bscl_node_name;
					actual = getOperator().executeCommandAndGetOuput(command1,
							timeout_per_script);
					System.out.println("Actual value = " + actual);

					if (!actual.contains(expected)) {
						System.out.print("\nTest case is failed  :NO_NODE");
						flag = "Fail";
					}
				}
				// assertTrue(actual.contains(flag));
			}
		}

		/*
		 * System.out.println(
		 * "u came out of the loop since u dont have the files exisiting");
		 * actual = operator.executeCommandAndGetOuput(command,timeout);
		 * System.out.println("Actual value = " + actual);
		 * assertTrue(actual.contains(expected));
		 */
		// exit(0);

		// Coredumps check
		do {
			command = "/usr/bin/ls /ossrc/upgrade/core/ | /usr/bin/wc -l";
			temp_core = getOperator().executeCommandAndGetOuput(command,
					timeout);
			temp_core = temp_core.replaceAll("\\s+", "");
		} while (temp_core == null || temp_core.length() < 1);
		final_core = Character.getNumericValue(temp_core.charAt(0));
		System.out
				.println("the number of core dump files are After executing the testcase"
						+ final_core);
		int diff = final_core - initial_core;
		while (diff > 0) {
			command = String
					.format("/usr/bin/ls -lrt /ossrc/upgrade/core/ | awk 'NR==%d{print $9}'",
							initial_core + 2);
			core_file = getOperator().executeCommandAndGetOuput(command,
					timeout);
			if ((core_file.contains("ehm")) || (core_file.contains("eac"))
					|| (core_file.contains("ehip"))
					|| (core_file.contains("ehema"))
					|| (core_file.contains("ehap"))
					|| (core_file.contains("eht"))) {
				flag2 = "FAIL";
				// System.out.println("coredump is produced while executing the testcase "+scriptName);
				// System.out.println("core dump file is " + core_file);
				// assertTrue(flag2.contains("PASS"));
			}
			diff--;
		}
		// coredumps check ends
		// here we have to deciside whether the test case is excuted properly
		// with out coredumps or not
		if (flag2 == "FAIL") {
			System.out
					.println("coredump is produced while executing the testcase "
							+ scriptName);
			System.out.println("core dump file is " + core_file);
			assertTrue(flag2.contains("PASS"));
		} else {
			System.out
					.println("Test case/script is excuted with out any coredump "
							+ scriptName);
			assertTrue(actual.contains(flag));
		}

	}
}
