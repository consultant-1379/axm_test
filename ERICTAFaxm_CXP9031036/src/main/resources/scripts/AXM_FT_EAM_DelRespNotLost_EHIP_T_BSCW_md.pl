#!/usr/bin/perl
#
# SCRIPT NAME:AXM_FT_EAM_DelRespNotLost_EHIP_T_BSCW.pl
# Test Case & Priority: AXM_FT_EAM_DelRespNotLost_EHIP_T (Pr.2) 
# Test Case No : 5.3.30(handler)
# AUTHOR:xraoshr
# DATE  :
# REV:
#
# Description :
# Prerequisites  :
# Return Value on Success : 0
# Return Value on Failure : 1
# Result File : /home/nmsadm/eam/results
#
# Usage :  bash RUNME -t AXM_FT_EAM_DelRespNotLost_EHIP_T_BSCW.pl:<BSCW node>
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

#========================================================================

open(RFH,">AXM_FT_EAM_DelRespNotLost_EHIP_T_BSCW.txt");
print "Starting of Test Execution\n";

my $protocol=`/opt/ericsson/bin/eac_esi_config -ne $ntwrk_element | /bin/grep cr_protocol | /bin/cut -d "=" -f2`;
chomp($protocol);

if ($protocol =~ /SSH_*/)
{
	print RFH "PASS : Protocol is SSH";
	print RFH "PASS : Test Case is running against $ntwrk_element with SSH Protocol $protocol";
}
else
{
	print RFH "PASS : Protocol is TELNET";
	print RFH "PASS : Test Case is running against $ntwrk_element with TELNET Protocol $protocol";
}

if ( -e "/home/nmsadm/eam/crtest_env.sh" )       
{
	print RFH "PASS : Required $file has been found.\n";
}
else   
{
	print RFH "FAIL : Couldn't find $file the file to process.\n";
}


my $con_get = `/opt/ericsson/bin/eac_esi_config -ne $ntwrk_element -get conn_idle_to |/bin/grep conn_idle_to |/bin/cut -d "=" -f2`;

system("/opt/ericsson/bin/eac_esi_config -ne $ntwrk_element -set conn_idle_to 10");

my $con_get_new = `/opt/ericsson/bin/eac_esi_config -ne $ntwrk_element -get conn_idle_to |/bin/grep conn_idle_to |/bin/cut -d "=" -f2`;

chomp($con_get);
chomp($con_set_new);
chomp($con_get_new);

if($con_get_new == "10")
{
	print RFH "PASS : Timeout set to 10 secs for $ntwrk_element";
}
else
{
	print RFH "FAIL : Error in setting the time out value for $ntwrk_element";
}
print "Sending commands for $ntwrk_element\n";    
my $expect = Expect->new;
my $command = "/home/nmsadm/eam/crtest_env.sh -n $ntwrk_element";
$expect->spawn($command) or die "Cannot spawn : $!\n";
$expect->log_file("/home/nmsadm/eam/tmp/tryexpect.log","w");
$expect->expect(5,'<');
$expect->send("syrip;\r");
$expect->expect(5,'<');
$expect->send("w 20\r");
$expect->expect(5,'<');
$expect->send("quit\r");
$expect->soft_close();
check_output($ntwrk_element,"syrip");           
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
	print RFH "PASS : Error in setting original time out value for $ntwrk_element";
}
#=======================================================================

sub check_output
{
        my $node = shift;
        my $cmd = shift;
        chomp($node);
        chomp($cmd);       
        open (FH, "</home/nmsadm/eam/tmp/tryexpect.log") or die $!;
        my @file_output=<FH>;
        
        if(grep(/ORDERED/,@file_output) && (grep(/SOFTWARE RECOVERY SURVEY/,@file_output) || grep(/EVENT TYPE          EXPLANATION                         EVENTCNT  FRDEL/,@file_output) || grep(/PROGRAM CODE/,@file_output)))
        {

		print RFH "PASS : $cmd function working as Expected for $node";
              
        }
        else
        {
print "das";
		print RFH "FAIL : $cmd function ain't working as expected for $node";
              
        }
             
        close(FH);
}



close(RFH);

system("/bin/cat AXM_FT_EAM_DelRespNotLost_EHIP_T_BSCW.txt | /bin/grep FAIL ");
if ($? == 0)
{
print  "\nFAIL\n";
}
else
{
print "\nPASS\n";
}



