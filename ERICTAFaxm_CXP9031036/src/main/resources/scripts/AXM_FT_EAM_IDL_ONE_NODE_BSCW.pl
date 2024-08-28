#!/usr/bin/perl
#
# SCRIPT NAME:AXM_FT_EAM_IDL_ONE_NODE_BSCW.pl
# Test Case & Priority: AXM_FT_EAM_IDL_ONE_NODE_BSCW (Pr.1)
# Test Case No : 6.26
# AUTHOR:xharcha
# DATE  :
# REV:
#
############################### Description ###################
# EAM IDL improvements for handling the file descriptors      #
# Check that the CLOSE_WAIT state of the file descriptor goes #
# after the connection idle time                              #
###############################################################
# Prerequisites  : Idl package needs to be installed in the server. idl_script.sh and cmd.txt files should be present in INPUT directory.
# Return Value on Success : 0
# Return Value on Failure : 1
# Result File : /home/nmsadm/eam/results
#
# Usage :  bash RUNME -t AXM_FT_EAM_IDL_ONE_NODE_BSCW.pl.
#
# Dependency : Te.pm, crdmp.sh, PMSEerrorchk.sh
#
# REV HISTORY
# DATE:                           BY                                 MODIFICATION:
# DATE:                           BY                                 MODIFICATION:
#
##########################################################
# DEFINE FILES AND VARIABLES HERE

use Expect;

$ntwrk_element=$ARGV[0];

open(RFH,">/home/nmsadm/AXM_FT_EAM_IDL_ONE_NODE_BSCW.txt");
#========================================================================
#if( -d "/opt/ericsson/nms_eam_test/bin/")
#{

#`eac_esi_config -ne BSCWR -set conn_idle_to 60`;
sub CHECK_IDL
{
`/opt/ericsson/bin/eac_esi_config -ne $ntwrk_element -set conn_idle_to 60`;
sleep(10);
$path = "/opt/ericsson/nms_eam_test/bin/";

chdir($path) or die "cant open $path $!";
#system("./idl_script.sh -ne BSCWR -f cmd.txt &");
system("/opt/ericsson/nms_eam_test/bin/idl_script.sh -ne $ntwrk_element -f /home/nmsadm/eam/bin/INPUT/cmd.txt &");
sleep(10);

$pid = `/bin/ps -eaf | /bin/grep "/opt/borland/bes/bin/vbj"| /bin/grep -v /bin/grep| /bin/awk '{print \$2}'`;
print "\n child id:$pid\n";
`/bin/kill -STOP $pid`;
sleep(72);


my $PID_IDL= `/bin/ps -eaf | /bin/grep eac_eai_idl_server | /bin/grep -v /bin/grep | /bin/awk '{print \$2}'`;
chomp($PID_IDL);
system("/usr/local/bin/lsof -p $PID_IDL > /tmp/lsof.txt");
print "IDL_SERVER :$PID_IDL";
sleep(10);
$search = `/bin/cat /tmp/lsof.txt | tail -3 | /bin/grep -i CLOSE_WAIT`;

if ($search)

{
	print RFH "FAIL : Failed, CLOSE_WAIT still exists\n";
	#Te::tex "$TC", "\n\nERROR  : Failed, CLOSE_WAIT still exists\n";

}
else
{
	print RFH "PASS : successfully cleared\n";
#	Te::tex "$TC", "\n\nINFO  :  successfully cleared\n";
}
`/bin/kill -9 $pid`;
}
if( -f "/opt/ericsson/nms_eam_test/bin/idl_script.sh")
{
	CHECK_IDL;
}
else
{
	print "Entering else";
  my $expect;
  $expect = Expect->spawn("/bin/su - root");
  $expect->expect (10,'Password:');
  $expect->send("shroot12\r");
  $expect->expect (10,'#');
  $expect->send("bash\r");
  $expect->expect (10,'#');

$expect->send("ist_run -d /home/nmsadm/eam/bin/INPUT/19089-LPA_APR901982_B_R1C01.pkg -auto -force -pa\r");
$expect->expect (600,'#');

$expect->send("/bin/cp /home/nmsadm/eam/bin/INPUT/idl_script.sh /opt/ericsson/nms_eam_test/bin/.\r");
$expect->expect (30,'#');


$expect->send("/bin/cp /home/nmsadm/eam/bin/INPUT/cmd.txt /opt/ericsson/nms_eam_test/bin/.\r");
$expect->expect (30,'#');

$expect->send("/bin/chmod 777 /opt/ericsson/nms_eam_test/bin/idl_script.sh\r");
$expect->expect (10,'#');
$expect->send("/bin/chmod 777 /opt/ericsson/nms_eam_test/bin/cmd.txt\r");
$expect->expect (10,'#');
$expect->soft_close();
close(RFH);
CHECK_IDL;
}
system("/bin/grep FAIL /home/nmsadm/AXM_FT_EAM_IDL_ONE_NODE_BSCW.txt");

if ($? == 0)
{
print  "\nFAIL\n";
}
else
{
print "\nPASS\n";
#unlink("/bin/grep FAIL /home/nmsadm/naveen/AXM_FT_EAM_IDL_ONE_NODE_BSCW.txt")
}

