#!/usr/bin/perl
#
# SCRIPT NAME:AXM_FT_EAC_ESI_Config_SetNeparameter_ALL.pl
# Test Case & Priority: AXM_FT_EAC_ESI_Config_SetNeparameter (Pr.2)
# Test Case No :6.12.2(common)
# AUTHOR:
# DATE  :
# REV:
#######################Description###########################################################
# This test case Is to set the NE parameters. Parameter setting is updated and no warm restart is performed.
#############################################################################################
# Prerequisites  :
# Return Value on Success : 0
# Return Value on Failure : 1
# Result File : /home/nmsadm/eam/results
#
# Usage :  bash RUNME -t AXM_FT_EAC_ESI_Config_SetNeparameter_ALL.pl:<node_name>
#
# Dependency : Te.pm, crdmp.sh, PMSEerrorchk.sh
#
# REV HISTORY
# DATE:                           BY                                 MODIFICATION:
#
##########################################################
use Expect;
$ntwrk_element=$ARGV[0];#$ENV{ntwrk_element};

print "\nRestarting cap_pdb_nfh..\n";
`/opt/ericsson/nms_cif_sm/bin/smtool -coldrestart "cap_pdb_nfh" -reason=other -reasontext=" "`;	# restating cap_pdb_nfh MC to unlock datavbase
$cap_pdp_status=`/opt/ericsson/nms_cif_sm/bin/smtool -l  | /bin/grep cap_pdb_nfh`;
until($cap_pdp_status =~ started)					
{
	$cap_pdp_status=`/opt/ericsson/nms_cif_sm/bin/smtool -l  | /bin/grep cap_pdb_nfh`;
        	sleep(2);
	print "$cap_pdp_status";
}

open (RFH,">AXM_FT_EAC_ESI_Config_SetNeparameter_ALL.txt");
my $cr_deamon = `/opt/ericsson/bin/eac_esi_config -ne $ntwrk_element |  /bin/grep -i "cr_daemon" | /bin/cut -d "=" -f2 | /usr/bin/tr -d '\040\011\012\015'`;
my $conn_idle_to = `/opt/ericsson/bin/eac_esi_config -ne $ntwrk_element | /bin/grep -i "conn_idle_to" | /bin/cut -d "=" -f2 | /usr/bin/tr -d '\040\011\012\015'`;
my $short_buf_to= `/opt/ericsson/bin/eac_esi_config -ne $ntwrk_element |  /bin/grep -i "short_buf_to" | /bin/cut -d "=" -f2 | /usr/bin/tr -d '\040\011\012\015'`;

print "Original values:\n";
print "cr deamon = $cr_deamon\n";
print "conn_idle_to = $conn_idle_to\n";
print "short_buf_to = $short_buf_to\n";

print "\nSetting the parameter values\n";
print "Changing cr_daemon for $ntwrk_element to 'test'\n";
system("/opt/ericsson/bin/eac_esi_config -set cr_daemon test -ne $ntwrk_element");
print "Changing conn_idle_to for $ntwrk_element to '15'\n";
system("/opt/ericsson/bin/eac_esi_config -set conn_idle_to 15 -ne $ntwrk_element");
print "Changing short_buf_to for $ntwrk_element to '800' \n";
system("/opt/ericsson/bin/eac_esi_config -set short_buf_to 800 -ne $ntwrk_element");

my $cr_deamon_n = `/opt/ericsson/bin/eac_esi_config -ne $ntwrk_element | /bin/grep -i "cr_daemon" | /bin/cut -d "=" -f2`;
my $conn_idle_to_n = `/opt/ericsson/bin/eac_esi_config -ne $ntwrk_element | /bin/grep -i "conn_idle_to" | /bin/cut -d "=" -f2`;
my $short_buf_to_n= `/opt/ericsson/bin/eac_esi_config -ne $ntwrk_element |  /bin/grep -i "short_buf_to" | /bin/cut -d "=" -f2`;


if ($cr_deamon_n == "test" && $conn_idle_to_n == "15" && $short_buf_to_n == "800")
{
	print "PASS : Parameters have been set successfully\n"; 
        print RFH "PASS : Parameters have been set successfully\n";
}
else
{
        print RFH "FAIL :  Parameter set is not successful\n";
}

print "Reverting the parameter values\n";
system("/opt/ericsson/bin/eac_esi_config -set cr_daemon $cr_deamon -ne $ntwrk_element");
system("/opt/ericsson/bin/eac_esi_config -set conn_idle_to $conn_idle_to -ne $ntwrk_element");
system("/opt/ericsson/bin/eac_esi_config -set short_buf_to $short_buf_to -ne $ntwrk_element");


my $cr_deamon_o = `/opt/ericsson/bin/eac_esi_config -ne $ntwrk_element | /bin/grep -i "cr_daemon" | /bin/cut -d "=" -f2 | /usr/bin/tr -d '\040\011\012\015'`;
#$cr_deamon_o = chomp $cr_deamon_o;
my $conn_idle_to_o = `/opt/ericsson/bin/eac_esi_config -ne $ntwrk_element | /bin/grep -i "conn_idle_to" | /bin/cut -d "=" -f2 | /usr/bin/tr -d '\040\011\012\015'`;
#$conn_idle_to_o = chomp $conn_idle_to_o;
my $short_buf_to_o= `/opt/ericsson/bin/eac_esi_config -ne $ntwrk_element | /bin/grep -i "short_buf_to" | /bin/cut -d "=" -f2 | /usr/bin/tr -d '\040\011\012\015'`;
#$short_buf_to_o = chomp $short_buf_to_o;
print "original value of cr deamon = $cr_deamon_o\n";
print "original value of conn_idle_to = $conn_idle_to_o\n";
print "original value of short_buf_to = $short_buf_to_o\n";
if (($cr_deamon eq $cr_deamon_o) && ($conn_idle_to eq $conn_idle_to_o) && ($short_buf_to eq $short_buf_to_o))
{
        print RFH "PASS : Parameters have been set successfully\n";

}
else
{
        print RFH "FAIL : NE Parameter set is not successful\n";
}
close(RFH);

system("/bin/cat AXM_FT_EAC_ESI_Config_SetNeparameter_ALL.txt | /bin/grep FAIL ");
if ($? == 0)
{
	print  "FAIL\n";
}
else
{
	print "PASS\n";
}
#=======================================================================
