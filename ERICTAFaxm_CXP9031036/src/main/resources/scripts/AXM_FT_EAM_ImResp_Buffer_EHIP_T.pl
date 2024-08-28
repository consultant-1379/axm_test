#!/use/bin/perl
#
# SCRIPT NAME:AXM_FT_EAM_ImResp_Buffer_EHIP_T.pl
# Test Case & Priority: AXM_FT_EAM_ImResp_Buffer_EHIP_T (Pr.1)
# Test Case No :
# AUTHOR:
# DATE  :
# REV:
#
############################### Description ###################
# This test case verifies reception of immediate and delayed  #
# responses entirely or buffer by buffer.                     #
###############################################################
# Prerequisites  :
# Return Value on Success : 0
# Return Value on Failure : 1
# Result File : /home/nmsadm/eam/results
#
# Usage :  bash RUNME -t AXM_FT_EAM_ImResp_Buffer_EHIP_T.pl:<node1>:<node2>.
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
open(RFH,">AXM_FT_EAM_ImResp_Buffer_EHIP_T.txt");
print "Starting the Execution of test case\n";
my $res = 0;
#my @nodes_from_xml =
`/bin/grep 'ManagedElementId string='  /home/nmsadm/eam/bin/INPUT/MSC_Modify_IOG_APG.xml|/bin/cut -d '"' -f2`;


#foreach $node (@nodes_from_xml) {
#        $node = util::trim $node;
                print "Sending command for $ntwrk_element\n";
        my $expect = Expect->new;
        my $command = "/opt/ericsson/bin/eaw $ntwrk_element";
         $expect->spawn($command) or die "Cannot spawn : $!\n";
        $expect->log_file("/home/nmsadm/eam/tmp/tryexpect.log","w");
        $expect->expect(5,'<');
        $expect->send("caclp;\r");
        sleep(10);
        $expect->expect(5,'<');
my $cmd = "caclp";
                check_output($ntwrk_element,$cmd);
                $expect->send("SYRIP;\r");
        $expect->expect(5,'ORDERED');
        $expect->expect(5,'<');
                $expect->send("\cD");
                sleep(10);
                $expect->send("\r");
                $expect->expect(5,'<');
                check_output($ntwrk_element,"SYRIP");
                $expect->send("exit;\r");
                $expect->soft_close();
#}
#=======================================================================
#FRAME::end_frame "$TC";

sub check_output
{
        my $node = shift;
                my $cmd = shift;
                chomp($node);
                chomp($cmd);
        open (FH, "</home/nmsadm/eam/tmp/tryexpect.log") or die $!;

        my @file_output=<FH>;
                #print "@file_output\n"; 
                if ($cmd eq "caclp")
                {
                        if ( grep(/TIME/,@file_output) && grep(/END/,@file_output) &&  grep(/</,@file_output))
                        {
        print RFH "PASS : Received proper response for the command from $node";
#                Te::tex "$TC", "INFO  : Received proper response for the command from $node";

                        }
                        else
                        {
        print RFH "FAIL : Response recieved is not proper from $node";
#                Te::tex "$TC", "ERROR  : Response recieved is not proper from $node";

                        }
                }
                else
                {
                        if (grep(/ORDERED/,@file_output) && grep(/END/,@file_output) && grep(/</,@file_output))
                        {
        print RFH "PASS : Received proper response for the command from $node";
#                Te::tex "$TC", "INFO  : Received proper response for the command from $node";

                        }
                        else
                        {
        print RFH "FAIL : Response recieved is not proper from $node";
#                Te::tex "$TC", "ERROR  : Response recieved is not proper from $node";

                        }
                }
}

close(RFH);

system("/bin/cat AXM_FT_EAM_ImResp_Buffer_EHIP_T.txt | /bin/grep FAIL ");
if ($? == 0)
{
print  "\nFAIL\n";
}
else
{
print "\nPASS\n";
}
