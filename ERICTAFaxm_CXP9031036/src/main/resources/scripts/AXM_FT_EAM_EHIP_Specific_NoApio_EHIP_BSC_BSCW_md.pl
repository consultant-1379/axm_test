#!/usr/bin/perl
#
# SCRIPT NAME:AXM_FT_EAM_EHIP_Specific_NoApio_EHIP_BSC_BSCW.pl
# Test Case & Priority:AXM_FT_EAM_EHIP_Specific_NoApio_EHIP_BSC(Pr.1)
# Test Case No :5.4.13(handler)
# AUTHOR:XNNNKKR
# DATE  :
# REV:
#
################################ Description ######################
# Check for the NE connection by combining with the NE connection #
# parameters like "DEV=AD-100,SIDE=STANDBY"                       #
###################################################################
# Prerequisites  :
# Return Value on Success : 0
# Return Value on Failure : 1
# Result File : /home/nmsadm/eam/results
#
# Usage :  bash RUNME -t 
#AXM_FT_EAM_EHIP_Specific_NoApio_EHIP_BSC_BSCW.pl:BSCW(types).
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

open(RFH,">AXM_FT_EAM_EHIP_Specific_NoApio_EHIP_BSC_BSCW.txt");

 $param = "DEV=AD-100,SIDE=STANDBY";
    
my $protocol=`/opt/ericsson/bin/eac_esi_config -ne $ntwrk_element | /bin/grep cr_protocol | /bin/cut -d "=" -f2`;
$protocol = chomp $protocol;

if ($protocol =~ /SSH_*/)
{
	print RFH "PASS : Protocol is SSH";
	print RFH "FAIL : Test Case is running against $ntwrk_element with SSH Protocol $protocol";
}
else
{
	print RFH "PASS :  Protocol is TELNET";
	print RFH "PASS :  Test Case is running against $ntwrk_element with TELNET Protocol $protocol";
}

 
  print "Establishing connection for $ntwrk_element\n";    
        my $expect = Expect->new;
        my $command = "/opt/ericsson/bin/eaw $ntwrk_element,$param";
        $expect->spawn($command) or die "Cannot spawn : $!\n";
        $expect->log_file("/home/nmsadm/eam/tmp/connect.log",">");
        $expect->expect(5,'<');
        $expect->send("caclp;\r");
        $expect->expect(5,'<');
        $expect->send("quit\r");
        $expect->soft_close();

 

system("/bin/cat /home/nmsadm/eam/tmp/connect.log | /bin/grep TIME ") ;  

if ( $? == 0  ) 
{    
    system("rm /home/nmsadm/eam/tmp/connect.log");
	print RFH "PASS : Aploc Command Execution is successful\n";
    
}
else 
{
	print RFH "FAIL : Aploc Command Execution is not successful";
	print RFH "FAIL : Please remove the EH_Parameter.log in /home/nmsadm/eam/tmp";
    
}


#================================================================
close(RFH);

system("/bin/cat AXM_FT_EAM_EHIP_Specific_NoApio_EHIP_BSC_BSCW.txt | /bin/grep FAIL ");
if ($? == 0)
{
print  "\nFAIL\n";
}
else
{
print "\nPASS\n";
}

