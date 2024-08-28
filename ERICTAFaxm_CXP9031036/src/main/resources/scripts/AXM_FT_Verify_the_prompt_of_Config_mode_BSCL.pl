#!/usr/bin/perl
#
# SCRIPT NAME:AXM_FT_verify_the_prompt_of_config_mode_BSCL.pl
# Test Case & Priority: AXM_FT_verify_the_prompt_of_config_mode (Pr.1)
# Test Case No : 7.2.21 (common)
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
# Usage :  bash RUNME -t AXM_FT_Verify_the_prompt_of_Config_mode_BSCL.pl:LINUX.
#
# Dependency : Te.pm, crdmp.sh, PMSEerrorchk.sh
#
# REV HISTORY
# DATE:                           BY                                 MODIFICATION:
#
##########################################################

# DEFINE FILES AND VARIABLES HERE

use Expect;

open(RFH,">>AXM_FT_Verify_the_prompt_of_Config_mode_BSCL.txt");

$ntwrk_element=$ARGV[0];#ENV{ntwrk_element};


#======================================================================

sub node_conn
{ 
    
        
  print "Establishing connection for $node\n";    
        my $expect = Expect->new;
        my $command = "/opt/ericsson/bin/eaw $ntwrk_element";
        $expect->spawn($command) or die "Cannot spawn : $!\n";
        $expect->log_file("/home/nmsadm/eam/tmp/config_mode.log","w+");
        $expect->expect(5,'<');
        $expect->send("aploc;\r");
        $expect->expect(5,'>');
        $expect->send("configure\r");
        $expect->expect(5,'(config)>');
        $expect->send("end\r");
        $expect->expect(5,'>');
        $expect->soft_close();
 
}

sub condn_check
{ 
if ( $? == 0 ) {
print RFH "PASS : Switch to config mode is successful";
   # Te::tex "$TC", "\nINFO  :Switch to config mode is successful";
}
else {
print RFH "FAIL :  Switch to config mode is not successful";
  #  Te::tex "$TC", "\nERROR  : Switch to config mode is not successful";
    
}
}
node_conn;
system("/bin/cat /home/nmsadm/eam/tmp/config_mode.log| /bin/grep config ");
condn_check;

#=======================================================================

close(RFH);
system("/bin/cat AXM_FT_Verify_the_prompt_of_Config_mode_BSCL.txt | /bin/grep FAIL ");
if ($? == 0)
{
print  "\nFAIL\n";
}
else
{
print "\nPASS\n";
unlink("AXM_FT_Verify_the_prompt_of_Config_mode_BSCL.txt");
}
