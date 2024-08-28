#!/usr/bin/perl
#
# SCRIPT NAME:AXM_FT_EAC_GUI_BOUND_EAC_ESM_INFO_NO_NODE.pl
# Test Case & Priority: AXM_FT_EAC_GUI_BOUND_EAC_ESM_INFO (Pr.1)
# Test Case No : 5.2.1
# AUTHOR: XNNNKKR
# DATE  :
# REV:
#
# Description :
# Prerequisites  :
# Return Value on Success : 0
# Return Value on Failure : 1
# Result File : /home/nmsadm/eam/results
#
# Usage :  bash RUNME -t AXM_FT_EAC_GUI_BOUND_EAC_ESM_INFO_NO_NODE.pl:NO_NODE.
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
#my $TC         = "AXM_FT_EAC_GUI_BOUND_EAC_ESM_INFO_NO_NODE";
#my $RESULT_DIR = $ENV{RESULT_DIR};
#my $TMP        = $ENV{TMP};

#$ENV{tc} = AXM_FT_EAC_GUI_BOUND_EAC_ESM_INFO_NO_NODE;


#FRAME::start_frame "$TC";
#========================================================================
open(RFH,">AXM_FT_EAC_GUI_BOUND_EAC_ESM_INFO_NO_NODE.txt");
sub condn_check
{
if ( $? == 0 ) 
{
	print RFH "PASS : eac_esm_info is updated in the temporary log\n";
#    Te::tex "$TC", "\nINFO  :eac_esm_info is updated in the temporary log";
}
else 
{
	print RFH "FAIL : There is error in updating temporary log\n";
#    Te::tex "$TC", "\nERROR  : There is error in updating temporary log";
    
}
}


   print "\nExecuting eac_esm_info\n";
   system("/opt/ericsson/bin/eac_esm_info -t > /home/nmsadm/eac_esm_info_t.log");
   condn_check; 
   system("/opt/ericsson/bin/eac_esm_info -la > /home/nmsadm/eac_esm_info_la.log");
   condn_check;
   system("/opt/ericsson/bin/eac_esm_info -stat > /home/nmsadm/eac_esm_info_stat.log");
   condn_check;
   system("/opt/ericsson/bin/eac_esm_info -killall > /home/nmsadm/eac_esm_info_killall.log");
   system("/bin/cat /home/nmsadm/eac_esm_info_killall.log | /bin/grep Stopped > /dev/null"); 
   condn_check;
   
#Te::tex "$TC", " ";


   close(RFH);

system("/bin/cat AXM_FT_EAC_GUI_BOUND_EAC_ESM_INFO_NO_NODE.txt | /bin/grep FAIL ");
if ($? == 0)
{
print  "FAIL\n";
}
else
{
print "PASS\n";
#unlink("AXM_FT_EAC_GUI_BOUND_EAC_ESM_INFO_NO_NODE.txt");
}
#=======================================================================
#FRAME::end_frame "$TC";
