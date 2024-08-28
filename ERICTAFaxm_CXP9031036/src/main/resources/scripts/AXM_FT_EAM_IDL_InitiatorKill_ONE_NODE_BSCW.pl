#!/usr/bin/perl
#
# SCRIPT NAME:AXM_FT_EAM_IDL_InitiatorKill_ONE_NODE_BSCW.pl
# Test Case & Priority: AXM_FT_EAM_IDL_InitiatorKill_ONE_NODE_BSCW (Pr.1)
# Test Case No : 6.26
# AUTHOR:XHARCHA
# DATE  :
# REV:
#
############################### Description ###################
# EAM IDL improvements for handling the file descriptors      #
# Check that the CLOSE_WAIT state of the file descriptor goes #
# after the connection idle time                              #
###############################################################
# Prerequisites  :
# Return Value on Success : 0
# Return Value on Failure : 1
# Result File : /home/nmsadm/eam/results
#
# Usage :  bash RUNME -t AXM_FT_EAM_IDL_InitiatorKill_ONE_NODE_BSCW.pl.
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
open(RFH,">/home/nmsadm/AXM_FT_EAM_IDL_InitiatorKill_ONE_NODE_BSCW.txt");

#FRAME::start_frame "$TC";
#========================================================================

if( -f "/opt/ericsson/nms_eam_test/bin/idl_script.sh")
{

$path = "/opt/ericsson/nms_eam_test/bin/";

chdir($path) or die "cant open $path $!";
system("/opt/ericsson/nms_eam_test/bin/idl_script.sh -ne $ntwrk_element -f /home/nmsadm/eam/bin/INPUT/cmd.txt &");
sleep(10);

#$pid = `ps -eaf | grep "/opt/borland/bes/bin/vbj"| grep -v grep| awk '{print \$2}'`;
#print "\n child id:$pid\n";

$ipid = `/bin/ps -eaf | /bin/grep ehip_ac_in | /bin/grep -v /bin/grep | /bin/awk '{print \$2}'`;
chomp($ipid);
print "Initiator id : $ipid\n";
`/bin/kill -9 $ipid`;

my $PID_IDL= `/bin/ps -eaf | /bin/grep eac_eai_idl_server | /bin/grep -v /bin/grep | /bin/awk '{print \$2}'`;
chomp($PID_IDL);
system("/usr/local/bin/lsof -p $PID_IDL > /tmp/lsof.txt");
print "IDL_SERVER :$PID_IDL";
sleep(20);
$search = `/bin/cat /tmp/lsof.txt | /bin/tail -3 | /bin/grep -i CLOSE_WAIT`;

if ($search)

{
	print RFH "FAIL : Failed, CLOSE_WAIT still exists\n";
#	Te::tex "$TC", "\n\nERROR  : Failed, CLOSE_WAIT still exists\n";

}
else
{
	print RFH "PASS : successfully cleared\n";
	#Te::tex "$TC", "\n\nINFO  :  successfully cleared\n";
}
#`kill -9 $pid`;
#print"DNS id :$pid";
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

$path = "/opt/ericsson/nms_eam_test/bin/";

chdir($path) or die "cant open $path $!";
system("/opt/ericsson/nms_eam_test/bin/idl_script.sh -ne $ntwrk_element -f home/nmsadm/eam/bin/INPUT/cmd.txt &");
sleep(10);

$pid = `/bin/ps -eaf | /bin/grep "/opt/borland/bes/bin/vbj"| /bin/grep -v /bin/grep| /bin/awk '{print \$2}'`;
print "\n child id:$pid\n";

$ipid = `/bin/ps -eaf | /bin/grep ehip_ac_in | /bin/grep -v /bin/grep | /bin/awk '{print \$2}'`;
chomp($ipid);
print "Initiator id : $ipid\n";
`/bin/kill -9 $ipid`;

my $PID_IDL= `/bin/ps -eaf | /bin/grep eac_eai_idl_server | /bin/grep -v /bin/grep | /bin/awk '{print \$2}'`;
chomp($PID_IDL);
system("/usr/local/bin/lsof -p $PID_IDL > /tmp/lsof.txt");
print "IDL_SERVER :$PID_IDL";

$search = `/bin/cat /tmp/lsof.txt | /bin/grep -i CLOSE_WAIT`;

if ($search)

{
		print RFH "FAIL : Failed, CLOSE_WAIT still exists\n";
      #  Te::tex "$TC", "\n\nERROR  : Failed, CLOSE_WAIT still exists\n";

}
else
{
		print RFH "PASS : successfully cleared\n";
     #   Te::tex "$TC", "\n\nINFO  :  successfully cleared\n";
}
#`kill -9 $pid`;
#print "Dns id : $pid";
}
#=======================================================================
#FRAME::end_frame "$TC";
close(RFH);
system("/bin/grep/ FAIL /home/nmsadm/AXM_FT_EAM_IDL_InitiatorKill_ONE_NODE_BSCW.txt");
if ($? == 0)
{
print  "\nFAIL\n";
}
else
{
print "\nPASS\n";
#unlink("/home/nmsadm/naveen/AXM_FT_EAM_IDL_InitiatorKill_ONE_NODE_BSCW.txt");
}
