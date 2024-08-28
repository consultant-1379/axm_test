#!/usr/bin/perl
#
# SCRIPT NAME:AXM_FT_Connection_of_MSCBC_clusterNode_with_AD_MSCBCW.pl
# Test Case & Priority: AXM_FT_Connection_of_MSCBC_clusterNode_with_AD (Pr.1)
# Test Case No :10.1.6(common)
# AUTHOR:XNNNKKR
# DATE  :
# REV:
#
################################ Description ######################
#To verify the connection of MSCBC(Windows,Linux) cluster node with AD parameter.
###################################################################
# Prerequisites  :
# Return Value on Success : 0
# Return Value on Failure : 1
# Result File : /home/nmsadm/eam/results
#
# Usage :  bash RUNME -t AXM_FT_Connection_of_MSCBC_clusterNode_with_AD_MSCBCW.pl:MSCBCwindows.
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
#my $TC         = "AXM_FT_Connection_of_MSCBC_clusterNode_with_AD_MSCBCW";
#my $RESULT_DIR = $ENV{RESULT_DIR};
#my $TMP        = $ENV{TMP};

#$ENV{tc} = AXM_FT_Connection_of_MSCBC_clusterNode_with_AD_MSCBCW;
$ntwrk_element=$ARGV[0];#$ENV{ntwrk_element};

#FRAME::start_frame "$TC";
#======================================================================


open(RFH,">AXM_FT_Connection_of_MSCBC_clusterNode_with_AD_MSCBCW.txt"); 

sub node_conn
{
print "Establishing connection for $ntwrk_element\n";    
        my $expect = Expect->new;
        my $command = "/opt/ericsson/bin/eaw $ntwrk_element,AD=110";
        $expect->spawn($command) or die "Cannot spawn : $!\n";
        $expect->log_file("Cluster_node_AD.log","w+");
        $expect->expect(5,'<');
        $expect->send("newdev=AD-50;\r");
        $expect->expect(5,'<');
        $expect->send("quit;\r");
        $expect->soft_close();
 
}
   
node_conn;
system("/bin/cat Cluster_node_AD.log | /bin/grep Dev-50");

if ( $? == 0 ) 
{
	print RFH "PASS : Device Switch is successful\n";
}
else 
{
	print RFH "FAIL : Device Switch is not successful\n";
    
}

close(RFH);
system("/bin/cat AXM_FT_Connection_of_MSCBC_clusterNode_with_AD_MSCBCW.txt | /bin/grep FAIL");
if($? == 0)
{
print "FAIL\n";
}
else
{
print "PASS\n";
#unlink("AXM_FT_Connection_of_MSCBC_clusterNode_with_AD_MSCBCW.txt");
}

#=======================================================================
#FRAME::end_frame "$TC";
