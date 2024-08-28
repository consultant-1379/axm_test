#!/usr/bin/perl
#
# SCRIPT NAME:AXM_FT_EAM_Exchangeheader_EHIP_BSCW.pl
# Test Case Name: AXM_FT_EAM_Exchangeheader_EHIP_T, AXM_FT_EAM_Exchangeheader_EHIP_S
# Test Case No : 5.3.5, 5.4.2(Handler)
# AUTHOR: XROHAGR
# DATE  : 20-01-2014
# REV: A
############################### Description ######################
# This tests the exchange header function for EHIP, Telnet.      #
# Exchange headers can be activated and deactivated by using the #
# commands "exchhdron;" and "exchhdroff;" respectively           #
##################################################################
# Prerequisites  :
# Return Value on Success : 0
# Return Value on Failure : 1
# Result File : /home/nmsadm/eam/logs
#
# Usage :  bash RUNME -t AXM_FT_EAM_Exchangeheader_EHIP_BSCW.pl:<node name>
#
# Dependency :
#
# REV HISTORY
# DATE:
# BY
# MODIFICATION:
#
##########################################################
# DEFINE FILES AND VARIABLES HERE

use Expect;

$ntwrk_element=$ARGV[0];#ENV{ntwrk_element};

#========================================================================
open(RFH,">/home/nmsadm/AXM_FT_EAM_Exchangeheader_EHIP_BSCW.txt");
print "Starting the Execution of test case\n";

	my $cr_protocol = `/opt/ericsson/bin/eac_esi_config -ne $ntwrk_element | /bin/grep cr_protocol | /bin/cut -d "=" -f2 |/bin/sed -e 's/^[ \t]*//'`;

	if ($cr_protocol =~ 'SSH*')
	{
		print "Protocol is SSH type \n";
		print RFH "PASS : Test Case is running against node $ntwrk_element with SSH protocol $cr_protocol";
		#Te::tex "$TC","INFO  : Test Case is running against node $ntwrk_element with SSH protocol $cr_protocol";
	}
	elsif ($cr_protocol =~ 'TELNET*')
	{
		print "Protocol is TELNET type \n";
		print RFH "PASS : Test Case is running against node $ntwrk_element with TELNET protocol $cr_protocol";
		#Te::tex "$TC","INFO  : Test Case is running against node $ntwrk_element with TELNET protocol $cr_protocol";
	}
	else
	{
		print "Protocol is neither TELNET nor SSH \n";
		print RFH "FAIL : Test Case is running against node $ntwrk_element with TELNET protocol $cr_protocol";
	#	Te::tex "$TC","ERROR  : Test Case is running against node $ntwrk_element with protocol $cr_protocol that is neither TELNET nor SSH";
		#FRAME::end_frame "$TC";
	}

	print "Establishing connection for node $ntwrk_element\n"; 

	my $expect = Expect->new;
	$expect->log_file("/home/nmsadm/eam/tryexpect1.log","w+");

	my $command = "/opt/ericsson/bin/eaw $ntwrk_element";
	#$expect->spawn($command)  or Te::tex "$TC", "\nERROR  : Cannot spawn : $!"; 
	#$expect->spawn($command)  or die print "ERROR  : Cannot spawn : $!\n";
	
	$expect->spawn($command)  or die "Cannot spawn : $!\n";
	
	$expect->expect(5,'<');
	
	$expect->send("exchhdron;\r");
	$expect->expect(10,'<');
			
	$expect->send("syrip;\r");
	$expect->expect(5,'ORDERED');
	$expect->expect(5,'<');
	$expect->send("\cD");
	sleep(20);
	$expect->send("\r");
	$expect->expect(5,'<');
	
	$expect->send("exchhdroff;\r");
	$expect->expect(10,'<');
	
	execute_cmd($ntwrk_element,"/home/nmsadm/eam/tryexpect2.log");
	
	$expect->send("exit;\r");
	$expect->soft_close();

	print "Disconnected from node $ntwrk_element successfully.\n";

	local $/ = undef;
	
	my $cmd = "/bin/tr -d '\r' < /home/nmsadm/eam/tryexpect1.log > /home/nmsadm/eam/tryexpect_bkp.log";
	my $returnCode = system("$cmd");
	
	#print "returnCode == $returnCode";
	
	if ( $returnCode != 0 )
	{
		print RFH "FAIL : $cmd Failed.";
		#Te::tex "$TC", "ERROR  : $cmd Failed.";
	#	FRAME::end_frame "$TC";
	}

	#`tr -d '\r' < /home/nmsadm/eam/tmp/tryexpect1.log > /home/nmsadm/eam/tmp/tryexpect_bkp.log`;

	print "Verifing the command output... \n";
	
	GetFileContentsIntoVariable();
	
	my $flag = 0;
	
	check_output("exchhdron;","(<exchhdron;\nEXCHANGE HEADERS ON).*");
	print RGH "PASS : Verifing the delayed response output when Exchange Headers ON.";	
	
	check_output("syrip;","(<syrip;\nORDERED).*");
	
	check_output("exchhdroff;","(<exchhdroff;\nEXCHANGE HEADERS OFF).*");
	
	unlink("/home/nmsadm/eam/tryexpect_bkp.log"); #Deleting the temporary Log file	
	
	my $cmd = "tr -d '\r' < /home/nmsadm/eam/tryexpect2.log > /home/nmsadm/eam/tryexpect_bkp.log";
	
	my $returnCode = system("$cmd");
	
	if ( $returnCode != 0 )
	{
		print RFH "FAIL : $cmd Failed.";
		#Te::tex "$TC", "ERROR  : $cmd Failed.";
		#FRAME::end_frame "$TC";
	}
	
	#`tr -d '\r' < $TMP/tryexpect2.log > $TMP/tryexpect_bkp.log`;
	
	GetFileContentsIntoVariable();
		print RFH "PASS : Verifing the delayed response output when Exchange Headers OFF.";	
	#Te::tex "$TC", "INFO  : Verifing the delayed response output when Exchange Headers OFF.";	

	check_output("syrip;","(syrip;\nORDERED).*");
		
	if ( $flag == 0 )
	{
		print RFH "PASS : Output for exchange header function is as per Expectation.";
		#Te::tex "$TC", "INFO  : Output for exchange header function is as per Expectation.";
	}
	else
	{
		print RFH "FAIL : Mismatch in the Actual and Expected Output for exchange header function.";
		#Te::tex "$TC", "ERROR  : Mismatch in the Actual and Expected Output for exchange header function.";
	}
	
	#Deleting the temporary Log files
	RemoveTemporaryLogFiles();
	
