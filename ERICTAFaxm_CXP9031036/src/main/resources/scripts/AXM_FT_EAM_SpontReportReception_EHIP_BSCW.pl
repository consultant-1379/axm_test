#!/use/bin/perl
#
# SCRIPT NAME:AXM_FT_EAM_SpontReportReception_EHIP_BSCW.pl
# Test Case Name: AXM_FT_EAM_SpontReportReception_EHIP_T, AXM_FT_EAM_SpontReportReception_EHIP_S (HANDLER) (PR 2)
# Test Case No : 5.3.34, 5.4.27
# Test Case No :
# AUTHOR:
# DATE  :
# REV:
#
################################ Description ################################
# This test verifies that it is possible to receive Spontaneous report by   #
# EAM correctly.                                                            # 
#############################################################################
# Prerequisites  :
# Return Value on Success : 0
# Return Value on Failure : 1
# Result File : /home/nmsadm/eam/results
#
# Usage :  bash RUNME -t AXM_FT_EAM_SpontReportReception_EHIP_BSCW.pl:<BSCW nodes>
#
# Dependency : Te.pm, crdmp.sh, PMSEerrorchk.sh
#
# REV HISTORY
# DATE:                           BY                                 MODIFICATION:
#
##########################################################
system('clear');

# DEFINE FILES AND VARIABLES HERE

use Expect;


$ntwrk_element=$ARGV[0];#ENV{ntwrk_element};


#FRAME::start_frame "$TC";
#========================================================================
open(RFH,">AXM_FT_EAM_SpontReportReception_EHIP_BSCW.txt");
print "Starting the Execution of test case\n";

my $protocol=`/opt/ericsson/bin/eac_esi_config -ne $ntwrk_element | grep cr_protocol | cut -d "=" -f2`;
chomp($protocol);

if ($protocol =~ /SSH_*/)
{
	print RFH "PASS : Protocol is SSH";
	print RFH "PASS : Test Case is running against $ntwrk_element with SSH Protocol $protocol";
	#Te::tex "$TC", "INFO  : Protocol is SSH";
	#Te::tex "$TC", "INFO  : Test Case is running against $ntwrk_element with SSH Protocol $protocol";
}
else
{
	print RFH "PASS : Protocol is TELNET";
	print RFH "PASS : Test Case is running against $ntwrk_element with TELNET Protocol $protocol";
#	Te::tex "$TC", "INFO  : Protocol is TELNET";
	#Te::tex "$TC", "INFO  : Test Case is running against $ntwrk_element with TELNET Protocol $protocol";
}




        chomp($ntwrk_element);
		print "Sending command for $ntwrk_element\n";    
        my $expect = Expect->new;
        my $command = "/opt/ericsson/bin/eaw $ntwrk_element";
        $expect->spawn($command) or die "Cannot spawn : $!\n";
        $expect->log_file("/home/nmsadm/eam/tmp/tryexpect.log","w");
        $expect->expect(5,'<');
        $expect->send("ALHBI;\r");
$expect->expect(5,'<');
        $expect->send(";\r");
$expect->expect(5,'EXECUTED');
		$expect->expect(5,'<');
		$expect->send("\cD");
		sleep(10);
		$expect->send("\r");
		$expect->expect(5,'<');
		check_output($ntwrk_element);
		$expect->log_file("/home/nmsadm/eam/tmp/tryexpect.log","w");
		$expect->send("ALHBE;\r");
$expect->expect(5,'<');
        $expect->send(";\r");
$expect->expect(5,'EXECUTED');
	    $expect->expect(5,'<');
		$expect->send("\cD");
		sleep(10);
		$expect->send("\r");
		$expect->expect(5,'<');
		check_output($ntwrk_element);
		$expect->send("exit;\r");
		$expect->soft_close();
#=======================================================================
#FRAME::end_frame "$TC";


sub check_output
{
        my $node = shift;
	
		chomp($node);
		
        open (FH, "</home/nmsadm/eam/tmp/tryexpect.log") or die $!;

        my @file_output=<FH>;
		#print "@file_output\n"; 
		
			if ( grep(/EXECUTED/,@file_output) && grep(/RECONN EXECUTED/,@file_output) &&  grep(/</,@file_output))
			{
				print RFH "PASS : Received proper response for the command ALBHI/ALBHE from $node";
              #  Te::tex "$TC", "INFO  : Received proper response for the command ALBHI/ALBHE from $node";
              
			}
			else
			{
				print RFH "FAIL : Response recieved is not proper from $node";
              #  Te::tex "$TC", "ERROR  : Response recieved is not proper from $node";
              
			}
		
		
}

close(RFH);
system("/bin/cat AXM_FT_EAM_SpontReportReception_EHIP_BSCW.txt | /bin/grep FAIL ");
if ($? == 0)
{
print  "\nFAIL\n";
}
else
{
print "\nPASS\n";
}

