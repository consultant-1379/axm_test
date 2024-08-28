#!/usr/bin/perl

# SCRIPT NAME:AXM_FT_Verify_characteristics_of_a_APG43Lnode_BSCL.pl
# Test Case & Priority:AXM_FT_Verify the characteristics of a APG43L node (Pr.1)
# Test Case No :7.2.18(common)
# AUTHOR:XNNNKKR
# DATE  :
# REV:
#
# Description :
# Prerequisites  :
# Return Value on Success : 0
# Return Value on Failure : 1
# Result File : /home/nmsadm/eam/results
#
# Usage :  bash RUNME -t AXM_FT_Verify_characteristics_of_a_APG43Lnode_BSCL.pl:LINUX.
#
# Dependency : Te.pm, crdmp.sh, PMSEerrorchk.sh
#
# REV HISTORY
# DATE:                           BY                                 MODIFICATION:
#
##########################################################

# DEFINE FILES AND VARIABLES HERE

use Expect;



$ntwrk_element=$ARGV[0];#ENV{ntwrk_element};

#========================================================================
open(RFH,">AXM_FT_Verify_characteristics_of_a_APG43Lnode_BSCL.txt");
print "Checking the Cr_deamon field property of BSCLinux node\n";
$Lvar = "ehiplx_ac_in";
system("/opt/ericsson/bin/eac_esi_config -ne $ntwrk_element > eac_esi_linux.log");
system("/bin/cat eac_esi_linux.log | /bin/grep $Lvar");
if ($? == 0)
{

print RFH "PASS : The property is matched with the Bsc linux deamon propery";
#"INFO  : The property is matched with the Bsc linux deamon propery";
}
else
{
print RFH "FAIL : Mentioned node is not a BSCLinux node";
#Te::tex "$TC", "ERROR  : Mentioned node is not a BSCLinux node";
}
   
close(RFH);
system("/bin/cat AXM_FT_Verify_characteristics_of_a_APG43Lnode_BSCL.txt | /bin/grep FAIL ");
if ($? == 0)
{
print  "\nFAIL\n";
}
else
{
print "\nPASS\n";
unlink("AXM_FT_Verify_characteristics_of_a_APG43Lnode_BSCL.txt");
}
#=======================================================================	
