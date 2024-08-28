#!/usr/bin/perl
#
# SCRIPT NAME:AXM_FT_verify_the_node_connection_problem.pl
# Test Case & Priority: AXM_FT_verify_the_node_connection_problem (Pr.1)
# Test Case No :10.1.1 (Common)
# AUTHOR:XNNNKKR
# DATE  :
# REV:
#
# Description :
# Prerequisites  :
# Return Value on Success : 0
# Return Value on Failure : 1
# Result File : /home/nmsadm/eam/results
#
# Usage :  bash RUNME -t AXM_FT_Node_Connection_problem_ALL.pl:ALL types of nodes.
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
open(RFH,">AXM_FT_Node_Connection_problem_ALL.txt");
sub node_conn
{ 
    
        
  print "Establishing connection for $node\n";    
        my $expect = Expect->new;
        my $command = "/opt/ericsson/bin/eaw $ntwrk_element";
        $expect->spawn($command) or die "Cannot spawn : $!\n";
        $expect->log_file("/home/nmsadm/eam/tmp/Node_connection.log","w+");
        $expect->expect(5,'<');
        $expect->send("aploc;\r");
        $expect->expect(5,'>');
        $expect->send("alogfind\r");
        $expect->expect(5,'>');
        $expect->send("quit;\r");
        $expect->expect(5,'>');
        $expect->soft_close();
 
}

sub condn_check
{ 
if ( $? == 0 ) {
	print RFH "PASS : Command execution is successful";
   # Te::tex "$TC", "\nINFO  :Command execution is successful";
}
else {
	print RFH "FAIL : Command execution is not successful";
   # Te::tex "$TC", "\nERROR  : Command execution is not successful";
    
}
}
node_conn;
system("/bin/cat /home/nmsadm/eam/tmp/Node_connection.log| /bin/grep Event ");
condn_check;
close(RFH);
system("/bin/cat AXM_FT_Node_Connection_problem_ALL.txt | /bin/grep FAIL ");
if ($? == 0)
{
print  "\nFAIL\n";
}
else
{
print "\nPASS\n";
unlink("AXM_FT_Node_Connection_problem_ALL..txt");
}
#=======================================================================
#FRAME::end_frame "$TC";
