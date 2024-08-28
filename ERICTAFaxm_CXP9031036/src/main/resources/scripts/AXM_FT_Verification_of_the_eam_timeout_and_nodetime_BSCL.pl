#!/usr/bin/perl
#
# SCRIPT NAME:AXM_FT_Verification_of_eam_timeout_nodetime_BSCL.pl
# Test Case & Priority: AXM_FT_Verification_of_eam_timeout_nodetime (Pr.1)
# Test Case No :7.2.37(common)
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
# Usage :  bash RUNME -t AXM_FT_Verification_of_the_eam_timeout_and_nodetime_BSCL.pl:BSCL(type node).
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
open(RFH,">>AXM_FT_Verification_of_the_eam_timeout_and_nodetime_BSCL.txt");
system("/opt/ericsson/bin/eac_esi_config -ne $ntwrk_element -set conn_idle_to 7");
sleep(3);
#$var = 'Time';
#$var = "Time";
sub node_conn
{ 
    
        
  print "Establishing connection for $ntwrk_element\n";    
        my $expect = Expect->new;
        my $command = "/opt/ericsson/bin/eaw $ntwrk_element";
        $expect->spawn($command) or die "Cannot spawn : $!\n";
        $expect->log_file("timeout.log","w+");
        $expect->expect(20,'<');
        $expect->expect(10,'Time');
       # $expect->send("\r");
        #$expect->expect(5,'<');
        $expect->send("quit;\r");
        $expect->soft_close();
 
}
   
node_conn;
system("/bin/cat timeout.log | /bin/grep Time");




if($?== 0) 
{
    #system("/bin/rm timeout.log ");
 print RFH "PASS : Time out is successful\n";
 # Te::tex "$TC", "\nINFO  :Time out is successful";
}

else 
{  
 print RFH "FAIL : Time out is not successful\n";
#  Te::tex "$TC", "\nERROR  : Time out is not successful";
    
}


close(RFH);
system("/bin/cat AXM_FT_Verification_of_the_eam_timeout_and_nodetime_BSCL.txt | /bin/grep FAIL ");
if ($? == 0)
{
print  "\nFAIL\n";
}
else
{
print "\nPASS\n";
unlink("AXM_FT_Verification_of_the_eam_timeout_and_nodetime_BSCL.txt");
}
#=======================================================================
#FRAME::end_frame "$TC";
