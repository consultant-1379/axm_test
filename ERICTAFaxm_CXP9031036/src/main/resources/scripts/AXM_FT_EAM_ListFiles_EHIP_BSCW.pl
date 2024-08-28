#!/use/bin/perl
#
# SCRIPT NAME:AXM_FT_EAM_ListFiles_EHIP_BSCW.pl
# Test Case & Priority: AXM_FT_EAM_ListFiles_EHIP_T , AXM_FT_EAM_ListFiles_EHIP_S(Pr.3)
# Test Case No :5.3.57, 5.4.46(handler)
# AUTHOR:
# DATE  :
# REV:
#
################################ Description #############################
# List the CPF file table using the command "cpfls" in aploc mode and    #
# verify the response.                                                   #
##########################################################################
# Prerequisites  :
# Return Value on Success : 0
# Return Value on Failure : 1
# Result File : /home/nmsadm/eam/logs
#
# Usage :  bash RUNME -t AXM_FT_EAM_ListFiles_EHIP_BSCW.pl:<node>
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

#$FRAME::start_frame "$TC";
#========================================================================
open(RFH,">AXM_FT_EAM_ListFiles_EHIP_BSCW.txt");
print "Starting the test Execution\n";
print "Sending command for $ntwrk_element\n";    
my $expect = Expect->new;
my $command = "/opt/ericsson/bin/eaw $ntwrk_element";
$expect->spawn($command) or die "Cannot spawn : $!\n";
$expect->log_file("tryexpect.log","w");
$expect->expect(5,'<');
$expect->send("aploc;\r");
$expect->expect(5,'>');
$expect->send("cpfls\r");
$expect->expect(5,'>');
$expect->send("exit\r");
$expect->expect(5,'<');
$expect->send("exit;\r");
$expect->soft_close();
print "\n";
print "Checking whether output of node is received\n";
check_output($ntwrk_element);
        
#=======================================================================
#FRAME::end_frame "$TC";

sub check_output
{
        my $node = shift;
        #$node = chomp $node; 
        open (FH, "<tryexpect.log") or die $!;

        my @file_output=<FH>;
                #print "@file_output\n";        
        if (grep(/CPF FILE TABLE/,@file_output))
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
close(RFH);

system("/bin/cat AXM_FT_EAM_ListFiles_EHIP_BSCW.txt | /bin/grep FAIL ");
if ($? == 0)
{
print  "\nFAIL\n";
}
else
{
print "\nPASS\n";
}
