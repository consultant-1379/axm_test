#!/usr/bin/perl
#
# SCRIPT NAME:AXM_FT_EAC_ESM_SessionInformation_NO_NODE.pl
# Test Case & Priority:AXM_FT_EAC_ESM_SessionInformation(Pr.3)
# Test Case No : 6.14.5 (common)
# AUTHOR: XROHAGR
# DATE  : 14/01/2014
# REV: A
#
# Description :
# Prerequisites  :
# Return Value on Success : 0
# Return Value on Failure : 1
# Result File : /home/nmsadm/eam/results
#
# Usage :  bash RUNME -t AXM_FT_EAC_ESM_SessionInformation_NO_NODE.pl:NO_NODE
#
# Dependency : Te.pm, crdmp.sh, PMSEerrorchk.sh
# OutPut Files: /home/nmsadm/eam/tmp/ListSessionInfo.log, /home/nmsadm/eam/tmp/ListallSessionInfo.log, /home/nmsadm/eam/tmp/LongListSessionInfo.log, #/home/nmsadm/eam/tmp/LongListallSessionInfo.log, /home/nmsadm/eam/tmp/ListSessionStatusAndInfo.log, /home/nmsadm/eam/tmp/UnixGrepFriendlySessionInfo.log, #/home/nmsadm/eam/tmp/ListOtherSessionInfo.log, /home/nmsadm/eam/tmp/ListSessionTypeInfo.log, /home/nmsadm/eam/tmp/esm_sessioninfo_processName.log, #/home/nmsadm/eam/tmp/esmsessionInfoProgramType.log, /home/nmsadm/eam/tmp/esm_sessioninfo_11.log, /home/nmsadm/eam/tmp/esm_sessioninfo_host.log, #/home/nmsadm/eam/tmp/ListSessionInfo_sessionType.log, /home/nmsadm/eam/tmp/ListSessionStatusInESM.log, /home/nmsadm/eam/tmp/ListSessionStatusInProcess.log  
# REV HISTORY
# DATE:                           BY                                 MODIFICATION:
#
##########################################################

# DEFINE FILES AND VARIABLES HERE
#use Te;
#use FRAME;
use Expect;
#use util;
#my $EAM_DIR    = $ENV{EAM_DIR};
#my $TC         = "AXM_FT_EAC_ESM_SessionInformation_NO_NODE";
#my $RESULT_DIR = $ENV{RESULT_DIR};
#my /home/nmsadm/eam/tmp        = $ENV{TMP};

#$ENV{tc} = AXM_FT_EAC_ESM_SessionInformation_NO_NODE;
$ntwrk_element=$ARGV[0];#ENV{ntwrk_element};
#FRAME::start_frame "$TC";
#======================================================================
open(RFH,">AXM_FT_EAC_ESM_SessionInformation_NO_NODE.txt");
#List with session information
print "List with session information...\n";
system("/opt/ericsson/bin/eac_esm_info -l >/home/nmsadm/ListSessionInfo.log");
CheckOutputStatus("/opt/ericsson/bin/eac_esm_info -l");

#List with all session information
print "List with all session information...\n";
system("/opt/ericsson/bin/eac_esm_info -i -a >/home/nmsadm/ListallSessionInfo.log");
CheckOutputStatus("/opt/ericsson/bin/eac_esm_info -i -a");

#Long list with session information 
print "Long list with session information...\n";
system("/opt/ericsson/bin/eac_esm_info -i -l >/home/nmsadm/LongListSessionInfo.log");
CheckOutputStatus("/opt/ericsson/bin/eac_esm_info -i -l");

#Long list with all session information
print "Long list with all session information...\n";
system("/opt/ericsson/bin/eac_esm_info -i -la >/home/nmsadm/LongListallSessionInfo.log");
CheckOutputStatus("/opt/ericsson/bin/eac_esm_info -i -la");

#List with session status and information
print "List with session status and information...\n"; 
system("/opt/ericsson/bin/eac_esm_info -i -ls >/home/nmsadm/ListSessionStatusAndInfo.log");
CheckOutputStatus("/opt/ericsson/bin/eac_esm_info -i -ls");

