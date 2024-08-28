#!/usr/bin/perl
#
# SCRIPT NAME:AXM_FT_Verify_the_default_value_of_port_for_protocols_ALL.pl
# Test Case & Priority: AXM_FT_Verify the default value of port for protocols (Pr.1)
# Test Case No : 7.2.12 (Common)
# AUTHOR: XROHAGR
# DATE  : 21/11/2013
# REV: A
#
# Description : 
# Prerequisites  : 
# Return Value on Success : 0
# Return Value on Failure : 1
# Result File : /home/nmsadm/eam/results
#
# Usage :  bash RUNME -t AXM_FT_Verify_the_default_value_of_port_for_protocols_ALL.pl:<node name>
#
# Dependency : Te.pm, crdmp.sh, PMSEerrorchk.sh
#
# REV HISTORY
# DATE:                           BY                                 MODIFICATION:
#
##########################################################
# DEFINE FILES AND VARIABLES HERE

#========================================================================
$ntwrk_element = $ARGV[0];
open(RFH,">AXM_FT_Verify_the_default_value_of_port_for_protocols_ALL.txt");
#Verify default value of port for the protocols 

my $TELNET_PORT = 23;
my $SSH_PORT = 22;

my $TELNET_MTS_PORT_BSC_MSC = 5000;
my $TELNET_MTS_PORT_MSCBC = 5002;

my $SSH_MSS_PORT_BSC_MSC = 52000;
my $SSH_MSS_PORT_MSCBC = 52002;

$node = $ntwrk_element;

   # $node = util::trim $node;
   #chomp($node);
  my $cr_protocol =`/opt/ericsson/bin/eac_esi_config -ne $ntwrk_element | grep cr_protocol | awk '{print \$3}'`;
  #  my $cr_protocol =
   #   `eac_esi_config -ne $node | grep "cr_protocol    = " | cut -d "=" -f2`;
   
    my $cr_daemon =
      `/opt/ericsson/bin/eac_esi_config -ne $node | grep "cr_daemon       =" | cut -d "=" -f2`;
    
	my $telnet_port =
      `/opt/ericsson/bin/eac_esi_config -ne $node | grep "telnet_port     =" | cut -d "=" -f2`;
	  
	my $telnet_mts =
      `/opt/ericsson/bin/eac_esi_config -ne $node | grep "telnet_mts      =" | cut -d "=" -f2`;
	  
	my $ssh_port =
      `/opt/ericsson/bin/eac_esi_config -ne $node | grep "ssh_port        =" | cut -d "=" -f2`;
	  
	my $ssh_mss =
      `/opt/ericsson/bin/eac_esi_config -ne $node | grep "ssh_mss         =" | cut -d "=" -f2`;
	  
  #  $cr_protocol =util::trim $cr_protocol;
   # $cr_daemon =util::trim $cr_daemon;
   # $telnet_port =util::trim $telnet_port;
#	$telnet_mts =util::trim $telnet_mts;
#	$ssh_port =util::trim $ssh_port;
#	$ssh_mss =util::trim $ssh_mss;
#        chomp($cr_protocol);
#        chomp($cr_daemon);
#        chomp($telnet_port);
#	chomp($telnet_mts);
#        chomp($ssh_port);
#        chomp($ssh_mss);
	print "cr_protocol = $cr_protocol\n";
	print "cr_daemon = $cr_daemon\n";
	print "telnet_port = $telnet_port\n";
	print "telnet_mts = $telnet_mts\n";
	print "ssh_port = $ssh_port\n";
	print "ssh_mss = $ssh_mss\n";
	
	#$ssh_port = 22; # HardCoded will be remove after eac_esi_config cr implementation...
	
	if($telnet_port =~ /23/ || $ssh_port =~ /22/)
{
print RFH "PASS:port number is proper\n";
}
else
{
print RFH "FAIL:improper port number\n";
}
	

close(RFH);
system("grep FAIL AXM_FT_Verify_the_default_value_of_port_for_protocols_ALL.txt");
if ($?==0)
{
print  "\nFAIL\n";
}
else
{
print "\nPASS\n";
}
#=======================================================================
#FRAME::end_frame "$TC";


