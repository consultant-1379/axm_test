#!/usr/bin/perl
#
# SCRIPT NAME:AXM_FT_EAC_PORT_nrma_server_NO_NODE.pl
# Test Case &Priority:AXM_FT_EAC_PORT_nrma_server_NO_NODE.pl #(Pr.2)
# Test Case No :6.11.1(common)
# AUTHOR:
# DATE  :
# REV:
#
# Description :
# Prerequisites  :
# Return Value on Success : 0
# Return Value on Failure : 1
# Result File : /home/nmsadm/eam/results
#
# Usage :  bash RUNME -t AXM_FT_EAC_PORT_nrma_server_NO_NODE.pl:NO_NODE
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
#my $TC         = "AXM_FT_EAC_PORT_nrma_server_NO_NODE";
#my $RESULT_DIR = $ENV{RESULT_DIR};
#my $TMP        = $ENV{TMP};

#$ENV{tc} = AXM_FT_EAC_PORT_nrma_server_NO_NODE;
$ntwrk_element=$ARGV[0];#ENV{ntwrk_element};

#FRAME::start_frame "$TC";
#======================================================================
open(RFH,">AXM_FT_EAC_PORT_nrma_server_NO_NODE.txt");
sub Nrma_Restart
{
$Restart = `/opt/ericsson/nms_cif_sm/bin/smtool -coldrestart eam_nrma -reason="other" -reasontext=" "`;
system("$Restart");
sleep(40);
$progress = `/opt/ericsson/nms_cif_sm/bin/smtool list eam_nrma`;
#$progress = chomp $progress;
if ($progress =~ /started/ ) 
{
	print RFH "PASS : Command execution PASSED:EAM MC $progress is started successfully\n";
#Te::tex "$TC", "\nINFO  :Command execution PASSED:EAM MC $progress is started successfully";
}
else
{
	print RFH "PASS : Command execution FAILED\n";
#Te::tex "$TC", "\nERROR  :Command execution FAILED ";
}
}


print "Port No Before Replacement \n";
print "#######################\n";
$cmd = `/bin/ps -ef | /bin/grep eac_nrma_server | /bin/grep -v /bin/grep | /bin/awk -e '{ print $2 }' | /bin/xargs pfiles | /bin/grep 50001`;
if ($cmd =~ /sockname: AF_INET6 ::  port: 50001/)
{
print RFH "PASS : Port Number is matched\n";
 #Te::tex "$TC", "\nINFO  :Port Number is matched";
}
else
{
print RFH "FAIL : Port number doesn't match\n"; 
 #Te::tex "$TC", "\nERROR  :Port number doesn't match"; 
}
system("perl -pi -e 's/NRMA_POA_PORT=50001/NRMA_POA_PORT=50101/g' /etc/opt/ericsson/nms_eam_eac/cxc.env");
sleep(5);
Nrma_Restart;
print "Port No After Replacement \n";
print "#######################\n";
$cmd1 = `/bin/ps -ef | /bin/grep eac_nrma_server | /bin/grep -v /bin/grep | /bin/awk -e '{ print $2 }' | /bin/xargs pfiles | /bin/grep 50101`;

if ($cmd1 =~ /sockname: AF_INET6 ::  port: 50101/)
{
	print RFH "PASS : Replaced Port Number is matched\n";
#Te::tex "$TC", "\nINFO  :Replaced Port Number is matched";

}
else
{
	print RFH "FAIL : Replaced Port Number is not matched\n";
# Te::tex "$TC", "\nERROR  : Replaced Port Number is not matched";
}
print "Port No Revert back to the actual Port number \n";
print "#######################\n";
system("perl -pi -e 's/NRMA_POA_PORT=50101/NRMA_POA_PORT=50001/g' /etc/opt/ericsson/nms_eam_eac/cxc.env");
sleep(5);
Nrma_Restart;
$cmd2 = `/bin/ps -ef | /bin/grep eac_nrma_server | /bin/grep -v /bin/grep | /bin/awk -e '{ print $2 }' | /bin/xargs pfiles | /bin/grep 50001`;
print "$cmd2\n";
if ($cmd2 =~ /sockname: AF_INET6 ::  port: 50001/)
{
	print RFH "PASS : Port Number reversal is done\n";
}
else
{
	print RFH "FAIL : Port number doesn't match\n"; 
}

close(RFH);

system("/bin/cat AXM_FT_EAC_PORT_nrma_server_NO_NODE.txt | /bin/grep FAIL ");
if ($? == 0)
{
print  "FAIL\n";
}
else
{
print "PASS\n";
#unlink("AXM_FT_EAC_PORT_nrma_server_NO_NODE.txt");
}


#=======================================================================
#FRAME::end_frame "$TC";
