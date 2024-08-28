#!/use/bin/perl
#
# SCRIPT NAME:AXM_FT_EAM_NotAcceptedResponse_EHIP_T.pl
# Test Case & Priority: AXM_FT_EAM_NotAcceptedResponse_EHIP_T (Pr.2)
# Test Case No :5.3.23
# AUTHOR:
# DATE  :
# REV:
#
############################# Description ##############################
# This verifies the Not accepted response for the special response.    #
########################################################################
# Prerequisites  :
# Return Value on Success : 0
# Return Value on Failure : 1
# Result File : /home/nmsadm/eam/results
#
# Usage :  bash RUNME -t AXM_FT_EAM_NotAcceptedResponse_EHIP_T.pl.
#
# Dependency : Te.pm, crdmp.sh, PMSEerrorchk.sh
#
# REV HISTORY
# DATE:                           BY                                 MODIFICATION:
#
##########################################################

# DEFINE FILES AND VARIABLES HERE

use Expect;

#$ENV{tc} = AXM_FT_EAM_NotAcceptedResponse_EHIP_T;
$ntwrk_element=$ARGV[0];#ENV{ntwrk_element};

#FRAME::start_frame "$TC";
#========================================================================
open(RFH,">AXM_FT_EAM_NotAcceptedResponse_EHIP_T.txt");
print "Starting the test Execution\n";
my $res = 0;


open (FH, ">>/etc/opt/ericsson/nms_eam_ehip/EHIP_command") or die $!;
print FH "CCNOTACC \@imresp=2\n";
close(FH);

$cmd = `/opt/ericsson/nms_cif_sm/bin/smtool -warmrestart eam_handlerIp -reason="other" -reasontext=" "`;
system("$cmd");
sleep(50);
my $MC_status = `/opt/ericsson/nms_cif_sm/bin/smtool -l eam_handlerIp`;
if ( $MC_status =~ /started/ || $MC_status =~ /^\s*$/ ) 
{
	print RFh "PASS : Command execution PASSED:EAM MC eam_handlerIp is restarted successfully\n";
#    Te::tex "$TC","INFO  :Command execution PASSED:EAM MC eam_handlerIp is restarted successfully\n";
	
}
else
{
	print RFH "FAIL : Command execution failed";
#	Te::tex "$TC","ERROR  : Command execution failed";
}

	print "Sending command for $ntwrk_element\n";    
        my $expect = Expect->new;
        my $command = "/opt/ericsson/bin/eaw $ntwrk_element";
        $expect->spawn($command) or die "Cannot spawn : $!\n";
        $expect->log_file("/home/nmsadm/eam/tmp/tryexpect.log","w");
        $expect->expect(160,'<');
        $expect->send("CCNOTACC;\r");
        $expect->expect(160,'<');
	    $expect->send("exit;\r");
		$expect->soft_close();
        print "\n";
        print "Checking whether output of node is received\n";
        $res = check_output($ntwrk_element);
        #print "$res\n";
		if (res == 0)
		{
			print RFH "PASS : Command CCNOTACC successfully executed on $ntwrk_element";
			#   Te::tex "$TC", "INFO  : Command CCNOTACC successfully executed on $ntwrk_element";
		}
		else
		{
			print RFH "FAIL : Command CCNOTACC execution unsuccessful on $ntwrk_element";
		#	   Te::tex "$TC", "ERROR  : Command CCNOTACC execution unsuccessful on $ntwrk_element";
        }
#	}
	
#=======================================================================
#FRAME::end_frame "$TC";

sub check_output
{
        my $node = shift;
       $node = chmod $node; 
	open (FH, "</home/nmsadm/eam/tmp/tryexpect.log") or die $!;

        my @file_output=<FH>;
		#print "@file_output\n";        
        if (grep(/NOT ACCEPTED/,@file_output))
        {
	print RFH "PASS : Received proper response for the command from $node";
             #   Te::tex "$TC", "INFO  : Received proper response for the command from $node";
                return 0;
        }
        else
        {
	print RFH "FAIL : Response recieved is not proper from $node";
#                Te::tex "$TC", "ERROR  : Response recieved is not proper from $node";
                return 1;
        }
}
close(RFH);

system("/bin/cat AXM_FT_EAM_NotAcceptedResponse_EHIP_T.txt | /bin/grep FAIL ");
if ($? == 0)
{
print  "\nFAIL\n";
}
else
{
print "\nPASS\n";
}
