#!/use/bin/perl
#
# SCRIPT NAME:AXM_FT_Parameter_setting_in_MSCBC_node_MSCBCW.pl
# Test Case & Priority: AXM_FT_Parameter_setting_in_MSCBC_node (Pr.1)
# Test Case No :10.1.3 (Common)
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
# Usage :  bash RUNME -t AXM_FT_Parameter_setting_in_MSCBC_node_MSCBCW.pl.
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


#======================================================================

open(RFH,">AXM_FT_Parameter_setting_in_MSCBC_node_MSCBCW.txt");
$var=_1; 

system("/opt/ericsson/bin/eac_esi_config -ne $ntwrk_element -set conn_idle_to 43150");
sleep(3);
system("/opt/ericsson/bin/eac_esi_config -ne $ntwrk_element > Parameter_MSCBC.log");
system("/opt/ericsson/bin/eac_esi_config -ne $ntwrk_element $var -set conn_idle_to 43150 ");
sleep(3);
system("/opt/ericsson/bin/eac_esi_config -ne $ntwrk_element $var > Parameter_MSCBC_1.log");
$x =  `/bin/cat Parameter* | /bin/grep -c 43150`;
#print "The value of x is :$x\n";
if ( $x == 2 ) {
	print RFH "PASS : Parameter changed successfully";
  #  Te::tex "$TC", "\nINFO  :Parameter changed successfully";
}
else {
	print RFH "FAIL : Parameter not updated";
   # Te::tex "$TC", "\nERROR  : Parameter not updated";
    
}

close(RFH);
system("/bin/cat AXM_FT_Parameter_setting_in_MSCBC_node_MSCBCW.txt | /bin/grep FAIL ");
if ($? == 0)
{
print  "\nFAIL\n";
}
else
{
print "\nPASS\n";
}

#=======================================================================
#FRAME::end_frame "$TC";
