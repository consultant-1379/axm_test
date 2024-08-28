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


import com.ericsson.cifwk.taf.data.Host;
import com.ericsson.cifwk.taf.handlers.implementation.SshRemoteCommandExecutor;
import com.ericsson.cifwk.taf.tools.cli.CLI;
import com.ericsson.oss.taf.hostconfigurator.OssHost;
import com.ericsson.cifwk.taf.tools.cli.CLICommandHelper;

public class AxmRemoteCommandExecutor {

	CLICommandHelper sshExecutor;

	CLI cliExecutor;

	public AxmRemoteCommandExecutor(final Host host) {

		sshExecutor = new CLICommandHelper(host);
		cliExecutor = new CLI(host);
	}

	public AxmRemoteCommandExecutor(final OssHost host , boolean user) {

		sshExecutor = new CLICommandHelper(host);
		cliExecutor = new CLI(host,host.getRootUser());
	}

	public String simplExec(final String cmdWithArgs) {

		return simplExec(cmdWithArgs);
	}

	public String simplExec(final String cmdWithArgs, final boolean sendOnly) {

		return executeCommandUseSshAPI(cmdWithArgs, sendOnly);
	}

	private String executeCommandUseSshAPI(final String cmdWithArgs, final boolean sendOnly) {

		return sshExecutor.simpleExec(cmdWithArgs);
	}

}
