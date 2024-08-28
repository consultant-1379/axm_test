#!/usr/bin/perl 
#
# SCRIPT NAME:AXM_FT_EAM_CharacterConv_EHIP_BSCW.pl
# Test Case & Priority: AXM_FT_EAM_CharacterConv_EHIP_BSCW (Pr.3)
# Test Case No :  5.3.41  (Handler)
# AUTHOR: XHARCHA
# DATE  : 18\12\2013
# REV: A
#
################################ Description ######################
#This test case is to verify the Character conversion command. When CHARCASECONV is 
#turned on the command is converted to lower case
###################################################################
# Prerequisites : crtest_env.sh, crtest
# Return Value on Success : 0
# Return Value on Failure : 1
# Result File : /home/nmsadm/eam/results
# Log File : /home/nmsadm/eam/tmp/alarm.log
# Usage :  bash RUNME -t AXM_FT_EAM_CharacterConv_EHIP_BSCW.pl.
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
open(RFH,">AXM_FT_EAM_CharacterConv_EHIP_BSCW.txt");

system("/opt/ericsson/bin/eac_esi_config -ne $ntwrk_element -set conn_idle_to 1800");
#`/opt/ericsson/bin/eac_esi_config -ne $ntwrk_element -set conn_idle_to 1800`;
sleep(10);
$cmd = "/home/nmsadm/eam/crtest_env.sh -n $ntwrk_element";

my $expect = Expect->new;

$expect->log_file("AXM_FT_EAM_CharacterConv_EHIP_NODE.log","w+");

$expect->spawn($cmd) or die "Cannot spawn : $!\n";
		$expect->expect(5,'<');

		$expect->send("CHARCASECONV;\r");
		$expect->expect(5,'<');

		$expect->send("aploc;\r");
		$expect->expect(5,'>');

		$expect->send("SET MMLSYNTAX\r");
		$expect->expect(5,']');

		$expect->send("0\r");
		$expect->expect(5,'>');
#sleep(10);
		$expect->send("CPFls\r");
		$expect->expect(10,'>');
		sleep(20);
#		$search = `cat /home/nmsadm/eam/AXM_FT_EAM_CharacterConv_EHIP_NODE.log | /bin/grep "Not authorized"`;
#		print "searched item : $search";

#		if ($search)

#		{
#			Te::tex "$TC", "\n\nINFO  :  command is not converted to lower case letters and the command failed";

#		}
#		else
#		{
#			Te::tex "$TC", "\n\nERROR  : Failed, command converted to lower case with CASECONVER OFF\n";

#		}

		$expect->send("CHARCASECONV;\r");
		$expect->expect(5,'>');

		$expect->send("CPFls\r");
                $expect->expect(10,'>');

		$expect->send("quit\r");
		$expect->expect(10,'$');

		$search = `/bin/cat AXM_FT_EAM_CharacterConv_EHIP_NODE.log | /bin/grep "Not authorized"`;
#               print "searched item : $search";

                if ($search)

                {
			print RFH "PASS :  command is not converted to lower case letters and the command failed\n";

                }
                else
                {
			print RFH "FAIL : Failed, command converted to lower case with CASECONVER OFF\n";

                }

		
		$search1 = `/bin/cat AXM_FT_EAM_CharacterConv_EHIP_NODE.log | /bin/grep "CPF FILE TABLE"`;
		print "searched item : $search1";	
		if ($search1)

                {
			print RFH "PASS : command is not converted lower case letters and the command is sent correctly\n"; 


                }
                else
                {
			print RFH "FAIL : Failed, command NOT converted to lower case with CASECONVER ON\n";


                }

		$expect->soft_close();


close(RFH);

if(!-s AXM_FT_EAM_CharacterConv_EHIP_BSCW.txt)
{
	system("cat AXM_FT_EAM_CharacterConv_EHIP_BSCW.txt| /bin/grep FAIL ");
	if ($? == 0)
	{
		print  "FAIL\n";
	}
	else
	{
	print "PASS\n";
	}
}
else
{
	print "FAIL\n";
}
#=======================================================================
