#!/usr/bin/perl
#
# SCRIPT NAME:AXM_FT_EAM_CommandResponseLog_EHIP_BSCW.pl
# Test Case & Priority: AXM_FT_EAM_CommandResponseLog_EHIP_T And AXM_FT_EAM_CommandResponseLog_EHIP_S (Pr.2)
# Test Case No :  5.3.59 AND 5.4.48 (Handler)
# AUTHOR: XHARCHA
# DATE  : 18\12\2013
# REV: A
#
################################ Description ######################
#This verifies logging of events and command/responses.
###################################################################
# Prerequisites : crtest_env.sh, crtest
# Return Value on Success : 0
# Return Value on Failure : 1
# Result File : /home/nmsadm/eam/results
# Log File : /home/nmsadm/eam/tmp/alarm.log
# Usage :  bash RUNME -t AXM_FT_EAM_CommandResponseLog_EHIP_BSCW.pl.
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

open(RFH,">AXM_FT_EAM_CommandResponseLog_EHIP_BSCW.txt");
`/opt/ericsson/bin/eac_esi_config -ne $ntwrk_element -set conn_idle_to 1800`;
sleep(10);
my $cr_protocol =
      `/opt/ericsson/bin/eac_esi_config -ne $ntwrk_element | /bin/grep "cr_protocol     = " | /bin/cut -d "=" -f2`;

chomp($cr_protocol);
if (  $cr_protocol =~ 'TELNET\w+')
{
	print RFH "PASS : Node $ntwrk_element using TELNET|TELNET_MTS protocol\n";
	node_conn($ntwrk_element);
	
}
elsif (  $cr_protocol =~ 'SSH\w+')
{
	print RFH "PASS : Node $ntwrk_element using SSH|SSH_MSS protocol\n";
	node_conn($ntwrk_element);
}
else
{
	print RFH "FAIL : Node $ntwrk_element is not using TELNET|TELNET_MTS|SSH|SSH_MSS protocol in EAC config file\n";
}

#=======================================================================

