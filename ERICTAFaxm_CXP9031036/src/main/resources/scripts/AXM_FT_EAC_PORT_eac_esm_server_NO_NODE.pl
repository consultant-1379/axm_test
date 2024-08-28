#!/usr/bin/perl
#
# SCRIPT NAME:AXM_FT_EAC_PORT_eac_esm_server_NO_NODE.pl
# Test Case &Priority:AXM_FT_EAC_PORT_eac_esm_server_NO_NODE.pl (Pr.1)
# Test Case No :6.11.9(common)
# AUTHOR:
# DATE  :
# REV:
#
################################ Description ######################
#To check the default port used for eac_esm_server and verify it is configurable.
###################################################################
# Prerequisites  :
# Return Value on Success : 0
# Return Value on Failure : 1
# Result File : /home/nmsadm/eam/results
#
# Usage :  bash RUNME -t AXM_FT_EAC_PORT_eac_esm_server_NO_NODE.pl:NO_NODE
#
# Dependency : Te.pm, crdmp.sh, PMSEerrorchk.sh
#
# REV HISTORY
# DATE:                           BY                                 MODIFICATION:
#
##########################################################

# DEFINE FILES AND VARIABLES HERE
#use Te;
#use FRAME;
use Expect;
#use util;
#my $EAM_DIR    = $ENV{EAM_DIR};
#my $TC         = "AXM_FT_EAC_PORT_eac_esm_server_NO_NODE";
#my $RESULT_DIR = $ENV{RESULT_DIR};
#my $TMP        = $ENV{TMP};

#$ENV{tc} = AXM_FT_EAC_PORT_eac_esm_server_NO_NODE;
$ntwrk_element=$ARGV[0];#$ENV{ntwrk_element};

#FRAME::start_frame "$TC";
#======================================================================
open(RFH,">AXM_FT_EAC_PORT_eac_esm_server_NO_NODE.txt");
sub Common_Restart
{
$Restart = `/opt/ericsson/nms_cif_sm/bin/smtool -coldrestart eam_common -reason="other" -reasontext=" "`;
system("$Restart");
sleep(50);
$progress = `/opt/ericsson/nms_cif_sm/bin/smtool list eam_common`;
#$progress = chomp $progress;
if ($progress =~ /started/ ) 
{
	print RFH "PASS : Command execution PASSED:EAM MC $progress is started successfully\n";
#Te::tex "$TC", "\nINFO  :Command execution PASSED:EAM MC $progress is started successfully";
}
else
{
	print RHF "FAIL : Command execution FAILED\n";
#Te::tex "$TC", "\nERROR  :Command execution FAILED ";
}
}


print "Port No value before comment \n";
print "#######################\n";
$cmd = `/usr/sbin/makedbm -u /etc/opt/ericsson/nms_cif_tmos_tbs/dat/.ipcdir_ndbm_table | /bin/grep 50007`;
print "$cmd\n";
if ($cmd =~ /masterservice eac_esm_server 50007/)
{
	print RFH "PASS : Master Service is matched\n";
# Te::tex "$TC", "\nINFO  :Master Service is matched";
}
else
{
 print RFh "FAIL : Master Service doesn't match\n";
# Te::tex "$TC", "\nERROR  :Master Service doesn't match"; 
 
}
system("perl -pi -e 's/EAC_ESM_PORT=50007/#EAC_ESM_PORT=50007/g' /etc/opt/ericsson/nms_eam_eac/cxc.env");
sleep(5);
Common_Restart;
print "Port No value After comment \n";
print "#######################\n";
@cmd1 = `/usr/sbin/makedbm -u /etc/opt/ericsson/nms_cif_tmos_tbs/dat/.ipcdir_ndbm_table | /bin/grep eac_esm_server`;
print "The value is :$cmd1[1]";

if ($cmd1[1] =~  /masterservice eac_esm_server 50007/)
{
	print RFH "FAIL :  Same port number\n";
#Te::tex "$TC", "\nERROR  : Same port number";
}
else
{
	print RFH "PASS : Port number is not same\n";
#Te::tex "$TC", "\nINFO  :Port number is not same";
}
print "Port No Revert back to the actual Port number \n";
print "#######################\n";
system("perl -pi -e 's/#EAC_ESM_PORT=50007/EAC_ESM_PORT=50007/g' /etc/opt/ericsson/nms_eam_eac/cxc.env");
sleep(5);
Common_Restart;
@cmd2 = `/usr/sbin/makedbm -u /etc/opt/ericsson/nms_cif_tmos_tbs/dat/.ipcdir_ndbm_table | /bin/grep eac_esm_server`;
print "$cmd2\n";
if ($cmd2[1] =~ /masterservice eac_esm_server 50007/)
{
	print RFH "PASS : Port Number field uncommented Successfully\n";
# Te::tex "$TC", "\nINFO  :Port Number field uncommented Successfully";
}
else
{
 print RFH "FAIL : Port number field is still commented\n";
# Te::tex "$TC", "\nERROR  :Port number field is still commented"; 
}
close(RFH);

system("/bin/cat AXM_FT_EAC_PORT_eac_esm_server_NO_NODE.txt | /bin/grep FAIL ");
if ($? == 0)
{
print  "FAIL\n";
}
else
{
print "\nPASS\n";
#unlink("AXM_FT_EAC_PORT_eac_esm_server_NO_NODE.txt");
}



#=======================================================================
#FRAME::end_frame "$TC";
