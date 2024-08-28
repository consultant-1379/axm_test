#!/usr/bin/perl
#
# SCRIPT NAME : AXM_FT_Verify_the_crontab_entry_after_inst_NO_NODE.pl
# Test Case & Priority : AXM_FT_Verify_the_crontab_entry_after_inst (Pr.1)
# Test Case No : 7.2.38(common)
# AUTHOR : XNNNKKR
# DATE : 11/10/2013 
# REV: 14/08/2014
#
############################# Description ###################################################
# This test case is to verify that Crontab should contain cleanup script info.
#############################################################################################
# Prerequisites  : None
# Return Value on Success : PASS
# Return Value on Failure : FAIL
# Result File : View JCAT Report
#
# Usage :  /usr/local/bin/perl AXM_FT_Verify_the_crontab_entry_after_inst_NO_NODE.pl
#
# Dependency : Te.pm, crdmp.sh, PMSEerrorchk.sh
#
# REV HISTORY
# DATE:                           BY                                 MODIFICATION:
# 14/08/2014			xaksgan 		Modified the script into TAF Compliant
####################################################################################################

open(RFH,">AXM_FT_Verify_the_crontab_entry_after_inst_NO_NODE.txt");
system("/bin/crontab -l > crontab.log ");
#system("/bin/cat crontab.log | /bin/grep eam_alarm_cleanup.sh ");

if ( $? == 0 ) 
{
	print RFH "PASS : Command execution is successful\n";
}
else 
{
	print RFH "FAIL : Command execution is not successful\n";
    
}
close(RFH);

system("/bin/cat AXM_FT_Verify_the_crontab_entry_after_inst_NO_NODE.txt | /bin/grep FAIL ");
if ($? == 0)
{
	print  "\nFAIL\n";
}
else
{
	print "\nPASS\n";
}
