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
package com.ericsson.axm.test.apiGetter;

import java.util.List;
import com.ericsson.cifwk.taf.data.DataHandler;
import com.ericsson.cifwk.taf.data.Host;
import com.ericsson.cifwk.taf.handlers.RemoteFileHandler;
import com.ericsson.cifwk.taf.handlers.netsim.implementation.SshNetsimHandler;
import com.ericsson.oss.taf.hostconfigurator.HostGroup;
import com.ericsson.oss.taf.hostconfigurator.OssHost;
import com.ericsson.cifwk.taf.tools.cli.handlers.impl.RemoteObjectHandler;

public class AxmApiGetter {

    private static final OssHost masterHost = HostGroup.getOssmaster();//DataHandler.getHostByName("ossmaster");

    private static final Host masterRootHost = DataHandler.getHostByName("ossmasterRoot");
    
    private static final List<Host> netsimHost = HostGroup.getAllNetsims();// DataHandler.get.getHostByName("netsim");

    //Not in use for Cex
    private static final Host infraServerHost = DataHandler.getHostByName("infraServer");
    private static final Host gateway = HostGroup.getGateway();//DataHandler.getHostByName("gateway");

    public static Host getRootHostMaster() {

        return masterRootHost;
    }
    
    public static OssHost getHostMaster() {

        return masterHost;
    }
   
    public static Host getHostNetsim() {

        return netsimHost.get(0);
    }

    public static Host getHostInfraServer() {

        return infraServerHost;
    }

    public static Host getGateway() {

        return gateway;
    }

    public static AxmRemoteCommandExecutor getRemoteCommandExecutor(final Host host) {

        return new AxmRemoteCommandExecutor(host);
    }
    
//    public static CexRemoteCommandExecutor getRootRemoteCommandExecutor(final Host host) {
//
//        return new CexRemoteCommandExecutor(host, true);
//    }

    public static RemoteObjectHandler getMasterHostFileHandler() {

        return getRemoteObjectHandler(masterHost);
    }

    public static RemoteObjectHandler getMasterRootFileHandler() {

        return getRemoteObjectHandler(masterHost);
    }

    public static RemoteObjectHandler getInfrServerFileHandler() {

        return getRemoteObjectHandler(infraServerHost);
    }

    public static RemoteObjectHandler getNetsimRemoteFileHandler() {

        return getRemoteObjectHandler(getHostNetsim());
    }

    public static RemoteObjectHandler getRemoteObjectHandler(final Host host) {

        return new RemoteObjectHandler(host);
    }

    public static SshNetsimHandler getSshNetsimHandler() {

        return getSshNetsimHandler(getHostNetsim());
    }

    public static SshNetsimHandler getSshNetsimHandler(final Host netsimHost) {

        return new SshNetsimHandler(netsimHost);
    }


}
