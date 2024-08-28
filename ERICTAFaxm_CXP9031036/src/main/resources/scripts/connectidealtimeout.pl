#!/use/bin/perl
#!/usr/local/bin/expect
#
# SCRIPT NAME:AXM_FT_EAM_ConnectIdleTimeout_EHIP_BSCW.pl
# Test Case & Priority: AXM_FT_EAM_ConnectIdleTimeout_EHIP_T, AXM_FT_EAM_ConnectIdleTimeout_EHIP_S
# Test Case No :5.3.2, 5.4.3(Handler) 
# AUTHOR:xraoshr
# DATE  :
# REV:
#
# Description :
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


use Expect;

#==============================================
$ntwrk_element= $ARGV[0];
open(RFH,">>ConnectIdleTimeout_EHIP.txt");
print "Starting of Test Execution\n";

my $protocol=`/opt/ericsson/bin/eac_esi_config -ne $ntwrk_element | /bin/grep cr_protocol | cut -d "=" -f2`;
#$protocol = util::trim $protocol;
chomp($protocol);
if ($protocol =~ /SSH_*/)
{
        print "Protocol is SSH\n";
        print "Test Case is running against $ntwrk_element with SSH Protocol $protocol\n";
	#Te::tex "$TC", "INFO  : Protocol is SSH";
	#Te::tex "$TC", "INFO  : Test Case is running against $ntwrk_element with SSH Protocol $protocol";
}
else
{
        print "Protocol is TELNET\n";
        print "Test Case is running against $ntwrk_element with TELNET Protocol $protocol\n";
	#Te::tex "$TC", "INFO  : Protocol is TELNET";
	#Te::tex "$TC", "INFO  : Test Case is running against $ntwrk_element with TELNET Protocol $protocol";
}
my $con_get = `/opt/ericsson/bin/eac_esi_config -ne $ntwrk_element -get conn_idle_to |/bin/grep conn_idle_to |cut -d "=" -f2`;

system("/opt/ericsson/bin/eac_esi_config -ne $ntwrk_element -set conn_idle_to 10");
sleep(10);
my $con_get_new = `/opt/ericsson/bin/eac_esi_config -ne $ntwrk_element -get conn_idle_to |/bin/grep conn_idle_to |cut -d "=" -f2`;

chomp($con_get);
chomp($con_set_new);
chomp($con_get_new);

#$con_get  = util::trim $con_get;
#$con_set_new  = util::trim $con_set_new;
#$con_get_new  = util::trim $con_get_new;

if($con_get_new == "10")
{
	#Te::tex "$TC", "INFO  : Timeout set to 10 secs for $ntwrk_element";
 print RFH "PASS: Timeout set to 10 secs for $ntwrk_element\n";
}
else
{
print RFH "FAIL: Error in setting the time out value for $ntwrk_element\n";
	#Te::tex "$TC", "ERROR  : Error in setting the time out value for $ntwrk_element";
	#FRAME::end_frame "$TC";
}

 my $expect = Expect->new;
 my $command = "eaw $ntwrk_element";
 $expect->spawn($command) or die "Cannot spawn : $!\n";
 $expect->log_file("tryexpect.log","w+");
 $expect->expect(5,'<');
 sleep(15);
 $expect->send("\r");
 $expect->expect(10,'<');
 $expect->send("EXIT;\r");
 $expect->soft_close();
 check_output($ntwrk_element);

 print "Reverting the time out value to original value\n";
 system("/opt/ericsson/bin/eac_esi_config -ne $ntwrk_element -set conn_idle_to $con_get");
 my $con_get_orig = `/opt/ericsson/bin/eac_esi_config -ne $ntwrk_element -get conn_idle_to |/bin/grep conn_idle_to |cut -d "=" -f2`;
 chomp($con_get_orig);
 #$con_get_orig = util::trim $con_get_orig;

if($con_get_orig eq $con_get)
{
print RFH "PASS:Timeout set to $con_get for $ntwrk_element\n";
	#Te::tex "$TC", "INFO  : Timeout set to $con_get for $ntwrk_element";
}
else
{
print RFH "FAIL: Error in setting original time out value for $ntwrk_element\n";
#	Te::tex "$TC", "ERROR  : Error in setting original time out value for $ntwrk_element";
}
#=======================================================================



sub check_output
{
        my $node = shift;
	    #$node = util::trim $node;
chomp($node);
		open (FH, ">tryexpect.log") or die $!;
		my @file_output=<FH>;
		if ( grep(/Time out/,@file_output)|| grep(/TIME OUT/,@file_output))
		{
		#	Te::tex "$TC", "INFO  : Received time out after 5 secs from $node";
                  print RFH "PASS: Received time out after 5 secs from $node\n";
              
		}
		else
		{
                 print RFH "FAIL: Proper time out not received after 5 secs from $node\n";
		#	Te::tex "$TC", "ERROR  : Proper time out not received after 5 secs from $node";
        }
		close(FH);
close(RFH);
		
}
system("/bin/cat ConnectIdleTimeout_EHIP.txt|/bin/grep FAIL");
if($? == 0)
{
print "FAIL\n";
#system("rm tryexpect.log");
}
else
{
print "PASS\n";
system("rm tryexpect.log");
}


