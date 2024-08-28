#!/use/bin/perl
#
# SCRIPT NAME:AXM_FT_EAM_NE_password_change_ALL.pl
# Test Case & Priority:AXM_FT_EAM_NE_password_change_ALL(Pr.2)
# Test Case No :6.19.14
# AUTHOR: XJANTRI (Janmejay Tripathy)
# DATE  : 11-12-2013
# REV:
#
########################## Description ####################################
# Check the EAM for changing NE password and verify that the Eaw/cha      #
# connection is happening with new password after EAM MC is warmrestarted.#
###########################################################################
# Prerequisites  :
# Return Value on Success : 0
# Return Value on Failure : 1
# Result File : /home/nmsadm/eam/results
#
# Usage :  bash RUNME -t AXM_FT_EAM_NE_password_change_ALL.pl.
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
open(RFH,">AXM_FT_EAM_NE_password_change_ALL.txt");
print "Starting the Execution of test case\n";
sub change_pswrd_warm_restart
{
		change_password($ntwrk_element);
#		EAM_MC_Start("warmrestart");
		connection_check($ntwrk_element);
		password_revert($ntwrk_element);
}

sub change_pswrd_cold_restart
{
		change_password($ntwrk_element);
		EAM_MC_Start("coldrestart");
		connection_check($ntwrk_element);
}

change_pswrd_warm_restart;
#change_pswrd_cold_restart;
#login_check_wrong_pswrd;



#======================================================================
#FRAME::end_frame "$TC";

sub change_password
{
		my $node = shift;
		$node_info = `/opt/ericsson/bin/pwAdmin -l $node | /bin/awk 'NR == 2 {print}'`;
		$org_pswrd = `/opt/ericsson/bin/pwAdmin -g $node_info`;
		chomp($org_pswrd);
		my $expect = Expect->new;
        my $command = "/opt/ericsson/bin/pwAdmin -changePw $node_info";
        $expect->spawn($command) or die "Cannot spawn : $!\n";
        $expect->log_file("/home/nmsadm/eam/tmp/NE_PW_Change.log","w+");
        $expect->expect(5,'Enter new password for netsim at $node:');
        $expect->send("nmsadm1\r");
        $expect->expect(5,'Retype new password for netsim at $node:');
        $expect->send("nmsadm1\r");
        $expect->expect(5,'>');
		check_output();
		$expect->soft_close();
}

sub EAM_MC_Start
{
		my $cmd_arg = shift;
		
		$scalar=`/opt/ericsson/nms_cif_sm/bin/smtool -l |/bin/grep eam`;
		my @val = split(' ', $scalar);

		for($i=0;$i<scalar(@val);$i=$i+2)
		{
			$var1[$j]=$val[$i];
			$j++;
		}
		my $EAM_MC_LIST = join " ", @var1;

		$cmd = `/opt/ericsson/nms_cif_sm/bin/smtool -$cmd_arg $EAM_MC_LIST -reason="other" -reasontext=" "`;
		print "Please wait for 10 sec, doing $cmd_arg...";
		#system("$cmd");
		check_output();
		sleep(10);
}

sub connection_check
{
		my $node = shift;
		my $expect = Expect->new;
		my $command = "/opt/ericsson/bin/eaw $node";
		$expect->spawn($command) or die "Cannot spawn : $!\n";
		$expect->log_file("/home/nmsadm/eam/tmp/tryexpect.log","w+");
        $expect->expect(5,'<');
        $expect->expect(5,'<');
        check_output();
}

sub check_output
{
        if ( $? == 0 ) {
	print RFH "PASS : Command executed successfully\n";
#                Te::tex "$TC", "\n\nINFO  : Command executed successfully\n";
        }
        else {
	print RFH "FAIL : Error reported in command execution\n";
              
        }
}

sub password_revert
{
		print "Reverting password to original.....\n";
		my $node = shift;
		my $expect = Expect->new;
		my $command = "/opt/ericsson/bin/pwAdmin -changePw $node_info";
        $expect->spawn($command) or die "Cannot spawn : $!\n";
        $expect->log_file("/home/nmsadm/eam/tmp/NE_PW_Change.log","w+");
        $expect->expect(5,'Enter new password for netsim at $node:');
        $expect->send("$org_pswrd\r");
        $expect->expect(5,'Retype new password for netsim at $node:');
        $expect->send("$org_pswrd\r");
        $expect->expect(5,'>');
		check_output();
		$expect->soft_close();
}
close(RFH);

system("/bin/cat AXM_FT_EAM_NE_password_change_ALL.txt | /bin/grep FAIL ");
if ($? == 0)
{
print  "\nFAIL\n";
}
else
{
print "\nPASS\n";
}
