#!/usr/bin/perl
#
# SCRIPT NAME:AXM_FT_EAC_ESI_Config_Help_NO_NODE.pl
# Test Case & Priority: AXM_FT_EAC_ESI_Config_Help_NO_NODE.pl (Pr.3)
# Test Case No :6.12.4(common)
# AUTHOR:
# DATE  :
# REV:
#
# Description :
# Prerequisites  :
# Return Value on Success : 0
# Return Value on Failure : 1
# Result File : /home/nmsadm/eam/results
#
# Usage :  bash RUNME -t AXM_FT_EAC_ESI_Config_Help_NO_NODE.pl:NO_NODE
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
#my $TC         = "AXM_FT_EAC_ESI_Config_Help_NO_NODE";
#my $RESULT_DIR = $ENV{RESULT_DIR};
#my $TMP        = $ENV{TMP};

#$ENV{tc} = AXM_FT_EAC_ESI_Config_Help_NO_NODE;
$ntwrk_element=$ARGV[0];#$ENV{ntwrk_element};

#FRAME::start_frame "$TC";
#======================================================================

open(RFH,">AXM_FT_EAC_ESI_Config_Help_NO_NODE.txt");
system("/opt/ericsson/bin/eac_esi_config -h >> /home/nmsadm/help_man.log");

system("/bin/grep Usage /home/nmsadm/help_man.log");

if ( $? == 0 ) 
{   
    system("/bin/rm /home/nmsadm/help_man.log");
	print RFH "PASS : Help and Man pages are printed successfully\n";
}
else 
{

	print RFH "FAIL : Help and Man pages are not printed\n";
    
}

close(RFH);

system("/bin/cat AXM_FT_EAC_ESI_Config_Help_NO_NODE.txt | /bin/grep FAIL ");
if ($? == 0)
{
print  "FAIL\n";
}
else
{
print "PASS\n";
#unlink("AXM_FT_EAC_ESI_Config_Help_NO_NODE.txt");
}

#=======================================================================
