#!/usr/bin/perl
#
# SCRIPT NAME:AXM_FT_EAM_ReceptionOfDelResp_EHIP_BSCW.pl
# Test Case No : 5.3.25, 5.4.22 (Handler)
# AUTHOR: XROHAGR
# DATE  : 20-01-2014
# REV: A
############################### Description #####################################
#This test case verifies reception of delayed response for the command "labup;" #
#################################################################################
#
# Prerequisites  :
# Return Value on Success : 0
# Return Value on Failure : 1
# Result File : /home/nmsadm/eam/logs
#
# Usage :  bash RUNME -t AXM_FT_EAM_ReceptionOfDelResp_EHIP_BSCW.pl:<node name>
#
# Dependency :
#
# REV HISTORY
# DATE:
# BY
# MODIFICATION:
#
##########################################################
# DEFINE FILES AND VARIABLES HERE
use Expect;

$ntwrk_element=$ARGV[0];#ENV{ntwrk_element};

#FRAME::start_frame "$TC";
#========================================================================
open(RFH,">AXM_FT_EAM_ReceptionOfDelResp_EHIP_BSCW.txt");
sub check_output_delayCommand
{
	    my $node = shift;
        my $cmd = shift;
        $node = chomp $node;
        $cmd = chomp $cmd;
        open (FH, "</home/nmsadm/AXM_FT_EAM_ReceptionOfDelResp_EHIP_BSCW.log") or die $!;

        my @file_output=<FH>;
		
		close(FH);
		
        if (grep(/ORDERED/,@file_output) && grep(/END/,@file_output) && grep(/</,@file_output))
        {
			print RFH "PASS : Received proper delay response for the command $cmd from $node";
          #  Te::tex "$TC", "INFO  : Received proper delay response for the command $cmd from $node";
        }
	else
	{
		print RFH "FAIL  : Recieved delay response is not proper for the command $cmd from $node";
#::tex "$TC", "ERROR  : Recieved delay response is not proper for the command $cmd from $node";
        }
		
	print "Log file of output has been generated at path $TMP/AXM_FT_EAM_ReceptionOfDelResp_EHIP_BSCW.log \n";
}

print "Starting the Execution of test case\n";

my $cr_protocol = `/opt/ericsson/bin/eac_esi_config -ne $ntwrk_element | /bin/grep cr_protocol | /bin/cut -d "=" -f2 |/bin/sed -e 's/^[ \t]*//'`;

if ($cr_protocol =~ 'SSH*')
{
	print "Protocol is SSH type \n";
	print RFH "PASS : Test Case is running against node $ntwrk_element with SSH protocol $cr_protocol";
	#Te::tex "$TC","INFO  : Test Case is running against node $ntwrk_element with SSH protocol $cr_protocol";
}
elsif ($cr_protocol =~ 'TELNET*')
{
	print "Protocol is TELNET type \n";
	print RFH "PASS : Test Case is running against node $ntwrk_element with TELNET protocol $cr_protocol";
	#Te::tex "$TC","INFO  : Test Case is running against node $ntwrk_element with TELNET protocol $cr_protocol";
}
else
{
	print "Protocol is neither TELNET nor SSH \n";
	print RFH "FAIL : Test Case is running against node $ntwrk_element with protocol $cr_protocol that is neither TELNET nor SSH";
	#Te::tex "$TC","ERROR  : Test Case is running against node $ntwrk_element with protocol $cr_protocol that is neither TELNET nor SSH";
}

print "Establishing connection for node $ntwrk_element\n"; 

my $expect = Expect->new;
$expect->log_file("/home/nmsadm/AXM_FT_EAM_ReceptionOfDelResp_EHIP_BSCW.log","w+");

my $command = "/opt/ericsson/bin/eaw $ntwrk_element";
$expect->spawn($command) or die "Cannot spawn : $!\n";
$expect->expect(5,'<');

$expect->send("labup;\r");
$expect->expect(5,'ORDERED');
$expect->expect(5,'<');
$expect->send("\cD");
sleep(20);
$expect->send("\r");
$expect->expect(5,'<');
$expect->send("exit;\r");
$expect->soft_close();

check_output_delayCommand($ntwrk_element,"labup");
close(RFH);
system("/bin/cat AXM_FT_EAM_ReceptionOfDelResp_EHIP_BSCW.txt | /bin/grep FAIL ");
if ($? == 0)
{
print  "\nFAIL\n";
}
else
{
print "\nPASS\n";
#unlink("AXM_FT_EAM_ReceptionOfDelResp_EHIP_BSCW.txt");
}
#=============================================================================================

