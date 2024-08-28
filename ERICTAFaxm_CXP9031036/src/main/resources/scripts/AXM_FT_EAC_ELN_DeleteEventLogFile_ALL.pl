#!/usr/bin/perl
#
# SCRIPT NAME:AXM_FT_EAC_ELN_DeleteEventLogFile_ALL.pl
# Test Case & Priority:AXM_FT_EAC_ELN_DeleteEventLogFile_ALL(Pr.3)
# DATE  :15/01/2014
# AUTHOR:XJANTRI
# REV: 1.0
#
################################ Description ######################
#A new event log file is created and the connection event is written in this new event log file.This test case is to delete the event log file
###################################################################
# Return Value on Success : PASS
# Return Value on Failure : FAIL
#
# Usage :  /usr/local/bin/perl AXM_FT_EAC_ELN_DeleteEventLogFile_ALL.pl <node_name>.
#
# Dependency : NA
#
# REV HISTORY
# DATE:                           BY                                 MODIFICATION:
# 11/08/2014                     XNNNKKR	               Modification of script into TAF Complaint.
##########################################################


use Expect;

$ntwrk_element=$ARGV[0];

open(RFH,">AXM_FT_EAC_ELN_DeleteEventLogFile_ALL.txt");

$path = "/var/opt/ericsson/nms_eam_eac/log/ev/";

sub node_conn
{  
	print "Establishing connection for $ntwrk_element\n";    
        my $expect = Expect->new;
        my $command = "/opt/ericsson/bin/eaw $ntwrk_element";
        $expect->spawn($command) or die "Cannot spawn : $!\n";
	$expect->log_file("/home/nmsadm/tryexpect.log","w");
        $expect->expect(10,'<');
        $expect->send("caclp;\r");
        $expect->expect(10,'<');
        $expect->send("quit;\r");
        $expect->soft_close();
}

sub condn_check
{ 
	if ( $? == 0 )
	{
		print RFH "PASS : Command CACLP Executed successfully.\n";
	}
	else
	{
		print RFH "FAIL : Command CACLP not Executed successfully\n";
	}
}

sub removeEventLogs
{
	print "Deleting the event log files for command and response...\n";
	system("/bin/rm -rf /var/opt/ericsson/nms_eam_eac/log/ev/eacr.*");
	if ( $? == 0 )
        {
		print RFH "PASS : rm /var/opt/ericsson/nms_eam_eac/log/ev/eacr.* command is executed successfully.";
        }
        else
        {
		print RFH "FAIL : rm /var/opt/ericsson/nms_eam_eac/log/ev/eacr.* command is not executed successfully.\n";
        }
}

$checkLogFileExist = `/bin/ls -lrt /var/opt/ericsson/nms_eam_eac/log/ev/ | /bin/grep "eacr.new" | /bin/wc -l`;

$checkLogFileExist =chomp $checkLogFileExist;


if ($checkLogFileExist ge 1)
{
	print RFH "PASS : event log file \"eacr.new\" is exist at path $path\n";
	removeEventLogs;
}
else
{
	print RFH "FAIL : event log file \"eacr.new\" is not exist at path $path\n";
	print "\nExecuting Event log Scenario\n";
	system("/opt/ericsson/bin/eac_egi_config -set event_log_status 1");
	sleep(10);	 	 
}

node_conn;

system("/bin/cat /home/nmsadm/tryexpect.log | /bin/grep \"TIME\"") && system("/bin/cat /home/nmsadm/tryexpect.log | /bin/grep \"END\"");

condn_check;

$checkLogFileCreated = `/bin/ls -lrt /var/opt/ericsson/nms_eam_eac/log/ev/ | /bin/grep "eacr.new" | /bin/wc -l`;

$checkLogFileCreated =chomp $checkLogFileCreated;


if ($checkLogFileCreated ge 1)
{
	print RFH "PASS : New event log file eacr.new is created successfully.\n";
}
else
{
	print RFH "FAIL : New event log file eacr.new is not created successfully.\n";
}

#Checking the connection event written in new event log file

system("/bin/cat /var/opt/ericsson/nms_eam_eac/log/ev/eacr.new | /bin/grep $ntwrk_element ");

if ( $? == 0 )
{
	print RFH "PASS : The connection event has been written in this new event log file \"eacr.new\" successfully.\n";
}
else
{
	print RFH "FAIL : The connection event has not been written in this new event log file \"eacr.new\" successfully.\n";
}


close(RFH);

system("/bin/cat AXM_FT_EAC_ELN_DeleteEventLogFile_ALL.txt | /bin/grep FAIL ");

if ($? == 0)
{
	print  "FAIL\n";
}
else
{
	print "PASS\n";

}

#=======================================================================