sub node_conn
{
		my $node =$_[0];
		print $_[0];
		$archFlag = 0;
		$archFlag = 1   if(`arch`=~ /sparc/);
		
		if ($archFlag == 1)
		{
			print "Selecting sparc binary \n";
			check_file_exist("/home/nmsadm/eam/crtest");
			check_file_exist("/home/nmsadm/eam/crtest_env.sh");
			$cmd = "/home/nmsadm/eam/crtest_env.sh -n $node";
		}
		else
		{
			print "Selecting X86 binary \n";
			check_file_exist("/home/nmsadm/eam/crtest");
			check_file_exist("/home/nmsadm/eam/crtest_env.sh");
			$cmd = "/home/nmsadm/eam/crtest_env.sh -n $node";
		}
		
		print "Connecting the node $node ...\n";
		
        my $expect = Expect->new;
		
        $expect->log_file("/home/nmsadm/eam/tmp/AXM_FT_EAM_CommandRespLog_EHIP.log","w+");
		
        $expect->spawn($cmd) or die "Cannot spawn : $!\n";
		$expect->expect(10,'<');
		
		open (FPTR,"/home/nmsadm/eam/tmp/AXM_FT_EAM_CommandRespLog_EHIP.log") || die "Can't Open File: \n";
		@arr = <FPTR>;  #Read the file into an array
		close (FPTR);         #Close the file
	
		$prompt = $arr[$#arr];
		#print "prompt == ",$prompt;
				
		if ($prompt !~ $node)	
		{ 
			print RFH "FAIL : Node $node not connected sucessfully\n";
			  
			  $expect->soft_close();
		} 
		else 
		{
			print RFH "PASS : Node $node connected sucessfully.\n";
		}
		
		open(FILE, ">/home/nmsadm/eam/tmp/Assoc.log") or die "Could not open file: $!";
        print FILE "$prompt";
        close(FILE);
		
        $AssocID = `/bin/awk -F"(" '{print \$2}' /home/nmsadm/eam/tmp/Assoc.log | /bin/cut -d ")" -f1`;
	#commentes unlink just for testing	
		#unlink("/home/nmsadm/eam/tmp/Assoc.log"); #Deleting the temporary Log file
				
sleep(10);		
		$expect->send("labup;\r");
		$expect->expect(5,'ORDERED');
		$expect->expect(5,'<');
		
		
		my $ordered = `/bin/cat /home/nmsadm/eam/tmp/AXM_FT_EAM_CommandRespLog_EHIP.log | /bin/grep "ORDERED"`;
		
		chomp($ordered);
		#print "ordered == ",$ordered;
		
		if ($ordered !~ "ORDERED")	
		{ 
			print RFH "FAIL : Immediate response \"ORDERED\" has not found.\n";
			  
			  $expect->soft_close();
		} 
		else 
		{
			print RFH "PASS : Immediate response \"ORDERED\" has found successfully.";
		}
		
		$expect->send("w 60\r");
		$expect->expect(60,'<');
		
		
		check_output_delayCommand($node,"labup");

                $expect->send("cacap;\r");
		
		$expect->expect(5,'CALENDAR');
		$expect->expect(5,'<');
		
		
		my $calendar = `/bin/cat /home/nmsadm/eam/tmp/AXM_FT_EAM_CommandRespLog_EHIP.log | /bin/grep "CALENDAR"`;
		
		chomp($calendar);
		#print "ordered == ",$ordered;
		
		if ($calendar !~ "CALENDAR")	
		{ 
			print RFH "FAIL : Immediate response \"CALENDAR\" has not found.\n";
			  
			  $expect->soft_close();
		} 
		else 
		{
			print RFH "PASS :  Immediate response \"CALENDAR\" has found successfully.\n";
		}
                check_output_immediateCommand($node,"cacap");
				
		$expect->log_file("/home/nmsadm/eam/tmp/im.log","w+");
		
		$expect->send("view im\r"); 
		$expect->expect(5,'<');
		
		check_output_im($AssocID,"/home/nmsadm/eam/tmp/im.log");
		
		$expect->log_file("/home/nmsadm/eam/tmp/del.log","w+");
		
		$expect->send("view del\r");
		$expect->expect(5,'<');
		
		check_output_del($AssocID,"/home/nmsadm/eam/tmp/del.log");
		
		$expect->send("quit\r");
		$expect->expect(5,'<');
        $expect->soft_close();
}

sub check_output_del
{
	    my $AssocID = shift;
        my $file = shift;
        chomp($AssocID);
        chomp($file);
        open (FH, "<$file") or die $!;

        my @file_output=<FH>;
		close(FH);
        if (grep(/"Assoc : $AssocID"/,@file_output))
        {
		print RFH "FAIL : Recieved delay response has not been logged for Assoc $AssocID in file $file."; 
        }
        else
        {
		print RFH "PASS : Recieved delay response has been logged for Assoc $AssocID in file $file."; 
        }		
}

sub check_output_im
{
	    my $AssocID = shift;
        my $file = shift;
        chomp($AssocID);
        chomp($file);
        open (FH, "<$file") or die $!;

        my @file_output=<FH>;
		close(FH);
        if (grep(/"Assoc : $AssocID"/,@file_output) && grep(/"Cmd   : CACAP"/,@file_output))
        {
		print RFH "FAIL :  Recieved immediate response has not been logged for Assoc $AssocID in file $file. for the command CACAP";
        }
        else
        {
		print RFH "PASS : Recieved immediate response has been logged for Assoc $AssocID in file $file for the command CACAP";
        }
}

sub check_output_delayCommand
{
	    my $node = shift;
        my $cmd = shift;
        chomp($node);
        chomp($cmd);
       # open (FH, "<$TMP/AXM_FT_EAM_ImmediateRespLog_EHIP.log") or die $!;
        open (FH, "</home/nmsadm/eam/tmp/AXM_FT_EAM_CommandRespLog_EHIP.log") or die $!;

        my @file_output=<FH>;
		
		close(FH);
		
        if (grep(/ORDERED/,@file_output) && grep(/END/,@file_output) && grep(/</,@file_output))
        {
		print RFH "PASS : Received proper delay response for the command $cmd from $node\n";
        }
        else
        {
		print RFH "FAIL : Recieved delay response is not proper for the command $cmd from $node";
			
        }

}

sub check_output_immediateCommand
{
	    my $node = shift;
        my $cmd = shift;
        chomp($node);
        chomp($cmd);
       # open (FH, "<$TMP/AXM_FT_EAM_ImmediateRespLog_EHIP.log") or die $!;
        open (FH, "</home/nmsadm/eam/tmp/AXM_FT_EAM_CommandRespLog_EHIP.log") or die $!;

        my @file_output=<FH>;
		
		close(FH);
		
        if (grep(/CALENDAR/,@file_output) && grep(/END/,@file_output) && grep(/</,@file_output))
        {
		print RFH "PASS : Received proper Immediate response for the command $cmd from $node\n"; 
        }
        else
        {
		print RFH "FAIL : Recieved Immediate response is not proper for the command $cmd from $node\n";
        }

}

#Method for Checking the file Exist or Not...
sub check_file_exist
{
	my $file = $_[0];;
	
	if ( -e "$file" )	{
		print RFH "PASS : Required $file has been found.\n";1
	}
	else	{
		print RFH "FAIL : Couldn't find $file the required xml file to process.\n";
	}

}
close(RFH);

system("/bin/cat AXM_FT_EAM_CommandResponseLog_EHIP_BSCW.txt | /bin/grep FAIL ");
if ($? == 0)
{
print  "FAIL\n";
}
else
{
print "PASS\n";
}
