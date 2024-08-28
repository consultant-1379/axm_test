#!usr/bin/perl
#
# SCRIPT NAME:AXM_FT_AUT_Modify_Nodes_ALL_NO_NODE.pl
# Test Case & Priority:AXM_FT_AUT_Modify_Nodes_ALL_NO_NODE.pl (Pr.1)
# Test Case No 9.1.1(common)
# AUTHOR: XNNNKKR
# DATE : 10/08/2014
# REV:1.0
#
# Description :This test script imports the modify xml which in turn modifies all the nodes. 

# Return Value on Success :PASS
# Return Value on Failure :FAIL
#
# Usage : /usr/local/bin/perl AXM_FT_AUT_Modify_Nodes_ALL_NO_NODE.pl.
#
# Dependency : This test script requires eam_Auto_NE_modify_ALL.xml file for modifying the nodes
#
# REV HISTORY
# DATE:                           BY                                 MODIFICATION:
# 02/09/2014			XNNNKKR        	      Modified the script to TAF Compliant.
##########################################################

#======================================================================
open(RFH,">AXM_FT_AUT_Modify_Nodes_ALL_NO_NODE.txt");

$filename= "/home/nmsadm/eam_Auto_NE_modify_ALL.xml";
$string1 = "No Errors Reported";
$string2 = "Import Finished";

sub modify
{
if (-e $filename) 
{
print "File Exists!";
$var =`/opt/ericsson/arne/bin/import.sh -f $filename -import -i_nau`;
print "$var\n";
if ($var =~ $string1 && $var =~ $string2)
{
	print RFH "PASS :Modify Import is successful\n";


}
else
{
	print RFH "FAIL :Modify Import is not successful\n";


}
}
else
{
	print RFH "FAIL :Modify Import xml File doesn't exist\n";
}
}

modify;

close(RFH);

system("/bin/cat AXM_FT_AUT_Modify_Nodes_ALL_NO_NODE.txt | /bin/grep FAIL ");
if ($? == 0)
{
	print  "\nFAIL\n";
}
else
{
	print "\nPASS\n";
}
