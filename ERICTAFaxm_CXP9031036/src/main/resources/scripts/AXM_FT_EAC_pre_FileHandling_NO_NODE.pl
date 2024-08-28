#!/usr/bin/perl
#
# SCRIPT NAME:AXM_FT_EAC_pre_FileHandling_NO_NODE.pl
# Test Case & Priority:AXM_FT_EAC_pre_FileHandling_NO_NODE(Pr.1)
# Test Case No :
# AUTHOR:XJITKUM
# DATE  :19/11/2013
# REV:
#
# Description :
# Prerequisites  :
# Return Value on Success : 0
# Return Value on Failure : 1
# Result File : /home/nmsadm/eam/results
#
# Usage :  bash RUNME -t AXM_FT_EAC_pre_FileHandling_NO_NODE.pl.
#
# Dependency : Te.pm, crdmp.sh, PMSEerrorchk.sh
#
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
#my $TC         = "AXM_FT_EAC_pre_FileHandling_NO_NODE";
#my $RESULT_DIR = $ENV{RESULT_DIR};
#my $TMP        = $ENV{TMP};
my $path = "/var/opt/ericsson/nms_eam_eac/log/ev";
my $log = "eacr.new";
my $flag = 1;

#FRAME::start_frame "$TC";
#========================================================================
 
open RFH, ">AXM_FT_EAC_pre_FileHandling_NO_NODE.txt" or die $!;

print "\nExecuting Event log Scenario\n";

my @Eventlogs=("event_log_status","log_file_connect","log_file_connect_failed","log_file_disconnect","log_file_create","log_file_open","log_file_delete","log_file_close","log_file_notify","log_file_dfo","log_cmd_connect","log_cmd_connect_failed","log_cmd_disconnect","log_cmd_req_failed","log_cmd_session","log_cmd_session_failed","log_end_cmd_session");
foreach $event (@Eventlogs)
{
chomp($event);
chomp($flag);
system("eac_egi_config -set $event $flag");
}
if ( $? == 0 ) {
	print RFH "PASS : parameters are changed is done\n";
#    Te::tex "$TC", "\nINFO  : parameters are changed is done";
}
else {
	print RFH "FAIL : There is error in updating event log\n";
#    Te::tex "$TC", "\nERROR  : There is error in updating event log";

}

system("/bin/cat $path/eacr.new|tail -50 > test");

if ( $? == 0 ) {
	print RFH "PASS : event log is possible to check\n";
#	Te::tex "$TC", "\nINFO  : event log is possible to check";
}
else {
	print RFH "FAIL : event log is not possible to check\n";
#    Te::tex "$TC", "\nERROR  : event log is not possible to check";

}
print "\nExecuting Event log Scenario done\n";

close(RFH);

system("bin/grep FAIL AXM_FT_EAC_pre_FileHandling_NO_NODE.txt");
if ($? == 0)
{
print  "FAIL\n";
}
else
{
print "PASS\n";
#unlink("AXM_FT_EAC_pre_FileHandling_NO_NODE.txt");
}

#=======================================================================
#FRAME::end_frame "$TC";

