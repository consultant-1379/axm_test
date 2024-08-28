#!usr/bin/perl
#
# SCRIPT NAME:AXM_FT_Modify_node_APG43_to_APG43L_NO_NODE.pl
# Test Case Priority: (Pr.1)
# Test Case No :7.2.8(common)
# AUTHOR:XNNNKKR
# DATE:18/1/2014
# REV:1.0
#
################################# Description ######################
#This test case is for modification of APG43 Node to APG43L node.
###################################################################
 # Return Value on Success :PASS
# Return Value on Failure :FAIL

#
# Usage : /usr/local/bin/perl AXM_FT_Modify_node_APG43_to_APG43L_NO_NODE.pl.
#
# Dependency  :Create xml should be run before running this usecase
#B3 Windows node should exist in the server.
#
# REV HISTORY
# DATE                           BY                                 MODIFICATION
# 11/08/2014                    XNNNKKR	                       Modified the script in to TAF compliaint.
##########################################################

# DEFINE FILES AND VARIABLES HERE

use Expect;

$string4 = "Import completed";
$string5 = "The APG IO Upgrade is successfull";

open (RFH,">AXM_FT_Modify_node_APG43_to_APG43L_NO_NODE.txt");

sub modify
{
	$var1 =`/opt/ericsson/arne/bin/modifyApg.sh -me B3 -L`;
	print "$var1\n";
	if ($var1 =~ $string4 && $var1 =~ $string5)
	{
		print RFH "Modify Import is successful\n";
	}
	else
	{
		print RFH "FAIL : Modify Import is not successful\n";

	}
}

modify;

system("/bin/cat AXM_FT_Modify_node_APG43_to_APG43L_NO_NODE.txt | /bin/grep FAIL ");
if ($? == 0)
{
	print  "\nFAIL\n";
}
else
{
	print "\nPASS\n";

}
