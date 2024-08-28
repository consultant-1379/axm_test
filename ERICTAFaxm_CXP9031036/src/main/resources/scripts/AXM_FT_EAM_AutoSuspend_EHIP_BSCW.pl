#!/usr/bin/perl
#
# SCRIPT NAME:AXM_FT_EAM_AutoSuspend_EHIP_BSCW.pl
# Test Case & Priority: AXM_FT_EAM_AutoSuspend_EHIP_T,AXM_FT_EAM_AutoSuspend_EHIP_S 
# Test Case No : 5.3.27, 5.4.24 (Handler)
# AUTHOR:xraoshr
# DATE  :
# REV:
#
################################ Description ######################
#This test case tests the auto suspend function. If autosuspend is set to "ON", 
#the delayed response arrives without suspension. If set to "OFF", specify "EOT" 
#and then "w" in order to get the delayed response.
###################################################################
# Prerequisites  :
# Return Value on Success : 0
# Return Value on Failure : 1
# Result File : /home/nmsadm/eam/results
#
# Usage :  bash RUNME -t AXM_FT_EAM_AutoSuspend_EHIP_BSCW.pl:<BSCW node>
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
open(RFH,">AXM_FT_EAM_AutoSuspend_EHIP_BSCW.txt");
print "Starting of Test Execution\n";

my $protocol=`/opt/ericsson/bin/eac_esi_config -ne $ntwrk_element | /bin/grep cr_protocol | /bin/cut -d "=" -f2`;#
#$protocol = chomp $protocol;

if ($protocol =~ /SSH_*/)
{
	print RFH "PASS : Protocol is SSH\n";
	print RFH "PASS : Test Case is running against $ntwrk_element with SSH Protocol $protocol";
}
else
{
	print RFH "PASS : Protocol is TELNET\n";
	print RFH "PASS : t Case is running against $ntwrk_element with TELNET Protocol $protocol\n";
}


print "Sending commands for $ntwrk_element\n";    
my $expect = Expect->new;
my $command = "/opt/ericsson/bin/eaw $ntwrk_element";
$expect->spawn($command) or die "Cannot spawn : $!\n";
$expect->log_file("tryexpect.log","w");
$expect->expect(5,'<');
$expect->send("autosusp;\r");
$expect->expect(5,'<');
check_output($ntwrk_element,"autosusp");
$expect->log_file("tryexpect.log","w");
$expect->send("syrip;\r");
$expect->expect(5,'<');
check_output($ntwrk_element,"syrip"); 
$expect->log_file("tryexpect.log","w"); 
$expect->send("autosusp;\r");
$expect->expect(5,'<');
check_output($ntwrk_element,"autosusp");
$expect->log_file("tryexpect.log","w");
$expect->send("syrip;\r");
$expect->expect(5,'<');
$expect->send("\cD");
$expect->expect(5,'<');
$expect->send("exit;\r");
check_output($ntwrk_element,"syrip");  		
$expect->soft_close();
           

#=======================================================================

sub check_output
{
        my $node = shift;
        my $cmd = shift;
		#$node = chomp $node;
       # $cmd = chomp $cmd;       
        open (FH, "<tryexpect.log") or die $!;
		my @file_output=<FH>;
        if ( $cmd  eq "autosusp" )
		{
			if(grep(/EXECUTED/,@file_output) && (grep(/AUTO SUSPEND SET TO ON/,@file_output) || grep(/AUTO SUSPEND SET TO OFF/,@file_output)))
            {
				print RFH "PASS : Autosuspend function working as Expected for $node\n";
              
            }
            else
            {
				print RFH "FAIL : Autosuspend function ain't working as expected for $node\n";
              
            }
		}
		elsif($cmd  eq "syrip")
		{
			if(grep(/ORDERED/,@file_output) && (grep(/SOFTWARE RECOVERY SURVEY/,@file_output) || grep(/EVENT TYPE          EXPLANATION                         EVENTCNT  FRDEL/,@file_output)))
            {
				print RFH "PASS : $cmd function working as Expected for $node\n";
              
            }
            else
            {
				print RFH "FAIL : $cmd function ain't working as expected for $node\n";

              
            }
		}
		close(FH);
}
close(RFH);

system("/bin/at AXM_FT_EAM_AutoSuspend_EHIP_BSCW.txt | /bin/grep FAIL ");
if ($? == 0)
{
print  "FAIL\n";
}
else
{
print "PASS\n";
}
