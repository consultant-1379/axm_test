package com.ericsson.axm.test.cases;

import java.io.IOException;

import javax.inject.Inject;

import org.testng.annotations.Test;

import com.ericsson.axm.test.operators.Network_ElementConnectivityOperator;
import com.ericsson.axm.test.operators.TrussCollectionOperator;
import com.ericsson.cifwk.taf.TestCase;
import com.ericsson.cifwk.taf.TorTestCaseHelper;
import com.ericsson.cifwk.taf.annotations.Context;
import com.ericsson.cifwk.taf.annotations.DataDriven;
import com.ericsson.cifwk.taf.annotations.Input;
import com.ericsson.cifwk.taf.annotations.Output;
import com.ericsson.cifwk.taf.annotations.TestId;
import com.ericsson.cifwk.taf.guice.OperatorRegistry;

@SuppressWarnings("deprecation")
public class Network_ElementConnectivity_FunctionalTest extends
TorTestCaseHelper implements TestCase {

	@Inject
	private OperatorRegistry<Network_ElementConnectivityOperator> network_ElementConnectivityProvider;
	@Inject
	OperatorRegistry<TrussCollectionOperator> operatorRegistry;

	private TrussCollectionOperator getOperator() {
		return operatorRegistry.provide(TrussCollectionOperator.class);
	}

	/**
	 * @DESCRIPTION Verification of the network element connectivity for the
	 *              Telnet protocol
	 * @PRE EAM related Managed components should be online
	 * @PRIORITY HIGH
	 */
	@TestId(id = "OSS-13420_Func_3", title = "Verify the connectivity for the selected prototype")
	@Context(context = { Context.CLI })
	@Test(groups = { "CDB", "VCDB" }, priority=1)
	@DataDriven(name = "network_elementconnectivity_functionaltest")
	public void verifyTheConnectivityForTheSelectedPrototype(
			@Input("host") String host, @Input("timeout") int timeout,
			@Input("protocol") String node_protocol,
			@Output("output") String expected) throws IOException,
			InterruptedException {

		Network_ElementConnectivityOperator network_ElementConnectivityOperator = (Network_ElementConnectivityOperator) network_ElementConnectivityProvider
				.provide(Network_ElementConnectivityOperator.class);

		network_ElementConnectivityOperator.initialize();
		String protocol = null;
		int i = 4;
		String command = null;
		String daemon = null;
		String temp_core = null;
		String core_file = null;
		int final_core = 0;
		command = "/usr/bin/ls /ossrc/upgrade/core/ | /usr/bin/wc -l";
		/*String command2 = String
				.format("ps -ef |grep ehip_ac_in |grep -v |grep awk -F '{print $2}'`"); */
		temp_core = network_ElementConnectivityOperator
				.executeCommandAndGetOuput(command, timeout);
		temp_core = temp_core.replaceAll("\\s+", "");
		// System.out.println("the number of core dump files are" + temp_core);
		int initial_core = Character.getNumericValue(temp_core.charAt(0));
		// System.out.println("the number of core dump files are " +
		// initial_core);
		/*try {
			String root = "su - root";
			network_ElementConnectivityOperator.writeln(root);
			network_ElementConnectivityOperator.expect("Password:", 30);
			network_ElementConnectivityOperator.scriptInput("shroot12\r");
			network_ElementConnectivityOperator.expect("root", 30);

			String address = network_ElementConnectivityOperator
					.executeCommandAndGetOuput(command2, timeout);
			String truss = String
					.format("truss -xall -wall -rall -vall -all  -ulibeai::  -dD  -o   /tmp/ehip_ac_in.txt -p %s &",
							address);
			String nmsadm = "su - nmsadm";
			network_ElementConnectivityOperator.writeln(nmsadm);
			network_ElementConnectivityOperator.expect("nmsadm", 30);
		} catch (Exception e) {
			e.printStackTrace();
			String flag = "FAIL";
			System.out.println("user is not nmsadm\n");
			assertTrue(flag.contains("PASS"));
		}*/
		network_ElementConnectivityOperator.writeln("tcsh");
		int bsc_count = 0;
		int mscbc_count = 0;
		int bscl_count = 0;
		int node_num = 0;
		int resp_received = 0;
		String node = null;
		for (;;) {
			command = String
					.format("/opt/ericsson/bin/eac_esi_config -nl | awk 'NR==%d{print $1}'",
							i);
			 System.out.println("Ananthi: -nl "+command);
			node = network_ElementConnectivityOperator
					.executeCommandAndGetOuput(command, timeout);
			node = node.replaceAll("\\s+", "");
			if (node.contains("_")) {
				i++;
				continue;
			}
			if (node.length() < 1) {
				break;
			}

			String command1 = String
					.format("/opt/ericsson/bin/eac_esi_config -ne %s |/usr/bin/grep cr_protocol | /usr/bin/cut -d \" \" -f7",
							node);
			System.out.println("Protocol: "+command1);
			protocol = network_ElementConnectivityOperator
					.executeCommandAndGetOuput(command1, timeout);
			 System.out.println("value of protocol is"+protocol);
			 System.out.println("value of node_protocol is"+node_protocol);
			if (protocol.contains(node_protocol)) {
				node_num++;
				// System.out.println("value of node_num is"+node_num);
				command1 = String
						.format("/opt/ericsson/bin/eac_esi_config -ne %s |/usr/bin/grep cr_daemon | /usr/bin/cut -d \" \" -f9",
								node);
				System.out.println("Cr Daemon : "+command1);
				daemon = network_ElementConnectivityOperator
						.executeCommandAndGetOuput(command1, timeout);
				daemon = daemon.replaceAll("\\s+", "");
				/*
				 * if (daemon.equals("ehip_ac_in")) { bsc_count++; //
				 * System.out.println("value of bsc_count is "+bsc_count); }
				 * else if (daemon.equals("ehiplx_ac_in")) { bscl_count++; //
				 * System.out.println("value of bscl_count is "+bscl_count); }
				 * else if (daemon.equals("ehms_ac_in")) { mscbc_count++; //
				 * System.out.println("value of mscbc_count is "+mscbc_count); }
				 * else { i++; continue; }
				 */
				System.out.println("value of bsc_count b4 if stmnt is "+bsc_count);
				if (bsc_count >= 1 && daemon.equals("ehip_ac_in")) {
					
					i++;
					continue;
				}
				if (bscl_count >= 1 && daemon.equals("ehiplx_ac_in")) {
					i++;
					continue;
				}
				if (mscbc_count >= 1 && daemon.equals("ehms_ac_in")) {
					i++;
					continue;
				}
				try {
					String node_connect = String.format(
							"/opt/ericsson/bin/eaw NE=%s", node);
					network_ElementConnectivityOperator.writeln(node_connect);
					network_ElementConnectivityOperator.expect("<", 45);
				} catch (Exception e) {
					// String flag = "FAIL";
					System.out.println("Network Element " + node
							+ " is not connected \n");
					// assertTrue(flag.contains("PASS"));
				}
				try {
					String output =	network_ElementConnectivityOperator.scriptOutput("caclp;\r");

					int retrycount = 0;
					while (!output.contains("TIME") && retrycount < 10){
						try {
							Thread.sleep(45);
						} catch (InterruptedException e) {
							e.printStackTrace();
						}
						retrycount ++;
					}

					if(output.contains("TIME")){
						String flag = "PASS";
						resp_received = 1;
						System.out.println("PAaSS\n");
						assertTrue(flag.contains("PASS"));
					}
					network_ElementConnectivityOperator.scriptInput("quit;\r");

					/*if (network_ElementConnectivityOperator
							.expect("nmsadm", 45) != "NULL") {
						String flag = "PASS";
						resp_received = 1;
						System.out.println("PASS\n");
						assertTrue(flag.contains("PASS"));
					}*/
				} catch (Exception e) {
					// String flag = "FAIL";
					System.out
					.println("We are not able to receive the intended response from the Network Element "
							+ node);
					// assertTrue(flag.contains("PASS"));
				}
				if (resp_received == 1) {
					if (daemon.equals("ehip_ac_in")) {
						bsc_count++;
						System.out.println("value of bsc_count is "+bsc_count);
					} else if (daemon.equals("ehiplx_ac_in")) {
						bscl_count++;
						// System.out.println("value of bscl_count is "+bscl_count);
					} else if (daemon.equals("ehms_ac_in")) {
						mscbc_count++;
						// System.out.println("value of mscbc_count is "+mscbc_count);
					} else {
						i++;
						continue;
					}
				}
				resp_received = 0;
			}
			i++;
		}
		if (node_num < 1) {
			String flag = "FAIL";
			System.out.println("There are no " + node_protocol
					+ "protocol based nodes");
			assertTrue(flag.contains("PASS"));
		}
		System.out.println("AXM Achievers");
		if (bsc_count < 1) {
			//String flag = "FAIL";
			System.out.println("value of bsc_count is "+bsc_count);
			System.out
			.println("Warning: There are no " + node_protocol +" connecting nodes with cr_daemon : ehip_ac_in");
			//assertTrue(flag.contains("PASS"));
		}
		if (bscl_count < 1) {
			String flag = "FAIL";
			System.out
			.println("There are no connecting nodes with cr_daemon : ehiplx_ac_in");
			assertTrue(flag.contains("PASS"));
		}
		if (mscbc_count < 1) {
			// String flag = "FAIL";
			System.out
			.println("Warning: There are no "
					+ node_protocol
					+ " protocol based connecting nodes with cr_daemon : ehms_ac_in");
			// assertTrue(flag.contains("PASS"));
		}
		node_num = bsc_count = bscl_count = mscbc_count = 0;
		command = "/usr/bin/ls /ossrc/upgrade/core/ | /usr/bin/wc -l";
		temp_core = network_ElementConnectivityOperator
				.executeCommandAndGetOuput(command, timeout);
		temp_core = temp_core.replaceAll("\\s+", "");
		final_core = Character.getNumericValue(temp_core.charAt(0));
		int diff = final_core - initial_core;
		while (diff > 0) {
			command = String
					.format("/usr/bin/ls -lrt /ossrc/upgrade/core/ | awk 'NR==%d{print $9}'",
							initial_core + 2);
			core_file = network_ElementConnectivityOperator
					.executeCommandAndGetOuput(command, timeout);
			if ((core_file.contains("ehm")) || (core_file.contains("eac"))
					|| (core_file.contains("ehip"))
					|| (core_file.contains("ehema"))
					|| (core_file.contains("ehap"))
					|| (core_file.contains("eht"))) {
				String flag3 = "FAIL";
				System.out
				.println("coredump is produced while executing the testcase for "
						+ node_protocol + " protocol based nodes");
				System.out.println("core dump file is " + core_file);
				assertTrue(flag3.contains("PASS"));
			}
			diff--;
		}
		network_ElementConnectivityOperator.disconnect();
		//network_ElementConnectivityOperator.executeCommandAndGetOuput(command2, timeout);
	}

	@TestId(id = "CIS-27502_Func_2", title = "Kill Truss Process")
	@Context(context = { Context.CLI })
	@Test(groups = { "CDB", "VCDB" }, priority=2)
	public void verifyTrussProcessKill() {
		assertTrue(getOperator().trussProcessKill());
	}
	
}

