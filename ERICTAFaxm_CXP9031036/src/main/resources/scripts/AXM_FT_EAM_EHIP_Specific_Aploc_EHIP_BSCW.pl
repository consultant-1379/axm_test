#!/usr/bin/perl -w
#
# SCRIPT NAME:AXM_FT_EAM_EHIP_Specific_Aploc_EHIP_BSCW.pl
# Test Case & Priority:  AXM_FT_EAM_EHIP_Specific_Aploc_EHIP_T, AXM_FT_EAM_EHIP_Specific_Aploc_EHIP_S
# Test Case No :  5.3.10,5.4.11  (Handler)
# AUTHOR: XHARCHA
# DATE  : 18\12\2013
# REV: A
#
# Description : 
# Prerequisites : crtest_env.sh, crtest
# Return Value on Success : 0
# Return Value on Failure : 1
# Result File : /home/nmsadm/eam/results
# Log File : /home/nmsadm/eam/tmp/alarm.log
# Usage :  bash RUNME -t AXM_FT_EAM_EHIP_Specific_Aploc_EHIP_BSCW.pl.
#
# Dependency : Te.pm, crdmp.sh, PMSEerrorchk.sh, crtest_env.sh, crtest
#
# REV HISTORY
# DATE:                           BY                                 MODIFICATION:
#
##########################################################

# DEFINE FILES AND VARIABLES HERE
use Expect;
$ntwrk_element=$ARGV[0];#ENV{ntwrk_element};

#======================================================================



open(RFH,">>AXM_FT_EAM_EHIP_Specific_Aploc_EHIP_BSCW.txt");
#$cmd = "/home/nmsadm/eam/crtest_env.sh -n $ntwrk_element";

my $expect = Expect->new;

#$expect->log_file("$/home/nmsadm/eam/tmp/AXM_FT_EAM_CharacterConv_EHIP_NODE.log","w+");

$expect->spawn("/opt/ericsson/bin/eaw $ntwrk_element") or die "Cannot spawn : $!\n";
		$expect->expect(5,'<');

		$expect->send("aploc;\r");
                $expect->expect(5,'>');
		if( $? == 0 )
		{
			print RFH "PASS : Aploc command executed successfuly";
		}
		else
		{
			print RFH "FAIL : Aploc command Failed";
		}
		
		$expect->send("quit\r");
                $expect->expect(10,'$');

		$expect->soft_close();


#=======================================================================
close(RFH);

system("/bin/cat AXM_FT_EAM_EHIP_Specific_Aploc_EHIP_BSCW.txt | /bin/grep FAIL ");
if ($? == 0)
{
print  "FAIL\n";
}
else
{
print "PASS\n";
unlink("AXM_FT_EAM_EHIP_Specific_Aploc_EHIP_BSCW.txt");
}

