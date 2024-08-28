#!/usr/bin/perl
#
# SCRIPT NAME:AXM_FT_EAM_EHIP_Specific_AplocDisc_EHIP_BSC_BSCW.pl
# Test Case & Priority:AXM_FT_EAM_ImResp_Reception_EHIP_S (Pr.1)
# Test Case No :5.4.12(handler)
# AUTHOR:XNNNKKR
# DATE  :
# REV:
################################ Description ######################
#This test case is to check the whether we can Disconnect from AP Local Mode.
###################################################################
# Prerequisites  :
# Return Value on Success : 0
# Return Value on Failure : 1
# Result File : /home/nmsadm/eam/results
#
# Usage :  bash RUNME -t 
#AXM_FT_EAM_EHIP_Specific_AplocDisc_EHIP_BSC_BSCW.pl:BSCW(types).
#
# Dependency : Te.pm, crdmp.sh, PMSEerrorchk.sh
#
# REV HISTORY
# DATE:                           BY                              
 #  MODIFICATION:
#
##########################################################

# DEFINE FILES AND VARIABLES HERE
use Expect;
$ntwrk_element=$ARGV[0];#ENV{ntwrk_element};

#================================================================

open(RFH,">AXM_FT_EAM_EHIP_Specific_AplocDisc_EHIP_BSC_BSCW.txt");
my $protocol=`/opt/ericsson/bin/eac_esi_config -ne $ntwrk_element | /bin/grep cr_protocol | /bin/cut -d "=" -f2`;
#chomp($protocol);

if ($protocol =~ /SSH_*/)
{
	print RFH "PASS : Protocol is SSH";
	print RFH "PASS : Test Case is running against $ntwrk_element with SSH Protocol $protocol";
}
else
{
	print RFH "PASS : Protocol is TELNET"; 
	print RFH "PASS : Test Case is running against $ntwrk_element with TELNET Protocol $protocol"; 
}

 
  print "Establishing connection for $ntwrk_element\n";  
	print $ntwrk_element;
        my $expect = Expect->new;
        my $command = "/opt/ericsson/bin/eaw $ntwrk_element";
        $expect->spawn($command) or die "Cannot spawn : $!\n";
        $expect->log_file("aploc.log",">");
        $expect->expect(5,'<');
        $expect->send("aploc;\r");
        $expect->expect(5,'>');
        $expect->send("quit\r");
        $expect->expect(5,'>');
        $expect->soft_close();

 

system("/bin/cat aploc.log | /bin/grep aploc ") ;  

if ( $? == 0  ) 
{    
    system("rm aploc.log");
	print RFH "PASS : Aploc Command Exe/bin/cution is successful";
    
}
else 
{
	print RFH "FAIL : Aploc Command Exe/bin/cution is not successful";
	print RFH "FAIL : Please remove the EH_Parameter.log ";
    
    
}


#================================================================
close(RFH);

system("/bin/cat AXM_FT_EAM_EHIP_Specific_AplocDisc_EHIP_BSC_BSCW.txt | /bin/grep FAIL ");
if ($? == 0)
{
print  "\nFAIL\n";
}
else
{
print "\nPASS\n";
}
