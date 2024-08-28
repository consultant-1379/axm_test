#!usr/bin/perl
#
# SCRIPT NAME : AXM_FT_ADD_PG_nodes_via_oex_NO_NODE.pl
# Test Case & Priority : AXM_FT_ADD_PG_nodes_via_oex_NO_NODE.pl (Pr.1)
# Test Case No 9.1.1(common)
# AUTHOR : XNNNKKR
# DATE : 10/10/2013
# REV : 1.0
#
#Description : This test case is to Add, delete and Modify PG nodes
#
# Return Value on Success : PASS
# Return Value on Failure : FAIL
#
# Usage : /usr/local/bin/perl AXM_FT_ADD_PG_nodes_via_oex_NO_NODE.pl
#
# Dependency : /home/nmsadm/eam/bin/INPUT/PG_CUDB.xml, /home/nmsadm/eam/bin/INPUT/PG_CUDB_MODIFY.xml, 
#	        /home/nmsadm/eam/bin/INPUT/PG_CUDB_DELETE.xml
#
# REV HISTORY
# DATE                           BY                                 MODIFICATION
# 20/08/2014  	  xaksgan		       Changed the script to TAF complaint
############################################################################


use Expect;
print "\nRestarting cap_pdb_nfh..\n";
`/opt/ericsson/nms_cif_sm/bin/smtool -coldrestart "cap_pdb_nfh" -reason=other -reasontext=" "`;	# restating cap_pdb_nfh MC to unlock datavbase
$cap_pdp_status=`/opt/ericsson/nms_cif_sm/bin/smtool -l  | /bin/grep cap_pdb_nfh`;
until($cap_pdp_status =~ started)					
{
	$cap_pdp_status=`/opt/ericsson/nms_cif_sm/bin/smtool -l  | /bin/grep cap_pdb_nfh`;
        sleep(2);
	print "$cap_pdp_status";
}
open(RFH,">AXM_FT_ADD_PG_nodes_via_oex_NO_NODE.txt");
$filename= "/home/nmsadm/eam/bin/INPUT/PG_CUDB.xml";
$filename1= "/home/nmsadm/eam/bin/INPUT/PG_CUDB_MODIFY.xml";
$filename2= "/home/nmsadm/eam/bin/INPUT/PG_CUDB_DELETE.xml";
$string1 = "No Errors Reported";
$string2 = "Import Finished";
$string4 = "Import completed";
$string5 = "The APG IO Upgrade is successfull";

sub create
{
	if (-e $filename) 
	{
		print "File Exists. Creating nodes..\n";
		$var =`/opt/ericsson/arne/bin/import.sh -f $filename -import -i_nau`;
		print "$var\n";
		if ($var =~ $string1 && $var =~ $string2)
		{
			print "Import Successful\n";
			print RFH "PASS :Import is successful\n";
		}
		else
		{
			print "Import is not successful\n";
			print RFH "FAIL : Import is not successful\n";
		}
	}
	else
	{
		print "File doesn't exist\n";
		print RFH "FAIL : Import xml File doesn't exist\n";
	}
}

sub modify
{
	if (-e $filename1) 
	{
		print "File Exists. Modifying nodes..\n";
		$var1 =`/opt/ericsson/arne/bin/import.sh -f $filename1 -import -i_nau`;
		print "$var1\n";
		if ($var1 =~ $string1 && $var1 =~ $string2)
		{
			print "Modify successful\n";
			print RFH "PASS :Modify Import is successful\n";
		}
		else
		{
			print "Modify not successful\n";
			print RFH "FAIL : Modify Import is not successful\n";
		}
	}
	else
	{
		print "File doesn't exist\n";
		print RFH "FAIL : Modify xml File doesn't exist\n";
	}
}

sub destroy
{
	if (-e $filename2) 
	{
		print "File Exists!..Deleting nodes.\n";
		$var2 =`/opt/ericsson/arne/bin/import.sh -f $filename2 -import -i_nau`;
		print "$var2\n";
		if ($var2 =~$string1 && $var2 =~$string2)
		{
			print "Deleting is successful\n";
			print RFH "PASS :Delete Import is successful\n";
		}
		else
		{
			print "Deleting is not successful\n";
			print RFH "FAIL :Delete Import is not successful\n";
		}
	}	
	else
	{
		print "File doesn't exists\n";
		print RFH "FAIL :Delete xml File doesn't exist\n"
	}
}
create;
modify;
destroy;
close(RFH);

system("/bin/cat AXM_FT_ADD_PG_nodes_via_oex_NO_NODE.txt | /bin/grep FAIL ");
if ($? == 0)
{
	print  "\nFAIL\n";
}
else
{
	print "\nPASS\n";
	unlink("AXM_FT_ADD_PG_nodes_via_oex_NO_NODE.txt");
}
