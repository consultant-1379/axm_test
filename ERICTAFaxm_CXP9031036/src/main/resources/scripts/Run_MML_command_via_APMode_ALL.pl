#!/usr/bin/perl
#
# SCRIPT NAME:Run_MML_command_via_APMode_ALL.pl
# Test Case & Priority: Run_MML_command_via_APMode(Pr.1)
# Test Case No :6.24.1(common)
# AUTHOR:
# DATE  :
# REV:
#
# Description :
# Prerequisites  :
# Return Value on Success : 0
# Return Value on Failure : 1
# Result File : /home/nmsadm/eam/results
#
# Usage :  bash RUNME -t Run_MML_command_via_APMode_ALL.pl.
#
# Dependency : Te.pm, crdmp.sh, PMSEerrorchk.sh
#
# REV HISTORY
# DATE:                           BY                                 MODIFICATION:
#
##########################################################

# DEFINE FILES AND VARIABLES HERE

use Expect;
open(RFH,">Run_MML_command_via_APMode_ALL.txt");
$ntwrk_element=$ARGV[0];#ENV{ntwrk_element};
#FRAME::start_frame "$TC";
#======================================================================

sub node_conn
{ 
    
        
  print "Establishing connection for $node\n";    
        my $expect = Expect->new;
        my $command = "/opt/ericsson/bin/eaw $ntwrk_element";
        $expect->spawn($command) or die "Cannot spawn : $!\n";
        $expect->log_file("/home/nmsadm/MML_cmd_AP.log","w+");
        $expect->expect(15,'<');
        $expect->send("aploc;\r");
        $expect->expect(20,'>');
        $expect->send("mml caclp;\r");
        $expect->expect(20,'>');
        $expect->send("mml LASIP:BLOCK=ALL;\r");
        $expect->expect(20,'>');
        $expect->send("quit;\r");
        $expect->expect(5,'>');
        $expect->soft_close();
 
}

sub condn_check
{ 
if ( $? == 0 ) {
	print RFH "PASS : Command works as expected in AP Mode";
  #  Te::tex "$TC", "\nINFO  :Command works as expected in AP Mode";
}
else {
	print RFh "FAIL : Command doesn't work as expected in AP Mode";
  #  Te::tex "$TC", "\nERROR  : Command doesn't work as expected in AP Mode";
    
}
}
node_conn;
system("/bin/grep TIME /home/nmsadm/MML_cmd_AP.log && /bin/grep SOFTWARE /home/nmsadm/MML_cmd_AP.log");
condn_check;

close(RFH);
system("/bin/cat Run_MML_command_via_APMode_ALL.txt | /bin/grep FAIL ");
if ($? == 0)
{
print  "\nFAIL\n";
}
else
{
print "\nPASS\n";
#unlink("Run_MML_command_via_APMode_ALL.txt");
}
#=======================================================================
#FRAME::end_frame "$TC";

