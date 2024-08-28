#!/use/bin/perl
#
# SCRIPT NAME:AXM_FT_Verify_mml_cmd_resp_in_sybase_ALL.pl
# Test Case & Priority:AXM_FT_Verify_mml_cmd_resp_in_sybase_ALL(Pr.1)
# Test Case No :8.1.3(common)
# AUTHOR: XJANTRI (Janmejay Tripathy)
# DATE  : 11-12-2013
# REV:
#
# Description :
# Prerequisites  :
# Return Value on Success : 0
# Return Value on Failure : 1
# Result File : /home/nmsadm/eam/results
#
# Usage :  bash RUNME -t AXM_FT_Verify_mml_cmd_resp_in_sybase_ALL.pl.
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
#FRAME::start_frame "$TC";
#======================================================================

open(RFH,">AXM_FT_Verify_mml_cmd_resp_in_sybase_ALL.txt");
print "Starting the Execution of test case\n";

verify_log_in_sybase("eacr_command_log");
verify_log_in_sybase("eacr_immediate_log");
verify_log_in_sybase("eacr_delayed_log");

##=======================================================================
#RAME::end_frame "$TC";
sub verify_log_in_sybase
{
	my $sybase_log_file = shift;
	
	@arr=("use tapdb\n","go\n", "select * from $sybase_log_file\n", "go\n");
	print @arr;
	open (MYFILE,'>sybase_query.sql');
	print MYFILE @arr;
	close(MYFILE);
	
	system("isql -Usa -Psybase11 -i sybase_query.sql -o sybase_output.log");
	
	if($?==0)
	{
		open (FH, "< sybase_output.log") or die $!;
		my @file_output=<FH>;
			
		if (($sybase_log_file==eacr_command_log) && grep(/command_str/,@file_output))
		{
			print RFH "PASS : eacr_command_log is proper...";
			#Te::tex "$TC", "INFO  : eacr_command_log is proper...";
		}
		elsif(($sybase_log_file==eacr_immediate_log) && grep(/immediate_response/,@file_output))
		{
			print RFH "PASS : eacr_immediate_log is proper...";
			#Te::tex "$TC", "INFO  : eacr_immediate_log is proper...";
		}
		elsif(($sybase_log_file==eacr_delayed_log) && grep(/delayed_response/,@file_output))
		{
			print RFH "PASS : eacr_delayed_log is proper...";
			#Te::tex "$TC", "INFO  : eacr_delayed_log is proper...";
		}
		else
		{
			print RFH "FAIL : Sybase logging is not proper...";
			#Te::tex "$TC", "ERROR  : Sybase logging is not proper...";
		#	FRAME::end_frame "$TC";
		}
		
		close(FH);
#		unlink("/home/nmsadm/eam/tmp/sybase_output.log");
	}
			
 #	else
#	{
#		print RFH "FAIL : Problem in sybase verification...";
	#	Te::tex "$TC", "ERROR  : Problem in sybase verification...";
		#FRAME::end_frame "$TC";
#	}
}
close(RFH);
	system("/bin/cat AXM_FT_Verify_mml_cmd_resp_in_sybase_ALL.txt | /bin/grep FAIL ");
	if ($? == 0)
	{
	print  	"\nFAIL\n";
	}
	else
	{
	print "\n PASS\n";
        }
