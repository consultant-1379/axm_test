#!/usr/bin/perl
#
# SCRIPT NAME:AXM_FT_EAM_filenotification_any_node.pl
# Test Case & Priority: AXM_FT_EAM_filenotification_any_node (Pr.1)
# Test Case No : (Handler)
# AUTHOR: XJITKUM
# DATE  : 09\01\2013
# REV: A
#
########################### Description ###########################
# This test case is used to verify the File notification appears, #
# when the test program notify_rcv_test is started as user nmsadm #
###################################################################
# Prerequisites : notify_rcv_test
# Return Value on Success : 0
# Return Value on Failure : 1
# Result File : /home/nmsadm/eam/results
# Log File : /home/nmsadm/eam/tmp/alarm.log
# Usage :  bash RUNME -t AXM_FT_EAM_filenotification_any_node.pl.
#
# Dependency : Te.pm, crdmp.sh, PMSEerrorchk.sh, notify_rcv_test
#
# REV HISTORY
# DATE:                           BY                                 MODIFICATION:
#
##########################################################

# DEFINE FILES AND VARIABLES HERE
#use Te;
#use FRAME;
#use Expect;
#use util;

#my $EAM_DIR    = $ENV{EAM_DIR};
#my $TC         = "AXM_FT_EAM_filenotification_any_node";
#my $RESULT_DIR = $ENV{RESULT_DIR};
#my $TMP        = $ENV{TMP};
#$ENV{tc} = AXM_FT_EAM_filenotification_any_node;
#$ntwrk_element=$ENV{ntwrk_element};

use Expect;
open(RFH,">AXM_FT_EAM_filenotification_any_node.txt");
$ntwrk_element=$ARGV[0];
#FRAME::start_frame "$TC";
#======================================================================

check_file_exist("/home/nmsadm/eam/notify_rcv_test");

$cmd = "/home/nmsadm/eam/notify_rcv_test";

my $expect = Expect->new;

$expect->log_file("EAM_filenotificationlog","w+");

$expect->spawn($cmd) or die "Cannot spawn : $!\n";
                $expect->expect(5,'?');

                $expect->send("$ntwrk_element\r");
                $expect->expect(5,'?');

                $expect->send("*\r");
                $expect->expect(5,'?');

                $expect->send("-1\r");
                $expect->expect(240,'***********************************************');

                $expect->send("^Z\r");
                $expect->expect(5,'>');

                $expect->soft_close();

my $fnotify_var =`/bin/cat EAM_filenotificationlog |/bin/grep "Notify received" | /bin/awk '{print \$2}'`;
print "fnotify_var == ",$fnotify_var;

if (`$fnotify_var` eq `received`)
        {
                #Te::tex "$TC", "\nINFO  : File notification received successfully.";
		 print RFH " PASS:File notification received successfully.";
        }
        else
        {
                #Te::tex "$TC", "\nERROR : File notification not able to receive.";
		 print RFH "FAIL:File notification not able to receive.";
		
        }

#=======================================================================
#FRAME::end_frame "$TC";

sub check_file_exist
{
        my $file = $_[0];

        if ( -e "$file" )       {
           print RFH " PASS:Required $file has been found\n";
                 #Te::tex "$TC", "INFO  : Required $file has been found.";
        }
        else    {
            print RFH "FAIL:Couldn't find $file the required file to process\n";
                 #Te::tex "$TC", "ERROR : Couldn't find $file the required file to process.";
                # FRAME::end_frame "$TC";
        }
}

close(RFH);
system("/bin/grep FAIL AXM_FT_EAM_filenotification_any_node.txt");
if ($? == 0)
{
print  "\nFAIL\n";
}
else
{
print "\nPASS\n";
#unlink("/home/nmsadm/AXM_FT_EAM_ImmediateRespLog_EHIP_RealNode_BSCL.txt");
}


