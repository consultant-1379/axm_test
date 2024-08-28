package com.ericsson.axm.test.operators;

import com.ericsson.cifwk.taf.annotations.*;
import com.ericsson.cifwk.taf.data.Host;
import com.ericsson.cifwk.taf.data.UserType;
import com.ericsson.cifwk.taf.tools.cli.CLICommandHelper;
import com.ericsson.oss.taf.hostconfigurator.HostGroup;
import com.ericsson.axm.test.apiGetter.AxmCommandGetter;

import org.apache.log4j.Logger;

@Operator(context = Context.CLI)
public class TrussCollectionOperatorCli extends CLIOperator implements TrussCollectionOperator {

  Logger logger = Logger.getLogger(Network_ElementConnectivityCliOperator.class);

  private static Host host = HostGroup.getOssmaster();
  private static final CLICommandHelper cliCommandHelper = new CLICommandHelper(host, host.getUsers(UserType.ADMIN).get(0));

@Override
  public String findTrussProcessId(){
    logger.info("Finding Truss process...\n");
    String cmd = AxmCommandGetter.getFindTrussProcessIdCommand();
    logger.info(cmd);
    String trussProcessId = cliCommandHelper.simpleExec(cmd);
    logger.info("Truss Proccess ID found: "+trussProcessId);
    return trussProcessId;
  }

  @Override
  public void startTrussLogCollection(){
    logger.info("Starting Truss Collection...\n");
    String trussProcessID = findTrussProcessId().trim();
    if (trussProcessID != null){
      String cmd = AxmCommandGetter.getTrussLogCollectionCommand()+trussProcessID;
      logger.info(cmd+"cmd");
      logger.info(cliCommandHelper.simpleExec(cmd));
      logger.info("Collecting Truss Logs...");
    } else {
      logger.info("Truss Process ID is null");
    }
  }

  @Override
  public boolean trussProcessKill(){
    logger.info("Ending truss log collection");
    logger.info("Starting the Truss Collection process clean up");
    String cmd = AxmCommandGetter.getTrussLogCollectionProcessIdCommand();
    logger.info("Command to kill the Truss Collection process" +cmd);
    String trussCollectionProcessId = cliCommandHelper.simpleExec(cmd);
    logger.info("Truss Collection Process ID:" +trussCollectionProcessId.trim());
      if (trussCollectionProcessId != null){
        logger.info(cliCommandHelper.simpleExec("/bin/kill "+trussCollectionProcessId));
        logger.info("Truss Collection Process Killed");
        return true;
        } else {
          logger.info("Truss Collection Process ID is null");
      }
    return false;
  }
}
