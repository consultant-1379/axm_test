#!/usr/bin/perl
#
# SCRIPT NAME:AXM_FT_EAM_EventLogging_EHIP_T_BSCW.pl
# Test Case & Priority: AXM_FT_EAM_EventLogging_EHIP_T (Pr.1)
# Test Case No :5.2.6(handler)
# AUTHOR:
# DATE  :
# REV:
#
############################### Description #####################
# Check for the logging of the events when the event_log_status #
# is set to 1                                                   #
#################################################################
# Prerequisites  :
# Return Value on Success : 0
# Return Value on Failure : 1
# Result File : /home/nmsadm/eam/results
#
# Usage :  bash RUNME -t AXM_FT_EAM_EventLogging_EHIP_T_BSCW.pl:BSCW.
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

#======================================================================
open(RFH,">/home/nmsadm/AXM_FT_EAM_EventLogging_EHIP_T_BSCW.txt");
$path = "/var/opt/ericsson/nms_eam_eac/log/ev/";

sub node_conn
{ 
        
  print "Establishing connection for $node\n";    
        my $expect = Expect->new;
        my $command = "/opt/ericsson/bin/eaw $ntwrk_element";
        $expect->spawn($command) or die "Cannot spawn : $!\n";
        #$expect->log_file("/home/nmsadm/eam/tmp/tryexpect.log","w+");
        $expect->expect(5,'<');
        $expect->send("caclp;\r");
        $expect->expect(5,'<');
        $expect->send("EXIT;\r");
        $expect->soft_close();
 
}

sub condn_check
{ 
if ( $? == 0 ) {
	print RFH "PASS : file exists, Copying is done";
}
else {
	print RFH "FAIL : There is error in updating event log";

}
}
 print "\nExecuting Event log Scenario\n";
 system("/opt/ericsson/bin/eac_egi_config -set event_log_status 1");
 sleep(20);
 system(" /bin/cp $path/eacr.new /home/nmsadm/eam/tmp.txt ");
 condn_check;
 node_conn;
 system(" /bin/cp $path/eacr.new /home/nmsadm/eam/tmp1.txt ");
 condn_check;
 my $filesize = -s "/home/nmsadm/eam/tmp.txt";
 my $filesize1 = -s "/home/nmsadm/eam/tmp1.txt";
 if ($filesize < $filesize1)
 {
	print RFH "PASS : file size is as expected";
 
}
 else
{
	print RFH "FAIL : There is an issue with the filesize"; 
 
}

close(RFH);

system("/bin/cat /home/nmsadm/AXM_FT_EAM_EventLogging_EHIP_T_BSCW.txt | /bin/grep FAIL ");
if ($? == 0)
{
print  "\nFAIL\n";
}
else
{
print "\nPASS\n";
}

#=======================================================================
