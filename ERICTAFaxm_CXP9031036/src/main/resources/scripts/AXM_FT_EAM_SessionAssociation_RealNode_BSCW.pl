#!/usr/bin/perl
#
# SCRIPT NAME:AXM_FT_EAM_SessionAssociation_RealNode_BSCW.pl
# Test Case & Priority: AXM_FT_EAM_SessionAssociation_EHIP_T And AXM_FT_EAM_SessionAssociation_EHIP_S (Pr.2)
# Test Case No :  5.3.18 AND 5.4.17 (Handler)
# AUTHOR: XJANTRI (Janmejay Tripathy)
# DATE  : 24\12\2013close(RFH);

# REV: A
#
################################ Description ##################################
# This test case verifies that commands and responses are associated with the #
# session in which they have been sent.                                       #
###############################################################################
# Prerequisites : crtest_env.sh, crtest
# Return Value on Success : 0
# Return Value on Failure : 1
# Result File : /home/nmsadm/eam/results
# Log File : 
# Usage :  bash RUNME -t AXM_FT_EAM_SessionAssociation_RealNode_BSCW.pl.
#
# Dependency : Te.pm, crdmp.sh, PMSEerrorchk.sh, crtest_env.sh, crtest
#
# REV HISTORY
# DATE:                           BY                                 MODIFICATION:
#
##########################################################

# DEFINE FILES AND VARIABLES HERE
use Expect;
$ntwrk_element=$ARGV[0];
open(RFH,">AXM_FT_EAM_SessionAssociation_RealNode_BSCW.txt");
#======================================================================

my $cr_protocol =
      `/opt/ericsson/bin/eac_esi_config -ne $ntwrk_element | /bin/grep "cr_protocol     = " | /bin/cut -d "=" -f2`;

#$cr_protocol =util::trim $cr_protocol;
chomp($$cr_protocol);
if (  $cr_protocol =~ 'TELNET\w+')
{
print RFH "PASS:Node $ntwrk_element using TELNET|TELNET_MTS protocol\n";
	#Te::tex "$TC","INFO  : Node $ntwrk_element using TELNET|TELNET_MTS protocol";
	test_case_run($ntwrk_element);
	
}
elsif (  $cr_protocol =~ 'SSH\w+')
{
print RFH "PASS:Node $ntwrk_element using SSH|SSH_MSS protocol\n";
	#Te::tex "$TC","INFO  : Node $ntwrk_element using SSH|SSH_MSS protocol";
	test_case_run($ntwrk_element);
}
else
{
print RFH "FAIL:Node $ntwrk_element is not using TELNET|TELNET_MTS|SSH|SSH_MSS protocol in EAC config file\n";	
#Te::tex "$TC", "ERROR  : Node $ntwrk_element is not using TELNET|TELNET_MTS|SSH|SSH_MSS protocol in EAC config file";
}

#=======================================================================
#FRAME::end_frame "$TC";

