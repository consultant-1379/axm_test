#!/usr/bin/perl
#
# SCRIPT NAME:AXM_FT_EAM_APG43_Exchange_Header_Parameter_Mode_MSCBCW.pl
# Test Case & Priority: AXM_FT_EAM_APG43_Exchange_Header_Parameter (Pr.1)
# Test Case No :5.8.3 (handler)
# AUTHOR:xraoshr
# DATE  :
# REV:
#
################################ Description ######################
#This test case checks the connectivity with exchange header after adding APG43 with MSS-BC configuration.
###################################################################
# Prerequisites  :
# Return Value on Success : 0
# Return Value on Failure : 1
# Result File : /home/nmsadm/eam/logs
#
# Usage :  bash RUNME -t AXM_FT_EAM_APG43_Exchange_Header_Parameter_Mode_MSCBCW.pl:<node name>.
#
# Dependency : Te.pm, crdmp.sh, PMSEerrorchk.sh
#
# REV HISTORY
# DATE:     25022014                      BY       XROHAGR                    MODIFICATION:
#
##########################################################

# DEFINE FILES AND VARIABLES HERE
use Expect;

$ntwrk_element=$ARGV[0];#$ENV{ntwrk_element};

#========================================================================

open(RFH,"AXM_FT_EAM_APG43_Exchange_Header_Parameter_Mode_MSCBCW.txt");
print "Starting the execution of test\n";
# Added By XROHAGR
    my $user_id = 
      `/opt/ericsson/bin/eac_esi_config -ne $ntwrk_element | /bin/grep "user_id         = " | /bin/cut -d "=" -f2`;	
	$user_id =chomp $user_id;
	
	my $cr_daemon =
      `/opt/ericsson/bin/eac_esi_config -ne $ntwrk_element | /bin/grep "cr_daemon       =" | /bin/cut -d "=" -f2`;
	$cr_daemon =chomp $cr_daemon;
	
	
	if ( "$cr_daemon" eq "ehms_ac_in" && "$user_id" eq "netsim")	{
	
		print RFH "PASS : node $ntwrk_element having cr_daemon value as $cr_daemon and user_id value as netsim. This TC should be execute with
real node only";
	}


	print "Sending command for $ntwrk_element\n";    
        
	my $expect = Expect->new;
        my $command = "/opt/ericsson/bin/eaw NE=$ntwrk_element,EXPERT=1";
        $expect->spawn($command) or die "Cannot spawn : $!\n";
        $expect->log_file("/home/nmsadm/eam/tmp/tryexpect.log","w");
        $expect->expect(5,'<');
        $expect->send("exchhdron\r");
		$expect->expect(5,'<');
		check_output($ntwrk_element,"exchhdron");
		$expect->send("exchhdroff\r");
		$expect->expect(5,'<');
		check_output($ntwrk_element,"exchhdroff");
		$expect->send("EXIT;\r");
        $expect->soft_close();
		


#=======================================================================

sub check_output
{
        my $node = shift;
		my $cmd = shift;
		$node = chomp $node;
		$cmd = chomp $cmd;
        open (FH, "</home/nmsadm/eam/tmp/tryexpect.log") or die $!;

        my @file_output=<FH>;
		#print "@file_output\n"; 
		if ($cmd eq 'exchhdron')
		{
		
			if ( grep(/EXCHANGE HEADERS ON/,@file_output))			
			{
				print RFH "PASS : Received proper response for the $cmd command from $node\n";
              
			}
			else
			{
				print RFH "FAIL : Response recieved is not proper for $cmd from $node\n";
              
			}
		}
		elsif ($cmd eq 'exchhdroff')
		{
			if ( grep(/EXCHANGE HEADERS OFF/,@file_output))
			{
			print RFH "PASS : Received proper response for $cmd command from $node";	
			}
			else
			{
				print RFH "FAIL : Response recieved is not proper for $cmd from $node\n"; 
              
			}
		}
		close(FH);
}
close(RFH);

system("/bin/cat AXM_FT_EAM_APG43_Exchange_Header_Parameter_Mode_MSCBCW.txt | /bin/grep FAIL ");
if ($? == 0)
{
print  "FAIL\n";
}
else
{
print "PASS\n";
unlink("AXM_FT_EAM_APG43_Exchange_Header_Parameter_Mode_MSCBCW.txt");
}
