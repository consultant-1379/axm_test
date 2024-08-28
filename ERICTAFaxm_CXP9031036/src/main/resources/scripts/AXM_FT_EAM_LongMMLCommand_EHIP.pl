#!/usr/bin/perl
#
# SCRIPT NAME:AXM_FT_EAM_LongMMLCommand_EHIP.pl
# Test Case & Priority:AXM_FT_EAM_LongMMLCommand_EHIP.pl   (Pr.3)
# Test Case No :5.3.19,5.4.20(handler)
# AUTHOR:XNNNKKR
# DATE  :15/04/2015
# REV:1.0
#
######################### Description ############
# This test case verifies the long MML command   # 
##################################################
# Return Value on Success : PASS
# Return Value on Failure : FAIL
# Usage :/usr/local/bin/perl AXM_FT_EAM_LongMMLCommand_EHIP.pl <node_name>
# Dependency : The following file is required to run this use case:-
#/home/nmsadm/eam/crtest_env.sh
#

#REV HISTORY
# DATE:                   BY                                  MODIFICATION:
###############################################################################

use Expect;

$ntwrk_element=$ARGV[0];

open(RFH,">AXM_FT_EAM_LongMMLCommand_EHIP.txt");
$key= "REFERENCE";
$key1="END";


print "Starting of Test Execution\n";

my $protocol=`/opt/ericsson/bin/eac_esi_config -ne $ntwrk_element | /bin/grep cr_protocol | /bin/cut -d "=" -f2`;
chomp($protocol);
if ($protocol =~ /SSH_*/)
{
	print RFH "PASS : Protocol is SSH\n";
	print RFH "PASS : Test Case is running against $ntwrk_element with SSH Protocol $protocol\n";
}
else
{
	print RFH "PASS : Protocol is TELNET\n";
	print RFH "PASS : Test Case is running against $ntwrk_element with TELNET Protocol $protocol\n";
}


print "Establishing connection for $ntwrk_element\n";    
my $expect = Expect->new;
my $command = "/opt/ericsson/bin/eaw -n $ntwrk_element";
$expect->spawn($command) or die "Cannot spawn : $!\n";
$expect->log_file("/home/nmsadm/LongMMLCommand_EHIP.log","w");
$expect->expect(10,'<');
$expect->send("Caclp;!abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopq\r");
$expect->expect(10,'<');
$expect->send("quit\r");
$expect->soft_close();

@size_search = `/bin/egrep "$key\|$key1" /home/nmsadm/LongMMLCommand_EHIP.log"`;

$size = @size_search;
print "$size\n";

if ( scalar(@size_search) == 2  ) 
{    
	print RFH "PASS : Caclp command Execution in showinfo mode is successful\n";

}
else 
{
	print RFH "FAIL :  caclp command Execution in showinfo mode is not successful\n";
	

}
close(RFH);

system("/bin/cat AXM_FT_EAM_LongMMLCommand_EHIP.txt | /bin/grep FAIL ");

if ($? == 0)
{
	print  "\nFAIL\n";
}
else
{
	print "\nPASS\n";
}