sub test_case_run
{
	my $node = 	$_[0];
	$archFlag = 0;
	$archFlag = 1   if(`arch`=~ /sparc/);
	
	if ($archFlag == 1)
	{
		print "Selecting sparc binary \n";
		check_file_exist("/home/nmsadm/eam/crtest");close(RFH);
system("/bin/grep FAIL AXM_FT_EAM_ConnectDisconnect_APG43_MSC-BC_R14_1.txt");
if ($? == 0)
{
print  "\nFAIL\n";
}
else
{
print "\nPASS\n";
unlink("AXM_FT_EAM_ConnectDisconnect_APG43_MSC-BC_R14_1.txt");
}
		check_file_exist("home/nmsadm/eam/crtest_env.sh");
		$cmd = "/home/nmsadm/eam/crtest_env.sh -n $node";
	}
	else
	{
		print "Selecting X86 binary \n";
		check_file_exist("/home/nmsadm/eam/crtest");
		check_file_exist("/home/nmsadm/eam/crtest_env.sh");
		$cmd = "/home/nmsadm/eam/crtest_env.sh -n $node";
	}
		
	$pid = fork();
	
	if ($pid == 0)
	{
		my $expect = Expect->new;
		
		$expect->log_file("AXM_FT_EAM_SessionAssos_1_EHIP.log","w+");
		$expect->spawn($cmd) or die "Cannot spawn : $!\n";
		$expect->expect(5,'<');
		
		open (FPTR,"AXM_FT_EAM_SessionAssos_1_EHIP.log") || die "Can't Open File: \n";
		@arr = <FPTR>;  #Read the file into an array
		close (FPTR);         #Close the file
	
		$prompt = $arr[$#arr];
			#print "prompt == ",$prompt;
				
		if ($prompt !~ $node)	
		{ 
			#Te::tex "$TC", "\nERROR : Node $node not connected sucessfully";
			 print RFH "FAIL:Node $node not connected sucessfully\n";
			$expect->soft_close();
			#FRAME::end_frame "$TC";
		} 
		else 
		{
		print RFH "PASS:Node $node connected sucessfully\n";	
                   #Te::tex "$TC", "\nINFO  : Node $node connected sucessfully.";
		}
			
		open(FILE, ">Assoc.log") or die "Could not open file: $!";
		print FILE "$prompt";
		close(FILE);
		
		$AssocID = `awk -F"(" '{print \$2}' Assoc.log | cut -d ")" -f1`;
		
		unlink("Assoc.log"); #Deleting the temporary Log file
			
		$expect->send("labup;\r");
		$expect->expect(5,'ORDERED');
		$expect->expect(5,'<');
			
		my $ordered = `cat AXM_FT_EAM_SessionAssos_1_EHIP.log | grep "ORDERED"`;
	
		#$ordered = util::trim $ordered;
                chomp($ordered);
		#print "ordered == ",$ordered;
		
		if ($ordered !~ "ORDERED")	
		{ 
			#Te::tex "$TC", "\nERROR : Immediate response \"ORDERED\" has not found.";
		        print RFH "FAIL:Immediate response \"ORDERED\" has not found\n";
			$expect->soft_close();
			#FRAME::end_frame "$TC";
		} 
		else 
		{
		 print RFH "PASS:Immediate response \"ORDERED\" has found successfully\n";	
                #Te::tex "$TC", "\nINFO  : Immediate response \"ORDERED\" has found successfully.";
		}
			
		$expect->send("w 60\r");
		$expect->expect(60,'<');
		$expect->soft_close();
		check_output_delayed($node,"labup");
	}
		
	else
	{
		my $expect = Expect->new;
		
		$expect->log_file("AXM_FT_EAM_SessionAssos_2_EHIP.log","w+");
		$expect->spawn($cmd) or die "Cannot spawn : $!\n";
		$expect->expect(5,'<');
		
		open (FPTR,"AXM_FT_EAM_SessionAssos_2_EHIP.log") || die "Can't Open File: \n";
		@arr = <FPTR>;  #Read the file into an array
		close (FPTR);         #Close the file
	
		$prompt = $arr[$#arr];
			#print "prompt == ",$prompt;
				
		if ($prompt !~ $node)	
		{ 
		#	Te::tex "$TC", "\nERROR : Node $node not connected sucessfully";
			print RFH "FAIL:Node $node not connected sucessfully\n";  
			$expect->soft_close();
			#FRAME::end_frame "$TC";
		} 
		else 
		{
                  print RFH "PASS:Node $node connected sucessfully\n";
			#Te::tex "$TC", "\nINFO  : Node $node connected sucessfully.";
		}
			
		open(FILE, ">Assoc.log") or die "Could not open file: $!";
		print FILE "$prompt";
		close(FILE);
		
		$AssocID = `awk -F"(" '{print \$2}' Assoc.log | cut -d ")" -f1`;
		
		unlink("Assoc.log"); #Deleting the temporary Log file
			
		$expect->send("labup;\r");
		$expect->expect(5,'ORDERED');
		$expect->expect(5,'<');
			
		my $ordered = `cat AXM_FT_EAM_SessionAssos_2_EHIP.log | grep "ORDERED"`;
	
		#$ordered = util::trim $ordered;
                chomp($ordered);
		#print "ordered == ",$ordered;
		
		if ($ordered !~ "ORDERED")	
		{ 
		#	Te::tex "$TC", "\nERROR : Immediate response \"ORDERED\" has not found.";
		  print RFH "FAIL: Immediate response \"ORDERED\" has not found\n";
			$expect->soft_close();
		#	#FRAME::end_frame "$TC";
		} 
		else 
		{
               print RFH "PASS:Immediate response \"ORDERED\" has found successfully\n";
		#	Te::tex "$TC", "\nINFO  : Immediate response \"ORDERED\" has found successfully.";
		}
			
		$expect->send("w 60\r");
		$expect->expect(60,'<');
		$expect->soft_close();
		check_output_delayed($node,"labup");
			
	}
}

sub check_output_delayed
{
    my $node = shift;
    my $cmd = shift;
    chomp($node);
    chomp($cmd);
   # $node = util::trim $node;
    #$cmd = util::trim $cmd;
    open (FH, "<AXM_FT_EAM_SessionAssos_1_EHIP.log") or die $!;

    my @file_output=<FH>;
		
	close(FH);
	print "output contents are:@file_output\n";	
  #  if (grep(/ORDERED/,@file_output) && grep(/END/,@file_output) && grep(/</,@file_output))
  if (grep(/ORDERED/,@file_output))  
  {
        #Te::tex "$TC", "INFO  : Received proper delay response for the command $cmd from $node";
    print RFH "PASS:Received proper delay response for the command $cmd from $node\n";  
  }
    else
    {
print RFH "FAIL:Recieved delay response is not proper for the command $cmd from $node\n";      
  #Te::tex "$TC", "ERROR  : Recieved delay response is not proper for the command $cmd from $node";
			
		#FRAME::end_frame "$TC";
    }
}

sub check_file_exist
{
	my $file = $_[0];;
	
	if ( -e "$file" )	{
		# Te::tex "$TC", "INFO  : Required $file has been found.";
     print RFH "PASS: Required $file has been found\n";  
	
      }
	else	{
   print RFH "FAIL: Couldn't find $file the required xml file to process\n";
		 #Te::tex "$TC", "ERROR : Couldn't find $file the required xml file to process.";
		 #FRAME::end_frame "$TC";
	}
}
close(RFH);
system("/bin/grep FAIL AXM_FT_EAM_SessionAssociation_RealNode_BSCW.txt");
if ($? == 0)
{
print  "\nFAIL\n";
}
else
{
print "\nPASS\n";
#unlink("AXM_FT_EAM_SessionAssociation_RealNode_BSCW.txt");
}
