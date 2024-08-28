#!/usr/bin/perl
#
# SCRIPT NAME:5.3.15 & 5.4.15 AXM_FT_EAM_ImResp_RespType_EHIP_ST_REAL_NODE_BSCL.pl
# Test Case & Priority: 5.3.15  AXM_FT_EAM_ImResp_RespType_EHIP_ST_REAL_NODE(Pr.2)
# Test Case No :  5.3.15 & 5.4.15 (Handler)
# AUTHOR: XJITKUM
# DATE  : 19\12\2013
# REV: A
#
############################ Description ###############################
# This test case verifies that the returned response types are         #
# interpreted correctly.The "crtest" program is submitting an info     #
# printout in which the response type is stated.                       #
########################################################################
# Prerequisites  :
# Return Value on Success : 0
# Return Value on Failure : 1
# Result File : /home/nmsadm/eam/results
# Log File : /home/nmsadm/eam/tmp/alarm.log
# Usage :  bash RUNME -t AXM_FT_EAM_ImResp_RespType_EHIP_ST_REAL_NODE.pl.
#
# Dependency : Te.pm, crdmp.sh, PMSEerrorchk.sh
#
# REV HISTORY
# DATE:                           BY                                 MODIFICATION:
#
##########################################################

# DEFINE FILES AND VARIABLES HERE

use Expect;

$ntwrk_element=$ARGV[0];#ENV{ntwrk_element};


#======================================================================
open(RFH,">AXM_FT_EAM_ImResp_RespType_EHIP_ST_REAL_NODE.txt");
my $cr_protocol =
      `/opt/ericsson/bin/eac_esi_config -ne $ntwrk_element | /bin/grep "cr_protocol     = " | /bin/cut -d "=" -f2`;

#chomp($cr_protocol);
if (  $cr_protocol =~ 'TELNET\w+')
{
	print RFH "PASS : Node $ntwrk_element using TELNET|TELNET_MTS protocol";
#        Te::tex "$TC","INFO  : Node $ntwrk_element using TELNET|TELNET_MTS protocol";
        node_conn($ntwrk_element);

}
elsif (  $cr_protocol =~ 'SSH\w+')
{
	print RFH "PASS : Node $ntwrk_element using SSH|SSH_MSS protocol";
#        Te::tex "$TC","INFO  : Node $ntwrk_element using SSH|SSH_MSS protocol";
        node_conn($ntwrk_element);
}
else
{
	print RFH "FAIL :  Node $ntwrk_element is not using TELNET|TELNET_MTS|SSH|SSH_MSS protocol in EAC config file";
#        Te::tex "$TC", "ERROR  : Node $ntwrk_element is not using TELNET|TELNET_MTS|SSH|SSH_MSS protocol in EAC config file";
}

sub node_conn
{
                print "Connecting the node $node ...\n";

                my $node =      $_[0];
                $archFlag = 0;
                $archFlag = 1   if(`arch`=~ /sparc/);

                if ($archFlag == 1)
                {
                        print "Selecting sparc binary \n";
                        check_file_exist("/home/nmsadm/eam/crtest");
                        check_file_exist("/home/nmsadm/eam/crtest_env.sh");
                        $cmd = "/home/nmsadm/eam/crtest_env.sh -n $node";
                }
                else
                {
                        print "Selecting X86 binary \n";
                        check_file_exist("/home/nmsadm/eam/crtest");
                        check_file_exist("/home/nmsadm/eam/crtest_env.sh");
                        $cmd = "/home/nmsadm/eam/crtest_env.sh -n $node";
                }
                                my $expect = Expect->new;
                                $expect->log_file("/home/nmsadm/eam/tmp/delay_t.log","w+");
                                $expect->spawn($cmd) or die "Cannot spawn : $!\n";
                                $expect->expect(5,'<');
                                $expect->send("ALHBE;\r");
                                $expect->expect(5,'EXECUTED');
                                $expect->expect(20,'<');
                                $expect->send("CACLP;\r");
                                $expect->expect(10,'<');
                                $expect->send("labup;\r");
                                $expect->expect(10,'ORDERED');
                                $expect->expect(20,'<');
                                $expect->send("labup;\r");
                                $expect->expect(20,'<');
                                $expect->send("CACLP;\r");
                                $expect->expect(5,'<');
                                $expect->soft_close();
}

my $alhbe_str =`/bin/cat /home/nmsadm/eam/tmp/delay_t.log | /bin/grep "EXECUTED"| /bin/awk '{print \$1}'`;
print "alhbe_str == ",$alhbe_str;

my $alhbe_str1 = "EXECUTED";

if (`$alhbe_str` eq `$alhbe_str1`)
        {
	print RFH "PASS : ALHBE command Executed successfully.";
#                Te::tex "$TC", "\nINFO  : ALHBE command Executed successfully.";

        }
        else
        {
	print RFH "FAIL :  ALHBE command not Executed successfully.";
#                Te::tex "$TC", "\nERROR : ALHBE command not Executed successfully.";
        }


my $labup_str=`/bin/cat /home/nmsadm/eam/tmp/delay_t.log | /bin/grep "ORDERED"| /bin/awk '{print \$1}'`;

print "labup_str == ",$labup_str;

if (`$labup_str` eq `ORDERED`)
        {
	print RFH "PASS :  LABUP command Executed successfully.";
#                Te::tex "$TC", "\nINFO  : LABUP command Executed successfully.";

        }
        else
        {
	print RFH "FAIL : LABUP command not Executed successfully.";
#                Te::tex "$TC", "\nERROR : LABUP command not Executed successfully.";
        }

my $labup_nstr=`/bin/cat /home/nmsadm/eam/tmp/delay_t.log | /bin/grep "BUSY"| /bin/awk '{print \$2}'`;

print "labup_nstr== ",$labup_nstr;

if (`$labup_nstr` eq `BUSY`)
        {
	print RFH "PASS : Function busy for executing LABUP command second time Executed successfully.";
#                Te::tex "$TC", "\nINFO  : Function busy for executing LABUP command second time Executed successfully.";

        }
        else
        {
	print RFH "FAIL : LABUP command not Executed successfully.";
#                Te::tex "$TC", "\nERROR : LABUP command not Executed successfully.";
        }
my $caclp_str=`/bin/cat /home/nmsadm/eam/tmp/delay_t.log | /bin/grep "CLOCKS"| /bin/awk '{print \$2}'`;

print "caclp_str== ",$caclp_str;

if (`$lcaclp_str` eq `CLOCKS`)
        {
	print RFH "PASS :  CACLP command Executed successfully.";
#                Te::tex "$TC", "\nINFO  : CACLP command Executed successfully.";

        }
        else
        {	
	print RFH "FAIL : CACLP command not Executed successfully.";
#                Te::tex "$TC", "\nERROR : CACLP command not Executed successfully.";
        }

#Method for Checking the file Exist or Not...
sub check_file_exist
{
        my $file = $_[0];;

        if ( -e "$file" )       {
	print RFH "PASS : INFO  : Required $file has been found.";
#	               Te::tex "$TC", "INFO  : Required $file has been found.";
        }
        else    {
	print RFH "FAIL : Couldn't find $file the file to process.";
#                 Te::tex "$TC", "Error : Couldn't find $file the file to process.";
        }
}
close(RFH);

system("/bin/cat AXM_FT_EAM_ImResp_RespType_EHIP_ST_REAL_NODE.txt | /bin/grep FAIL ");
if ($? == 0)
{
print  "\nFAIL\n";
}
else
{
print "\nPASS\n";
}
#=======================================================================
#FRAME::end_frame "$TC";