#Unix grep friendly list with session information
print "Unix grep friendly list with session information...\n"; 
system("/opt/ericsson/bin/eac_esm_info -i -a -g >/home/nmsadm/UnixGrepFriendlySessionInfo.log");
CheckOutputStatus("/opt/ericsson/bin/eac_esm_info -i -a -g");

#List with other session information
print "List with other session information...\n"; 
system("/opt/ericsson/bin/eac_esm_info -r >/home/nmsadm/ListOtherSessionInfo.log");
CheckOutputStatus("/opt/ericsson/bin/eac_esm_info -r");

#List with session type (eac_sb_server) information 
print "List with session type (eac_sb_server) information...\n"; 
system("/opt/ericsson/bin/eac_esm_info -proc eac_sb_server >/home/nmsadm/ListSessionTypeInfo.log");
CheckOutputStatus("/opt/ericsson/bin/eac_esm_info -proc eac_sb_server");

system("/bin/cat /home/nmsadm/ListSessionTypeInfo.log | /bin/grep eac_sb_server");
if ( $? == 0 )
{
	print RFH "PASS : Session for eac_sb_server has been found successfully.\n";
#    Te::tex "$TC", "\nINFO  :Session for eac_sb_server has been found successfully.";
}
else
{	print RFH "FAIL : Session info for eac_sb_server has not been found successfully.";
#    Te::tex "$TC", "\nERROR  :Session info for eac_sb_server has not been found successfully.";
}

#List with information of a specified process name (ehip_ac_in_mgr)
print "List with information of a specified process name (ehip_ac_in_mgr)\n"; 
system("/opt/ericsson/bin/eac_esm_info -proc ehip_ac_in_mgr >/home/nmsadm/esm_sessioninfo_processName.log");
CheckOutputStatus("/opt/ericsson/bin/eac_esm_info -proc ehip_ac_in_mgr");

system("/bin/cat /home/nmsadm/esm_sessioninfo_processName.log | /bin/grep ehip_ac_in_mgr");
if ( $? == 0 )
{	
	print RFH "PASS : Session information for specified process ehip_ac_in_mgr has been found successfully\n";
#    Te::tex "$TC", "\nINFO  :Session information for specified process ehip_ac_in_mgr has been found successfully.";
}
else
{
	print RFH "FAIL : Session information for specified process ehip_ac_in_mgr has not been found successfully.\n";
#    Te::tex "$TC", "\nERROR  :Session information for specified process ehip_ac_in_mgr has not been found successfully.";
}

#List with information of a specified program type 
print "List with information of a specified program type ehip_ac_in \n"; 
system("/opt/ericsson/bin/eac_esm_info -ptype ehip_ac_in >/home/nmsadm/esmsessionInfoProgramType.log");
CheckOutputStatus("/opt/ericsson/bin/eac_esm_info -ptype ehip_ac_in");

#List with information of a specified PID
$pid = `/opt/ericsson/bin/eac_esm_info -proc eac_sb_server | grep "pid =" | cut -d "," -f2 | cut -d "=" -f2`;
#$pid = chomp $pid;#util::trim $pid;
print "List with information of a specified PID = $pid\n"; 
esmsessionInfo_pid($pid);

#List with session information for a specified host
$host = `/opt/ericsson/bin/eac_esm_info -proc eac_sb_server | grep "host =" | cut -d "," -f3 | cut -d "=" -f2`;
#$host = chomp $host;
print "List with information of a specified host = $host\n"; 
esmsessionInfo_host($host);

#List with session information for a specified session type
print "List with session information for a specified session type...\n";
system("/opt/ericsson/bin/eac_esm_info -stype \"EHIP CPI Session\" >/home/nmsadm/ListSessionInfo_sessionType.log");
CheckOutputStatus("/opt/ericsson/bin/eac_esm_info -stype \"EHIP CPI Session\"");

#List session status in ESM and in a process
print "List session status in ESM...\n"; 
system("/opt/ericsson/bin/eac_esm_info -stat >/home/nmsadm/ListSessionStatusInESM.log");
CheckOutputStatus("/opt/ericsson/bin/eac_esm_info -stat");