#=============================================================================================
#FRAME::end_frame "$TC";

#Method for Fetching log file data into Scalar variable
sub GetFileContentsIntoVariable
{
	$full_file_path = "/home/nmsadm/eam/tryexpect_bkp.log";
	open INFILE, $full_file_path or die "Could not open file. $!";
	$EntireFileContents =  <INFILE>;
	close INFILE;
}

sub execute_cmd
{
        my $node = shift;
        chomp($node);
		
		my $OutputFile = shift;
        chomp($OutputFile);
		
        $expect->log_file($OutputFile,"w");
		$expect->send("syrip;\r");
		$expect->expect(5,'ORDERED');
		$expect->expect(5,'<');
		$expect->send("\cD");
		sleep(20);
		$expect->send("\r");
		$expect->expect(5,'<');
}

sub check_output
{
	    #my $node = shift;
        my $CommandName = shift;
		
		my $PatternStr 	= shift;
        #$node = util::trim $node;
        chomp($CommandName);
		chomp($PatternStr);
		
		if ($EntireFileContents =~ /$PatternStr/s)
		{
				print RFH "PASS : $CommandName command executed successfully ...... \n";
			#  Te::tex "$TC", "INFO  : $CommandName command executed successfully ...... \n";
		}
		else
		{
			  $flag = 1;
			print RFH "FAIL : $CommandName command is not executed successfully ...... \n";
			#  Te::tex "$TC", "ERROR  : $CommandName command is not executed successfully ...... \n";
		}
}

#Method for Deleting the temporary Log files
sub RemoveTemporaryLogFiles
{
	unlink("/home/nmsadm/eam/tryexpect_bkp.log"); 
	unlink("/home/nmsadm/eam/tryexpect1.log"); 
	unlink("/home/nmsadm/eam/tryexpect2.log"); 
}
close(RFH);
system("/bin/cat /home/nmsadm/AXM_FT_EAM_Exchangeheader_EHIP_BSCW.txt | /bin/grep FAIL ");
if ($? == 0)
{
print  "\nFAIL\n";
}
else
{
print "\nPASS\n";
}
