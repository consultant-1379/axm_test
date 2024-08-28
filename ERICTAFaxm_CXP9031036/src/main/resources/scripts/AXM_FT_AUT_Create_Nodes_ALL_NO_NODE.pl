#!usr/bin/perl
#
# SCRIPT NAME:AXM_FT_AUT_Create_Nodes_ALL_NO_NODE.pl
# Test Case & Priority:AXM_FT_AUT_Create_Nodes_ALL_NO_NODE.pl (Pr.1)
# Test Case No 9.1.1(common)
# AUTHOR : XNNNKKR
# DATE   :10/1/2014
# REV    :1.0
#
# Description :To import all types of nodes in the server. 
# Return Value on Success  :PASS
# Return Value on Failure  :FAIL
#
# Usage  : /usr/local/bin/perl AXM_FT_AUT_Create_Nodes_ALL_NO_NODE.pl.
#
# Dependency  :The below xml file should be present in the below path:-
#/home/nmsadm/eam/bin/INPUT/AXM_FT_AUT_ALL_create.xml and the node names present in the xml should not be present during the import.
#
# REV HISTORY
# DATE                           BY                                 MODIFICATION
#11/08/2014                     XNNNKKR                            Modified the script into TAF Compliant.
##########################################################

use Expect;

open(RFH,">AXM_FT_AUT_Create_Nodes_ALL_NO_NODE.txt");



$filename= "/home/nmsadm/eam/bin/INPUT/AXM_FT_AUT_ALL_create.xml";
$string1 = "No Errors Reported";
$string2 = "Import Finished";


sub create
{
if (-e $filename) 
{
print "File Exists!";
$var =`/opt/ericsson/arne/bin/import.sh -f $filename -import -i_nau`;
print "$var\n";
if ($var =~ $string1 && $var =~ $string2)
{
print RFH "PASS:Import is successful\n";

}
else
{
print RFH "FAIL:Import is not successful\n"; 

}
}
else
{
print RFH "FAIL :Import xml File doesn't exist\n";
}
}

create;
close(RFH);

system("/bin/cat AXM_FT_AUT_Create_Nodes_ALL_NO_NODE.txt| /bin/grep FAIL ");
if ($? == 0)
{
	print  "\nFAIL\n";
}
else
{
	print "\nPASS\n";
}