#List over session status in an specified process (eac_sb_server)
print "List over session status in an specified process eac_sb_server...\n"; 
system("/opt/ericsson/bin/eac_esm_info -stat -p eac_sb_server >/home/nmsadm/ListSessionStatusInProcess.log");
CheckOutputStatus("/opt/ericsson/bin/eac_esm_info -stat -p eac_sb_server");

#Deleting the temporary Log files
RemoveTemporaryLogFiles();

#=======================================================================
#FRAME::end_frame "$TC";

#Method for Deleting the temporary Log files
sub RemoveTemporaryLogFiles
{
	unlink("/home/nmsadm/ListSessionInfo.log"); 
	unlink("/home/nmsadm/ListallSessionInfo.log"); 
	unlink("/home/nmsadm/LongListSessionInfo.log"); 
	unlink("/home/nmsadm/LongListallSessionInfo.log"); 
	unlink("/home/nmsadm/ListSessionStatusAndInfo.log"); 
	unlink("/home/nmsadm/UnixGrepFriendlySessionInfo.log"); 
	unlink("/home/nmsadm/ListOtherSessionInfo.log"); 
	unlink("/home/nmsadm/ListSessionTypeInfo.log"); 
	unlink("/home/nmsadm/esm_sessioninfo_processName.log"); 
	unlink("/home/nmsadm/esmsessionInfoProgramType.log"); 
	unlink("/home/nmsadm/ListSessionInfo_sessionType.log"); 
	unlink("/home/nmsadm/ListSessionStatusInESM.log"); 
	unlink("/home/nmsadm/ListSessionStatusInProcess.log"); 
	unlink("/home/nmsadm/esmsessionInfo_pid.log"); 
	unlink("/home/nmsadm/esm_sessioninfo_host.log");
}

#Method for checking the output status
sub CheckOutputStatus
{
	my $CommandName = $_[0];
	if ( $? == 0 )
	{
		print RFH "PASS : $CommandName command is executed successfully.\n";
#			Te::tex "$TC", "\nINFO  : $CommandName command is executed successfully.";
	}
	else
	{
		print RFH "FAIL : $CommandName command is not executed successfully.\n";
#			Te::tex "$TC", "\nERROR  : $CommandName command is not executed successfully.";
	}	
}

#List with information of a specified PID
sub esmsessionInfo_pid
{
		my $pid = $_[0];
		system("/opt/ericsson/bin/eac_esm_info -pid $pid >/home/nmsadm/esmsessionInfo_pid.log");
		
		if ( $? == 0 )
        {
 		print RFH "PASS : eac_esm_info -pid $pid command is executed successfully.\n";
#               Te::tex "$TC", "\nINFO  : eac_esm_info -pid $pid command is executed successfully.";
        }
        else
        {
		print RFH "FAIL : eac_esm_info -pid $pid command is not executed successfully.\n";
#                Te::tex "$TC", "\nERROR  : eac_esm_info -pid $pid command is not executed successfully.";
        }
}

#List with information of a specified host
sub esmsessionInfo_host
{
		my $host = $_[0];
		system("/opt/ericsson/bin/eac_esm_info -host $host >/home/nmsadm/esm_sessioninfo_host.log");
		if ( $? == 0 )
        {
		print RFH "PASS : eac_esm_info -host $host command is executed successfully.\n";
#                Te::tex "$TC", "\nINFO  : eac_esm_info -host $host command is executed successfully.";
        }
        else
        {
		print RFH "FAIL : eac_esm_info -host $host command is not executed successfully.\n";
#                Te::tex "$TC", "\nERROR  : eac_esm_info -host $host command is not executed successfully.";
        }
}

close(RFH);

system("/bin/cat AXM_FT_EAC_ESM_SessionInformation_NO_NODE.txt | /bin/grep FAIL ");
if ($? == 0)
{
print  "FAIL\n";
}
else
{
print "PASS\n";
#unlink("AXM_FT_EAC_ESM_SessionInformation_NO_NODE.txt");
}
