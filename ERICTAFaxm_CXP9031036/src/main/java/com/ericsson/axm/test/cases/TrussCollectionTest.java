package com.ericsson.axm.test.cases;

import javax.inject.Inject;

import java.io.IOException;

import org.testng.annotations.Test;

import com.ericsson.cifwk.taf.TestCase;
import com.ericsson.cifwk.taf.TorTestCaseHelper;
import com.ericsson.cifwk.taf.annotations.*;
import com.ericsson.cifwk.taf.guice.OperatorRegistry;
import com.ericsson.axm.test.operators.TrussCollectionOperator;

public class TrussCollectionTest extends TorTestCaseHelper implements TestCase {

  @Inject
  OperatorRegistry<TrussCollectionOperator> operatorRegistry;

  private TrussCollectionOperator getOperator() {
    return operatorRegistry.provide(TrussCollectionOperator.class);
  }

  @TestId(id = "CIS-27502_Func_1", title = "Start Truss Log Collection")
  @Context(context = {Context.CLI})
  @Test(groups={"CDB" , "VCDB"})
  public void verifyTrussLogCollection(){
    assertNotNull(getOperator().findTrussProcessId());
    getOperator().startTrussLogCollection();
  }

}
