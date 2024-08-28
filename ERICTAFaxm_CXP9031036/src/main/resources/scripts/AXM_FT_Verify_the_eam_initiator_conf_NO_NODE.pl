#!/usr/bin/perl
#
# SCRIPT NAME:AXM_FT_verify_the_eam_initiator_conf_NO_NODE.pl
# Test Case & Priority: AXM_FT_verify_the_eam_initiator_conf (Pr.1)
# Test Case No :7.2.31(common)
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
# Usage : bash RUNME -t AXM_FT_Verify_the_eam_initiator_conf_NO_NODE.pl:NO_NODE.
#
# Dependency : Te.pm, crdmp.sh, PMSEerrorchk.sh
#
# REV HISTORY
# DATE:                           BY                                 MODIFICATION:
#
##########################################################

# DEFINE FILES AND VARIABLES HERE

#use Expect;




$ntwrk_element=$ARGV[0];#ENV{ntwrk_element};
open(RFH,">>AXM_FT_Verify_the_eam_initiator_conf_NO_NODE.txt");
#======================================================================
$path="/etc/opt/ericsson/nms_eam_eac";
$var= "MIN_INITIATOR_EHIPLX=1\nMAX_INITIATOR_EHIPLX=10\nINT_THRESHOLD_EHIPLX=400";

    
        
  print "Data fetch for linux node details\n";
  system("/bin/cat $path/eam_initiator.conf > /home/nmsadm/eam/tmp/eam_initiator.log");  
  system("/bin/cat /home/nmsadm/eam/tmp/eam_initiator.log| /bin/grep $var ");    
  
if ( $? == 0 ) 
{
	print RFH "PASS : Initiator parameters for ehiplx is found";
   # Te::tex "$TC", "\nINFO  :Initiator parameters for ehiplx is found";
}
else {
	print RFH "FAIL : Initiator parameters for ehiplx is not found";
  #  Te::tex "$TC", "\nERROR  : Initiator parameters for ehiplx is not found";
    
}
close(RFH);
system("/bin/cat AXM_FT_Verify_the_eam_initiator_conf_NO_NODE.txt | /bin/grep FAIL ");
if ($? == 0)
{
print  "\nFAIL\n";
}
else
{
print "\nPASS\n";
unlink("AXM_FT_Verify_the_eam_initiator_conf_NO_NODE.txt");
}
#=======================================================================
#FRAME::end_frame "$TC";
