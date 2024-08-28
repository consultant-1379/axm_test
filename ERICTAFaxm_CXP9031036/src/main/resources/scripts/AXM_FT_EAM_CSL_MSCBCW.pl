#!/usr/bin/perl
#
# SCRIPT NAME:AXM_FT_EAM_CSL_MSCBCW.pl
# Test Case & Priority: AXM_FT_EAM_CSL  (Pr.1)
# Test Case No :5.9.11
# AUTHOR:
# DATE  :
# REV:
#
################################ Description ######################
#This test case checks that the EHMS responders for Alarm and File Notification.
###################################################################
# Prerequisites  :
# Return Value on Success : 0
# Return Value on Failure : 1
# Result File : /home/nmsadm/eam/logs
#
# Usage :  bash RUNME -t AXM_FT_EAM_CSL_MSCBCW.pl:<MSCBCW node name>
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

open(RFH,">AXM_FT_EAM_CSL_MSCBCW.txt");
print "Collecting the nodes from xml to which commands need to be sent\n";
my $res = 0;

my @diff_valid_connec = ("NE=$ntwrk_element,CPGROUP=OPGROUP,CSL=1","NE=$ntwrk_element,CPGROUP=OPGROUP","NE=$ntwrk_element,CSL=1");




foreach $node (@diff_valid_connec)
{

	chomp($node);
        print "Establishing connection for $node\n";
        my $expect = Expect->new;
        my $command = "/opt/ericsson/bin/eaw $node";
        $expect->spawn($command) or die "Cannot spawn : $!\n";
        $expect->log_file("/home/nmsadm/csl.log","w");
        $expect->expect(5,'<');
                
        check_output($node);
        $expect->send("quit;\r");
        $expect->soft_close();


}

#=======================================================================


sub check_output
{
        my $node = shift;
        chomp($node);
           
        open (FH, "</home/nmsadm/csl.log") or die $!;
		my @file_output=<FH>;
        if ( grep(/</,@file_output)) 
        {
		print RFH "PASS : Successful for $node";
              
        }
        else
        {
		print RFH "FAIL : unsuccessful for $node";
              
        }
}

close(RFH);

system("/bin/cat AXM_FT_EAM_CSL_MSCBCW.txt | /bin/grep FAIL ");
if ($? == 0)
{
print  "\nFAIL\n";
}
else
{
print "\nPASS\n";
}
