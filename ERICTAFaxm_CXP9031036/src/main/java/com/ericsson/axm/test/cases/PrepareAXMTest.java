/*------------------------------------------------------------------------------
 *******************************************************************************
 * COPYRIGHT Ericsson 2012
 *
 * The copyright to the computer program(s) herein is the property of
 * Ericsson Inc. The programs may be used and/or copied only with written
 * permission from Ericsson Inc. or in accordance with the terms and
 * conditions stipulated in the agreement/contract under which the
 * program(s) have been supplied.
 *******************************************************************************
 *----------------------------------------------------------------------------*/
package com.ericsson.axm.test.cases;

import java.io.IOException;
import java.util.List;

import javax.inject.Inject;

import org.apache.log4j.Logger;
import org.omg.CORBA.ORBPackage.InvalidName;
import org.omg.PortableServer.POAManagerPackage.AdapterInactive;
import org.omg.PortableServer.POAPackage.ServantAlreadyActive;
import org.omg.PortableServer.POAPackage.WrongPolicy;
import org.testng.annotations.*;

import com.ericsson.cifwk.taf.TestCase;
import com.ericsson.cifwk.taf.TorTestCaseHelper;
import com.ericsson.cifwk.taf.annotations.Context;
import com.ericsson.cifwk.taf.annotations.DataDriven;
import com.ericsson.cifwk.taf.annotations.Input;
import com.ericsson.cifwk.taf.annotations.TestId;
import com.ericsson.cifwk.taf.guice.OperatorRegistry;
import com.ericsson.oss.taf.hostconfigurator.HostGroup;
import com.ericsson.axm.test.operators.AxmPreCheckApiOperator;

public class PrepareAXMTest extends TorTestCaseHelper implements TestCase {

	//private AxmOperators operatorInstance ;

	private static final Logger log = Logger.getLogger(PrepareAXMTest.class);
	final AxmPreCheckApiOperator axmPreCheckOperator = new AxmPreCheckApiOperator();
	private boolean activationStartTimedOut = true;
	private int checkHeartBeat;
	private int maxActivationTime = 0;
	private String networkElement = null;

	String sPattern="===================================";
	String aPattern="~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";
	String bPattern="-----------------------------------------------------------------------------------";	
	@Context(context = { Context.API})
	@Test(groups = { "KGB", "vCDB", "CDB" })
	@TestId(id = "OSS-13420_Func_3", title = "Simulation online and offline test case")
	@DataDriven(name = "Online_Offline_Simulation")
	public void simulationTestStart(
			@Input("NE") String ne)throws Exception{
		
		log.info("test === " );
		setTestStep("\n\n"+sPattern+" Online Simulation for Network Element : " + ne+"\n"+sPattern+"\n\n");
		final String startScript = "triggerStart.sh";
		networkElement = ne;
		boolean result = axmPreCheckOperator.simulationOperator(networkElement, startScript);
		assertTrue(result);
		
	}
	
}	
	
	
