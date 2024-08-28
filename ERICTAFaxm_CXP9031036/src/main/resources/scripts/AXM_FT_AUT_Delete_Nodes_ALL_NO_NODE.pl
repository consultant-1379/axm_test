#!usr/bin/perl
#
# SCRIPT NAME:AXM_FT_AUT_Delete_Nodes_ALL_NO_NODE.pl
# Test Case & Priority:AXM_FT_AUT_Delete_Nodes_ALL_NO_NODE.pl (Pr.1)
# Test Case No 9.1.1(common)
# AUTHOR : XNNNKKR
# DATE :11/08/2014 
# REV :1.0
#
# Description :This test script does the import of delete xml which in turn delete the nodes created by create xml.
# Return Value on Success :PASS
# Return Value on Failure :FAIL
#
# Usage  : /usr/local/bin/perl AXM_FT_AUT_Delete_Nodes_ALL_NO_NODE.pl.
#
# Dependency  :The delete xml file "eam_Auto_NE_delete_ALL.xml" should be present in the /home/nmsadm path.
#
# REV HISTORY
# DATE:                           BY                                 MODIFICATION:
#02/09/2014                      XNNNKKR                            Modified the script into TAF Complaint.
##########################################################
sub line_read
{ 
        $cnt=0;
	open(FH,"/home/nmsadm/xxx.txt") or die "error. $!";
	while (<FH>) 
       
	{$cnt++ if  !/^\s+?$/;}
	close FH;
        chomp($cnt);
}



system("/opt/ericsson/bin/eac_esi_config -nl > /home/nmsadm/xxx.txt");

line_read;

print "The count before delete is :$cnt\n";

open(RFH,">AXM_FT_AUT_Delete_Nodes_ALL_NO_NODE.txt");

$filename= "/home/nmsadm/eam_Auto_NE_delete_ALL.xml";

sub destroy
{
	if (-e $filename) 
	{
		print "File Exists!";
		$var =`/opt/ericsson/arne/bin/import.sh -f $filename -import -i_nau`;
		print "$var\n";

		$deleted_nodes = $cnt-18;
		chomp($deleted_nodes);

		system("/opt/ericsson/bin/eac_esi_config -nl >/home/nmsadm/xxx.txt");
	
		line_read;

		print "The count of deleted nodes are:$deleted_nodes\n";

		print "The count after delete is :$cnt\n";


			if ($cnt eq $deleted_nodes)
			{
				print RFH "PASS :Delete Import is successful\n";
			}
	else
	{
		print RFH "FAIL :Delete Import is not successful\n";


	}		
}
	else
	{
		print RFH "FAIL :Delete Import xml File doesn't exist\n";
	
	}
}

destroy;
close(RFH);

system("/bin/cat AXM_FT_AUT_Delete_Nodes_ALL_NO_NODE.txt | /bin/grep FAIL ");
if ($? == 0)
{
	print  "\nFAIL\n";
}
else
{
	print "\nPASS\n";
}
