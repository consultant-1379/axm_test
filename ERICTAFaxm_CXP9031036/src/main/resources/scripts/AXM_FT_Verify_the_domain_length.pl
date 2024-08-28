#!/usr/bin/perl
##
# SCRIPT NAME:AXM_FT_UPDATE_TMOS.pl
# Test Case & Priority: AXM_FT_UPDATE_TMOS (Pr.1)
# Test Case No :15.5 (Common)
# AUTHOR:XNNNKKR
# DATE :19/12/2014
# REV:1.0
#
# Description :To check the eaw connection after changing the domain name to more than 128.
# Prerequisites  :NA
# Return Value on Success : 0
# Return Value on Failure : 1
# Result File : NA
#
# Usage :  /usr/local/bin/perl AXM_FT_UPDATE_TMOS:ALL types of nodes.
#
# Dependency : atoss package installation,Script should run from /home/nmsadm path.
#
# REV HISTORY
# DATE:                           BY                                 MODIFICATION:
#19/12/2014                     XNNNKKR                             Version 1.0
#26/03/2015                     XNNNKKR	                            Version 1.1
##########################################################

# DEFINE FILES AND VARIABLES HERE
use Expect;
#Writing the script print statements to the file to check pass or fail.

open(RFH,">xxx.txt");
#Getting the node name from command line
$ntwrk_element=$ARGV[0];

#This sub-routine checks the connection to the node
sub conn_check
{
if($?==0)
{
print RFH "PASS:Node connection is successful\n";
}
else
{
print RFH "FAIL:Node connection is not successful\n";
}
}
#This sub-routine refreshes the map file after every update
sub sys_refresh
{
system("cap_pdb_make eac_egi_map");
system("cap_pdb_make eac_esi_map");
}
#Checking the node connection
sub node_conn
{ 
        
	print "Establishing connection for $node\n";    
        my $expect = Expect->new;
        my $command = "/opt/ericsson/bin/eaw $ntwrk_element";
        $expect->spawn($command) or die "Cannot spawn : $!\n";
        $expect->log_file("/home/nmsadm/tryexpect.log","w");
        $expect->expect(5,'<');
        $expect->send("quit;\r");
        $expect->soft_close();
 
}
$original=`grep "TMOS_node" /etc/opt/ericsson/nms_cif_tmos_tbs/param/eac_egi_map.par | cut -d'"' -f2`;
chomp($original);
#Taking the backup of eac_egi_parameter file
system("cp /etc/opt/ericsson/nms_cif_tmos_tbs/param/eac_egi_map.par /home/nmsadm/eac_egi_map.par");

#print "The original value is: $original\n";
$updated_original="athtem.eei.ericsson.sefxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";



node_conn;
conn_check;
#Getting the coredump data before execution
system("ls -lrt /ossrc/upgrade/core > /home/nmsadm/old_core.txt");


#Updating the parameter file with the allowed string value equal to 128 characters and printing it
system("perl -pi.back -e 's/$original/$updated_original/;' /etc/opt/ericsson/nms_cif_tmos_tbs/param/eac_egi_map.par");
sys_refresh;
open (FH,"/etc/opt/ericsson/nms_cif_tmos_tbs/param/eac_egi_map.par") or die "Cannot spawn : $!\n";
@file_contents_b = <FH>;
print "The file contents of b are:@file_contents_b\n";
close(FH);

node_conn;
conn_check;


#Replacing the backup file after verification to verify the connection and printing it.
system("cp /home/nmsadm/eac_egi_map.par /etc/opt/ericsson/nms_cif_tmos_tbs/param/eac_egi_map.par");
#system("perl -pi.back -e 's/$exceeds_original/$original/;' /etc/opt/ericsson/nms_cif_tmos_tbs/param/eac_egi_map.par");
sys_refresh;
open (FH,"/etc/opt/ericsson/nms_cif_tmos_tbs/param/eac_egi_map.par") or die "Cannot spawn : $!\n";
@file_contents = <FH>;
print "The file contents after Reversal are :@file_contents\n";
close(FH);

node_conn;
conn_check;

print "Connection works after Reversal\n";

close(RFH);
#Getting the coredump data after execution
system("ls -lrt /ossrc/upgrade/core > /home/nmsadm/new_core.txt");
$old_file=`wc -l < /home/nmsadm/old_core.txt`;
$new_file=`wc -l < /home/nmsadm/new_core.txt`;

if($old_file==$new_file)
{
print RFH "PASS:No Coredumps have been created\n";

}
else
{
print RFH "FAIL:Coredumps have been found\n";
}



  
system("/bin/cat xxx.txt| /bin/grep FAIL ");

if ($? == 0)
	{
   		print  "\nFAIL\n";
   	}
else
   	{	
   		print "\nPASS\n";
   	}



