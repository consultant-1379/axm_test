#!/usr/bin/perl
#
# SCRIPT NAME:AXM_FT_EAM_ConnectIdleTimeout_EHIP_BSCW.pl
# Test Case & Priority: AXM_FT_EAM_ConnectIdleTimeout_EHIP_T, AXM_FT_EAM_ConnectIdleTimeout_EHIP_S
# Test Case No :5.3.2, 5.4.3(Handler) 
# AUTHOR:xraoshr
# DATE  :
# REV:
#
################################ Description ######################
#This test case checks that it is possible to modify the connection idle time out by -set conn_idle_to command
###################################################################
# Prerequisites  :
# Return Value on Success : 0
# Return Value on Failure : 1
# Result File : /home/nmsadm/eam/logs
#
# Usage :  bash RUNME -t AXM_FT_EAM_ConnectIdleTimeout_EHIP_BSCW.pl:<BSCW node>
#
# Dependency : Te.pm, crdmp.sh, PMSEerrorchk.sh
#
# REV HISTORY
# DATE:                           BY                                 MODIFICATION:
#
##########################################################

# DEFINE FILES AND VARIABLES HERE
use Expect;

$ntwrk_element=$ARGV[0];#$ENV{ntwrk_element};

#========================================================================

print "Starting of Test Execution\n";

open(RFH,">AXM_FT_EAM_ConnectIdleTimeout_EHIP_BSCW.txt");
my $protocol=`/opt/ericsson/bin/eac_esi_config -ne $ntwrk_element | /bin/grep cr_protocol | /bin/cut -d "=" -f2`;
chomp($protocol);

if ($protocol =~ /SSH_*/)
{
	print "PASS : Protocol is SSH";
	print "PASS : Test Case is running against $ntwrk_element with SSH Protocol $protocol";
}
else
{
	print "PASS : Protocol is TELNET";
	print "PASS : Test Case is running against $ntwrk_element with TELNET Protocol $protocol";
}
my $con_get = `/opt/ericsson/bin/eac_esi_config -ne $ntwrk_element -get conn_idle_to |/bin/grep conn_idle_to |/bin/cut -d "=" -f2`;

system("/opt/ericsson/bin/eac_esi_config -ne $ntwrk_element -set conn_idle_to 10");
sleep(10);
my $con_get_new = `/opt/ericsson/bin/eac_esi_config -ne $ntwrk_element -get conn_idle_to |/bin/grep conn_idle_to |/bin/cut -d "=" -f2`;

chomp($con_get);
chomp($con_set_new);
chomp($con_get_new);

if($con_get_new == "10")
{
	print RFH "PASS : Timeout set to 10 secs for $ntwrk_element\n";
}
else
{
	print RFH "FAIL : Error in setting the time out value for $ntwrk_element";
}

 my $expect = Expect->new;
 my $command = "eaw $ntwrk_element";
 $expect->spawn($command) or die "Cannot spawn : $!\n";
 $expect->log_file("/home/nmsadm/tryexpect.log","w");
 $expect->expect(5,'<');
 sleep(15);
 $expect->send("\r");
 $expect->expect(10,'<');
 $expect->send("EXIT;\r");
 $expect->soft_close();
 check_output($ntwrk_element);

 print "Reverting the time out value to original value\n";
 system("/opt/ericsson/bin/eac_esi_config -ne $ntwrk_element -set conn_idle_to $con_get");
 my $con_get_orig = `/opt/ericsson/bin/eac_esi_config -ne $ntwrk_element -get conn_idle_to |/bin/grep conn_idle_to |/bin/cut -d "=" -f2`;
 chomp($con_get_orig);

if($con_get_orig eq $con_get)
{
	print RFH "PASS : Timeout set to $con_get for $ntwrk_element";
}
else
{
	print RFH "FAIL : Error in setting original time out value for $ntwrk_element";
}
#=======================================================================

sub check_output
{
        my $node = shift;
	    chomp($node);
		open (FH, "</home/nmsadm/tryexpect.log") or die $!;
		my @file_output=<FH>;
		if ( grep(/Time out/,@file_output)|| grep(/TIME OUT/,@file_output))
		{
			print "PASS : Received time out after 5 secs from $node\n";
              
		}
		else
		{
			print "FAIL : Proper time out not received after 5 secs from $node\n";
        }
		close(FH);
		
}

close(RFH);

system("/bin/cat AXM_FT_EAM_ConnectIdleTimeout_EHIP_BSCW.txt | /bin/grep FAIL ");
if ($? == 0)
{
print  "\nFAIL\n";
}
else
{
print "\nPASS\n";
}
