#!/usr/bin/perl
#
# SCRIPT NAME:AXM_FT_EAC_ESI_Config_GetNeParameter_ALL.pl
# Test Case & Priority: AXM_FT_EAC_ESI_Config_GetNeParameter (Pr.2)
# Test Case No :6.12.3(common)
# AUTHOR:XNNNKKR
# DATE  :
# REV:
#
################################ Description ######################
#This test is to get NE parameter settings.The specified parameter and it's setting is displayed.
###################################################################
# Prerequisites  :
# Return Value on Success : 0
# Return Value on Failure : 1
# Result File : /home/nmsadm/eam/results
#
# Usage :  bash RUNME -t AXM_FT_EAC_ESI_Config_GetNeParameter_ALL.pl:ALL

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
#my $TC         = "AXM_FT_EAC_ESI_Config_GetNeParameter_ALL";
#my $RESULT_DIR = $ENV{RESULT_DIR};
#my $TMP        = $ENV{TMP};

#$ENV{tc} = AXM_FT_EAC_ESI_Config_GetNeParameter_ALL;
$ntwrk_element=$ARGV[0];#$ENV{ntwrk_element};

#FRAME::start_frame "$TC";
#======================================================================

open (RFH,">AXM_FT_EAC_ESI_Config_GetNeParameter_ALL.txt");
system("/opt/ericsson/bin/eac_esi_config -get cr_daemon -ne $ntwrk_element >> /home/nmsadm/eam/tmp/NE_Parameter.log");
system("/opt/ericsson/bin/eac_esi_config -get cr_log_state alarm_log conn_idle_to -ne $ntwrk_element >> /home/nmsadm/eam/tmp/NE_Parameter.log");

@arr = `/bin/egrep "cr_daemon\|cr_log_state\|alarm_log\|conn_idle_to" /home/nmsadm/eam/tmp/NE_Parameter.log`;
$arrsize = @arr;

if ( $arrsize == 4 ) 
{   system("/bin/rm /home/nmsadm/eam/tmp/NE_Parameter.log");
	print RFH "PASS : Parameters have been fetched successfully\n";
   
}
else 
{
	print RFH "FAIL : Parameter fetch is not successful\n";
    
}

close(RFH);

system("/bin/cat AXM_FT_EAC_ESI_Config_GetNeParameter_ALL.txt | /bin/grep FAIL ");
if ($? == 0)
{
print  "FAIL\n";
}
else
{
print "PASS\n";
#unlink("AXM_FT_EAC_ESI_Config_GetNeParameter_ALL.txt");
}
#=======================================================================
#FRAME::end_frame "$TC";
