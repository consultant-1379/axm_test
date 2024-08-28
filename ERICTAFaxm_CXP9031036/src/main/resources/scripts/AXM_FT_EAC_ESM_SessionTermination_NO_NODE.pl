#!/usr/bin/perl
#
# SCRIPT NAME:AXM_FT_EAC_ESM_SessionTermination_NO_NODE.pl
# Test Case & Priority: AXM_FT_EAC_ESM_SessionTermination_NO_NODE  (Pr.2)
# Test Case No : 6.17.6
# AUTHOR: XJANTRI (JANMEJAY TRIPATHY)
# DATE  : 06/12/2013
# REV: A
#
################################ Description ######################
#This test case the infkormatin of the session during termination. 
#The active session and number of stopped sessions is displayed.
###################################################################
# Prerequisites  :
# Return Value on Success : 0
# Return Value on Failure : 1
# Result File : /home/nmsadm/eam/results
#
# Usage :  bash RUNME -t AXM_FT_EAC_ESM_SessionTermination_NO_NODE.pl.
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
#use util;
#my $EAM_DIR    = $ENV{EAM_DIR};
#my $TC         = "AXM_FT_EAC_ESM_SessionTermination_NO_NODE";
#my $RESULT_DIR = $ENV{RESULT_DIR};
#my $TMP        = $ENV{TMP};

#$ENV{tc} = AXM_FT_EAC_ESM_SessionTermination_NO_NODE;
$ntwrk_element=$ARGV[0];#ENV{ntwrk_element};
my @EAM_MC_LIST = ("eam_common","eam_eac_idl","eam_handlerAPG30","eam_handlerIp","eam_handlerIp_Mgr","eam_handlerIpLx","eam_handlerIpLx_Mgr","eam_handlerMs","eam_handlerMs_Mgr","eam_handlerMtp","eam_handlerText","eam_nrma","eam_handlerEMA");

#FRAME::start_frame "$TC";
#========================================================================

open(RFH,">AXM_FT_EAC_ESM_SessionTermination_NO_NODE.txt");
print "Listing Active sessions...\n";
system("/opt/ericsson/bin/eac_esm_info -i > /home/nmsadm/Active_Sessions.log");
if ( $? == 0 ) 
{
	print RFH "PASS : Listing of Active session successfully completed\n";
      #  Te::tex "$TC", "\n\nINFO  : Listing of Active session successfully completed\n";
}
else {
	print RFH "FAIL :  Listing of Active session failed\n";
#        Te::tex "$TC", "\n\nERROR  : Listing of Active session failed\n";
 #       FRAME::end_frame "$TC";
}

foreach $mc (@EAM_MC_LIST)
{
	system("/opt/ericsson/bin/eac_esm_info -s $mc > /home/nmsadm/Stopped_Sessions.log");
	
		if ( $? == 0 ) 
		{
			print RFH "PASS : Listing of stopped session successfully completed\n";
			#Te::tex "$TC", "\n\nINFO  : Listing of stopped session successfully completed\n";
		}
		else {
			print RFH "FAIL : Listing of stopped session failed\n";
#        Te::tex "$TC", "\n\nERROR  : Listing of stopped session failed\n";
 #       FRAME::end_frame "$TC";
		}
		
	system("/opt/ericsson/bin/eac_esm_info -killall -p $mc > /home/nmsadm/Killed_sessions.log 2>&1");
	
		if ( $? == 0 ) 
		{
			print RFH "PASS : All sessions related to $mc are killed successfully\n";
#			Te::tex "$TC", "\n\nINFO  : All sessions related to $mc are killed successfully\n";
		}
		else {
			system("/bin/cat /home/nmsadm/Killed_sessions.log | /bin/grep \"eac_esm_info: No matching TSP found\" ");
			if ($? == 0)
			{
				print RFH "PASS : No sessions related to $mc present\n";
#				Te::tex "$TC", "\n\nINFO  : No sessions related to $mc present\n";
			}
			else
			{
				print RFH "FAIL : Sessions killing failed for $mc\n";
#				Te::tex "$TC", "\n\nERROR  : Sessions killing failed for $mc\n";
#				FRAME::end_frame "$TC";
			}
		}	
}

close(RFH);

system("/bin/cat AXM_FT_EAC_ESM_SessionTermination_NO_NODE.txt | /bin/grep FAIL ");
if ($? == 0)
{
print  "FAIL\n";
}
else
{
print "PASS\n";
#unlink("AXM_FT_EAC_ESM_SessionTermination_NO_NODE.txt");
}
	
#=======================================================================
#FRAME::end_frame "$TC";
