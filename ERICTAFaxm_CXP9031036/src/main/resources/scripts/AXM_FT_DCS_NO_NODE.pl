#!/usr/bin/perl
#
# SCRIPT NAME:AXM_FT_DCS_NO_NODE.pl
# Test Case & Priority:AXM_FT_DCS_NO_NODE(Pr.1)
# Test Case No :6.24
# AUTHOR:xharcha
# DATE  :
# REV:
#
# Description :
# Prerequisites  :
# Return Value on Success : 0
# Return Value on Failure : 1
# Result File : /home/nmsadm/eam/results
#
# Usage :  bash RUNME -t AXM_FT_DCS_NO_NODE.pl.
#
# Dependency : Te.pm, crdmp.sh, PMSEerrorchk.sh
#
# REV HISTORY
# DATE:                           BY                                 MODIFICATIO
#
##########################################################

# DEFINE FILES AND VARIABLES HERE
#use Te;
#use FRAME;
use Expect;
#use util;
#my $EAM_DIR    = $ENV{EAM_DIR};
#my $TC         = "AXM_FT_DCS_NO_NODE";
#my $RESULT_DIR = $ENV{RESULT_DIR};
#my $TMP        = $ENV{TMP};
#$ENV{tc} = AXM_FT_DCS_NO_NODE;
#my $path = "/var/opt/ericsson/nms_eam_eac/log/ev/";
#my $log = "eacr.new";
#my $flag = 1;

#FRAME::start_frame "$TC";
#========================================================================

open (RFH,">AXM_FT_DCS_NO_NODE.txt");
if( -d "/opt/ERICddc/util/bin/")
{ 

my $expect;
  $expect = Expect->spawn("su - root");
  $expect->expect (10,'Password:');
  $expect->send("wipro10\r");
  $expect->expect (10,'#');
  $expect->send("bash\r");
  $expect->expect (10,'#');
  $expect->send("/opt/ERICddc/util/bin/dcs -f EAM\r");
  sleep(20);
 $expect->expect (120,'#');
  $expect->soft_close();

my $count = `/bin/ls -l /tmp/dcs/eam_dct/ | /bin/wc | /bin/awk '{print \$1}'`;

if ( $count gt 15 )
 {
	print RFH "PASS : DCS executed successfully\n";
  }
else
  {
	print RFH "FAIL : DCS execution failed\n";
        #FRAME::end_frame "$TC";

   }

}
else
{
	print RFH "FAIL : ERICddc package in not present cannot execute DCS\n";
}
# print "\nExecuting Event log Scenario done\n";

close(RFH);

system("/bin/cat AXM_FT_DCS_NO_NODE.txt | /bin/grep FAIL ");
if ($? == 0)
{
print  "FAIL\n";
}
else
{
print "PASS\n";
#unlink("AXM_FT_DCS_NO_NODE.txt");
}
#=======================================================================
#FRAME::end_frame "$TC";

