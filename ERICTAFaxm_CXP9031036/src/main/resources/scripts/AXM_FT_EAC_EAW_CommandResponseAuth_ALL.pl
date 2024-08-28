#!/use/bin/perl
#
# SCRIPT NAME:AXM_FT_EAC_EAW_CommandResponseAuth_ALL.pl
# Test Case & Priority: AXM_FT_EAC_EAW_CommandResponseAuth (Pr.1)
# Test Case No :6.1.13(common)
# AUTHOR:XNNNKKR
# DATE  :
# REV:
#
################################ Description ######################
#To check that the authority control can be turned off for command sending in an operation environment per NE.
###################################################################
# Prerequisites  :
# Return Value on Success : 0
# Return Value on Failure : 1
# Result File : /home/nmsadm/eam/results
#
# Usage :  bash RUNME -t AXM_FT_EAC_EAW_CommandResponseAuth_ALL.pl:all types of nodes.
#
# Dependency : Te.pm, crdmp.sh, PMSEerrorchk.sh
#
# REV HISTORY
# DATE:                           BY                                 MODIFICATION:
#
##########################################################

# DEFINE FILES AND VARIABLES HERE
#use Te;
#use FRAME;
use Expect;
#use util;
#my $EAM_DIR    = $ENV{EAM_DIR};
#my $TC         = "AXM_FT_EAC_EAW_CommandResponseAuth_ALL";
#my $RESULT_DIR = $ENV{RESULT_DIR};
#my $TMP        = $ENV{TMP};

#$ENV{tc} = AXM_FT_EAC_EAW_CommandResponseAuth_ALL;
$ntwrk_element=$ARGV[0];#ENV{ntwrk_element};

#FRAME::start_frame "$TC";
#======================================================================

open (RFH,">AXM_FT_EAC_EAW_CommandResponseAuth_ALL.txt");
system("/opt/ericsson/bin/eac_esi_config -ne $ntwrk_element -set cr_comm_auth 1 ");
sleep(3);

sub node_conn
{
print "Establishing connection for $ntwrk_element\n";    
        my $expect = Expect->new;
#	my $command = "/opt/ericsson/bin/eaw $ntwrk_element";
        my $command = "/opt/ericsson/bin/eaw $ntwrk_element";
        $expect->spawn($command) or die "Cannot spawn : $!\n";
        $expect->log_file("/home/nmsadm/ResponseAuth.log","w+");
        $expect->expect(5,'<');
        $expect->send("caclp;\r");
        $expect->expect(5,'<');
        $expect->send("quit;\r");
        $expect->soft_close();
 
}
   
node_conn;
system("/bin/cat /home/nmsadm/ResponseAuth.log | /bin/grep TIME");

if ( $? == 0 ) 
{
 system("/bin/rm /home/nmsadm/ResponseAuth.log");
	print RFH "PASS : Command Execution is successful\n";
}
else 
{
	print RFH "FAIL : Command Execution is not successful\n";
    
}

close(RFH);

system("/bin/cat AXM_FT_EAC_EAW_CommandResponseAuth_ALL.txt | /bin/grep FAIL ");
if ($? == 0)
{
print  "FAIL\n";
}
else
{
print "PASS\n";
#unlink("AXM_FT_EAC_EAW_CommandResponseAuth_ALL.txt");
}

#=======================================================================
#FRAME::end_frame "$TC";
