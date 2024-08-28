#!/usr/bin/perl
#
# SCRIPT NAME:AXM_FT_Default_TELNET_MTS_port_value_NO_NODE.pl
# Test Case & Priority: AXM_FT_Default_TELNET_MTS_port_value (Pr.1)
# Test Case No : 9.1.3 (COMMON)
# AUTHOR: XNNNKKR
# DATE : 10/10/2014
# REV : 1.0
#
# Description : These tests verify the default port value i.e 8010 for the protocol and TELNET_MTS 
# 		and verify the parameter value of newly created PG nodes in eac_esi_map file as well
#
#
# Return Value on Success : PASS
# Return Value on Failure : FAIL
#
# Usage : /usr/local/bin/perl AXM_FT_Default_TELNET_MTS_port_value_NO_NODE.pl
#
# Dependency : /home/nmsadm/eam/bin/INPUT/PG_CUDB.xml, /home/nmsadm/eam/bin/INPUT/PG_CUDB_DELETE.xml
#
# REV HISTORY
# REV NO.	DATE:                           BY                                 MODIFICATION:
# 1.1		20/08/2014			xaksgan			Changed the script to TAF complaint
#########################################################################################################

use Expect;

print "\nRestarting cap_pdb_nfh \n";
`/opt/ericsson/nms_cif_sm/bin/smtool -coldrestart "cap_pdb_nfh" -reason=other -reasontext=" "`;	# restating cap_pdb_nfh MC to unlock datavbase
$cap_pdp_status=`/opt/ericsson/nms_cif_sm/bin/smtool -l  | /bin/grep cap_pdb_nfh`;
until($cap_pdp_status =~ started)					
{
	$cap_pdp_status=`/opt/ericsson/nms_cif_sm/bin/smtool -l  | /bin/grep cap_pdb_nfh`;
        sleep(2);
	print "$cap_pdp_status";
}
open (RFH,">AXM_FT_Default_TELNET_MTS_port_value_NO_NODE.txt");
$filename = "/home/nmsadm/eam/bin/INPUT/PG_CUDB.xml";
$string1 = "No Errors Reported";
$string2 = "Import Finished";
$filename2 = "/home/nmsadm/eam/bin/INPUT/PG_CUDB_DELETE.xml";
sub create
{
	if (-e $filename) 
	{
		print "File Exists!";
		$var =`/opt/ericsson/arne/bin/import.sh -f $filename -import -i_nau`;
		print "$var\n";
		if ($var =~ $string1 && $var =~ $string2)
		{
			print "Import is successful\n";
			print RFH "PASS : Import is successful\n";

		}	
		else
		{
			print "Import not successful\n";
			print RFH "FAIL : Import is not successful\n";
		}
	}
	else
	{
		print "File doesn't exist\n";
		print RFH "FAIL : Import xml File doesn't exist\n";
	}
}

sub destroy
{
	if (-e $filename2) 
	{
		print "File Exists!";
		$var2 =`/opt/ericsson/arne/bin/import.sh -f $filename2 -import -i_nau`;
		print "$var2\n";
		if ($var2 =~$string1 && $var2 =~$string2)
		{
			print "Delete is successful\n";
			print RFH "PASS : Delete Import is successful\n";	
		}
		else
		{
			print "Delete is not successful\n";
			print RFH "FAIL : Delete Import is not successful\n"; 
		}
	}
	else
	{
		print "File doesn't exist\n";
		print RFH "FAIL : Delete xml File doesn't exist\n";
	}
}

create;
system("/opt/ericsson/bin/cap_pdb_cat_map eac_esi_map >> telnet_mts.log ");
system("/bin/grep 8010 telnet_mts.log && /bin/grep ehema_ac_in telnet_mts.log");
if ( $? == 0 ) 
{
	print RFH "PASS : PG node exists\n";
}
else 
{
	print RFH "FAIL : PG node doesn't exist\n";
}

destroy;
close(RFH);

system("/bin/cat AXM_FT_Default_TELNET_MTS_port_value_NO_NODE.txt | /bin/grep FAIL ");
if ($? == 0)
{	
	print"FAIL\n";
}
else
{
	print "PASS\n";
	unlink("AXM_FT_Default_TELNET_MTS_port_value_NO_NODE.txt");
}
