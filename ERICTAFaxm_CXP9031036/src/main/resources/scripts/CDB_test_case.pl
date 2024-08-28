#!/usr/bin/perl
#!/usr/local/bin/expect
#
# SCRIPT NAME:Send mml commands to nodes with TELNET PROTOCOL. 
# Test Case & Priority: Send MML Command from Command Handler to 
# BSC with # APG40/43/L, no SSH(TELNET)(CDB test case)
# Test Case No :Send MML Command from Command Handler to BSC with 
# APG40/43/L, no SSH(TELNET)(CDB test case)
# AUTHOR:XNNNKKR
# DATE  :
# REV:
#
# Description :To check the execution of mml command using nodes 
# with telnet protocol. 
# Prerequisites  :
# Return Value on Success : 0
# Return Value on Failure : 1


#
# REV HISTORY
# DATE:  29/4/2014                        BY                      
# MODIFICATION:02/05/2014
#
##########################################################

# DEFINE FILES AND VARIABLES HERE

use Expect;
use strict;


my @Total_nodes={};
my $protocol="";
my $inc=0;
my @telnet_protocol={};
my $pro_node="";
my $i=0;
unlink("MML_CMDS_SSH_NODES.txt");
@Total_nodes=`/opt/ericsson/bin/eac_esi_config -nl |/usr/bin/cut -d " " -f1`;
open(RFH,">>MML_CMDS_SSH_NODES.txt");
for($i=3;$i<scalar(@Total_nodes);$i++)
{
chomp($Total_nodes[$i]);
my $protocol = `/opt/ericsson/bin/eac_esi_config -ne $Total_nodes[$i] | /usr/bin/grep cr_protocol | /usr/bin/awk '{print \$3}'`;
chomp($protocol);
if ($protocol =~ /SSH*/)
{
$telnet_protocol[$inc]=$Total_nodes[$i];
$inc++;
}
}

foreach $pro_node (@telnet_protocol)
{
chomp($pro_node);
#open(RFH,">>MML_CMDS_TELNET_NODES.txt");
print "Establishing connection for $pro_node\n";    
        my $expect = Expect->new;
        my $command = "/opt/ericsson/bin/eaw $pro_node";
        $expect->spawn($command) or die "Cannot spawn : $!\n";
        $expect->log_file("Imm_ResponseAuth_SSh.log","w+");
        $expect->expect(5,'<');
        $expect->send("caclp;\r");
        $expect->expect(5,'<');
        $expect->send("quit;\r");
        $expect->soft_close();
 
system("/usr/bin/grep TIME Imm_ResponseAuth_SSh.log >> /dev/null");

if ( $? == 0 ) 
{
 print RFH "$pro_node:PASS\n";
 unlink("Imm_ResponseAuth_SSh.log"); 
}
else 
{
 print RFH "$pro_node:FAIL\n";
 unlink("Imm_ResponseAuth_SSh.log");
}

}
close(RFH);

system("cat MML_CMDS_SSH_NODES.txt"); 
system("/usr/bin/grep FAIL MML_CMDS_SSH_NODES.txt >> /dev/null");

if ( $? == 0 ) 
{
 print "FAIL\n"; 
 }
else 
{
 print "PASS\n";

}


