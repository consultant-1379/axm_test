#!/usr/bin/perl
#
# SCRIPT NAME:AXM_FT_EAM_ImmediateRespLog_EHIP_RealNode_BSCL.pl
# Test Case & Priority: AXM_FT_EAM_ImmediateRespLog_EHIP_T And AXM_FT_EAM_ImmediateRespLog_EHIP_S (Pr.2)
# Test Case No :  5.3.60 AND 5.4.49 (Handler)
# AUTHOR: XROHAGR
# DATE  : 26\12\2013
# REV: A
#
############################## Description ##############################
# Check that all logging parameters are set to "1" in eac_egi_map,      #
# eac_egi_config -ne <NE>.The command and immediate response are logged.#
#########################################################################
# Prerequisites : /home/nmsadm/eam/crtest_env.sh, /home/nmsadm/eam/crtest
# Return Value on Success : 0
# Return Value on Failure : 1
# Result File : /home/nmsadm/eam/results
# Usage :  bash RUNME -t AXM_FT_EAM_ImmediateRespLog_EHIP_RealNode_BSCL.pl:<node name>  
#
# Dependency : Te.pm, crdmp.sh, PMSEerrorchk.sh, /home/nmsadm/eam/crtest_env.sh, /home/nmsadm/eam/crtest
# OutPut Files: /home/nmsadm/eam/tmp/AXM_FT_EAM_ImmediateRespLog_EHIP.log, /home/nmsadm/eam/tmp/del.log, /home/nmsadm/eam/tmp/im.log
#
# REV HISTORY
# DATE:                           BY                                 MODIFICATION:
#
##########################################################

# DEFINE FILES AND VARIABLES HERE

use Expect;
$ENV{"SYBASE"}="/opt/sybase/sybase";
$ENV{"SYBASE_OCS"}="/OCS-15_0";
$ENV{"SYBASE_ASE"}="/ASE-15_0";
$ENV{"LD_LIBRARY_PATH"}="$ENV{SYBASE}/OCS-15_0/lib";
$SYBASE=$ENV{"SYBASE"};
$SYBASE_OCS=$ENV{"SYBASE_OCS"};

open(RFH,">/home/nmsadm/script/AXM_FT_EAM_ImmediateRespLog_EHIP_RealNode_BSCL.txt");
$ntwrk_element=$ARGV[0];
#$node = $ntwrk_element;
#======================================================================

my $cr_protocol =
      `/opt/ericsson/bin/eac_esi_config -ne $ntwrk_element | /bin/grep "cr_protocol     = " | /bin/cut -d "=" -f2`;

#$cr_protocol =util::trim $cr_protocol;
#chomp($cr_protocol);
if (  $cr_protocol =~ 'TELNET\w+')
{        
     print RFH "PASS:Node $ntwrk_element using TELNET|TELNET_MTS protocol\n";
	#Te::tex "$TC","INFO  : Node $ntwrk_element using TELNET|TELNET_MTS protocol";
   
	node_conn($ntwrk_element);
	
}
elsif (  $cr_protocol =~ 'SSH\w+')
{
#print RFH "\n";
	#Te::tex "$TC","INFO  : Node $ntwrk_element using SSH|SSH_MSS protocol";
      print RFH "PASS:Node $ntwrk_element using SSH|SSH_MSS protocol\n";
	node_conn($ntwrk_element);
}
else
{
print RFH "FAIL:Node $ntwrk_element is not using TELNET|TELNET_MTS|SSH|SSH_MSS protocol in EAC config file\n";
	#Te::tex "$TC", "ERROR  : Node $ntwrk_element is not using TELNET|TELNET_MTS|SSH|SSH_MSS protocol in EAC config file";
}

#=======================================================================
#FRAME::end_frame "$TC";

sub node_conn
{
		my $node = $_[0];
		$archFlag = 0;
		$archFlag = 1   if(`arch`=~ /sparc/);
		
		if ($archFlag == 1)
		{
			print "Selecting sparc binary \n";
		}
		else
		{
			print "Selecting X86 binary \n";
		}
	        
        check_file_exist("/home/nmsadm/eam/crtest");
        check_file_exist("/home/nmsadm/eam/crtest_env.sh");
	$cmd = "/home/nmsadm/eam/crtest_env.sh -n $ntwrk_element";	
	print "Connecting the node $node ...\n";
		
        my $expect = Expect->new;
		
        $expect->log_file("AXM_FT_EAM_ImmediateRespLog_EHIP.log","w+");
		
        $expect->spawn($cmd) or die "Cannot spawn : $!\n";
		$expect->expect(5,'<');
		
		open (FPTR,"AXM_FT_EAM_ImmediateRespLog_EHIP.log") || die "Can't Open File: \n";
		@arr = <FPTR>;  #Read the file into an array
		close (FPTR);         #Close the file
	
		$prompt = $arr[$#arr];
		#print "prompt == ",$prompt;
				
		if ($prompt !~ $node)	
		{ 
			 # Te::tex "$TC", "\nERROR : Node $node not connected sucessfully";
			  print RFH "FAIL: Node $node not connected sucessfully\n";
			  $expect->soft_close();
			 # FRAME::end_frame "$TC";
		} 
		else 
		{
			# Te::tex "$TC", "\nINFO  : Node $node connected sucessfully.";
                       print RFH "PASS:Node $node connected sucessfully\n";
		}
		
		open(FILE, ">Assoc.log") or die "Could not open file: $!";
        print FILE "$prompt";
        close(FILE);
		
        $AssocID = `/usr/bin/awk -F"(" '{print \$2}' Assoc.log | /usr/bin/cut -d ")" -f1`;
		
		unlink("Assoc.log"); #Deleting the temporary Log file
		#print "AssocID ===", $AssocID;
				
		$expect->send("mode manual\r");
		$expect->expect(5,'`$ntwrk_element`\(`$AssocID`\)<');
		
		$expect->send("syrip;\r");
		#$expect->send("labup;\r");
		
		$expect->expect(5,'ORDERED');
		$expect->expect(5,'`$ntwrk_element`\(`$AssocID`\)<');
		
		my $ordered = `/usr/bin/cat AXM_FT_EAM_ImmediateRespLog_EHIP.log | /usr/bin/grep "ORDERED"`;
		
		#$ordered = util::trim $ordered;
       #         chomp($ordered);
		#print "ordered == ",$ordered;
		
		if ($ordered !~ "ORDERED")	
		{ 
			  #Te::tex "$TC", "\nERROR : Immediate response \"ORDERED\" has not found.";
     print RFH "FAIL : Immediate response \"ORDERED\" has not found\n";
			  
			  $expect->soft_close();
			  #FRAME::end_frame "$TC";
		} 
		else 
		{
			
    print RFH "PASS:Immediate response \"ORDERED\" has found successfully\n";
		}
		
		$expect->send("w 60\r");
		$expect->expect(60,'`$ntwrk_element`\(`$AssocID`\)<');
		
		check_output_delayCommand($node,"syrip");
#		check_output_delayCommand($node,"labup");
		
		$expect->log_file("im.log","w+");
		$expect->send("view im\r");
		$expect->expect(10,'`$ntwrk_element`\(`$AssocID`\)<');
				
		$expect->log_file("del.log","w+");		
		$expect->send("view del\r");
		$expect->expect(10,'`$ntwrk_element`\(`$AssocID`\)<');
		
		$expect->soft_close();
		
		#print "AssocID = $AssocID \n";
	
		my @checkAssocIDforIM = `/usr/bin/cat im.log | /usr/bin/grep "Assoc :" |/bin/awk '{print \$3}'`;
		
		#print "checkAssocIDforIM = @checkAssocIDforIM \n";
		
		my $flagAssocIDforIM = 0;
		foreach my $var (@checkAssocIDforIM){
		$flagAssocIDforIM = 1 if(`$AssocID` == `$var`);
		}
		
		#print "flagAssocIDforIM = $flagAssocIDforIM \n)";
		
		if ($flagAssocIDforIM == 1) 
        {
print RFH "PASS : Recieved immediate response has been logged for Assoc $AssocID successfully in file im.log\n";
			#Te::tex "$TC", "INFO  : Recieved immediate response has been logged for Assoc $AssocID successfully in file $TMP/im.log";
   
        }
        else
        {
		    #Te::tex "$TC", "ERROR  : Recieved immediate response has not been logged for Assoc $AssocID successfully in file $TMP/im.log";
print RFH "FAIL : Recieved immediate response has not been logged for Assoc $AssocID successfully in file im.log\n";
			#FRAME::end_frame "$TC";
        }
		
		my @checkAssocIDforDel = `/bin/cat del.log | /bin/grep "Assoc :" |/bin/awk '{print \$3}'`;
		
		#print "checkAssocIDforDel = @checkAssocIDforDel \n";
		
		my $flagAssocIDforDel = 0;
		foreach my $var (@checkAssocIDforDel){
		$flagAssocIDforDel = 1 if(`$AssocID` == `$var`);
		}
		
		#print "flagAssocIDforDel = $flagAssocIDforDel \n)";
		
		if ($flagAssocIDforDel == 1) 
        {
		#	Te::tex "$TC", "INFO  : Recieved delay response has been logged for Assoc $AssocID successfully in file $TMP/del.log";
print RFH "PASS: Recieved delay response has been logged for Assoc $AssocID successfully in file del.log\n";
        }
        else
        {
print RFH "FAIL: Recieved delay response has not been logged for Assoc $AssocID successfully del.log\n";
		 #   Te::tex "$TC", "ERROR  : Recieved delay response has not been logged for Assoc $AssocID successfully $TMP/del.log";
        }
}

sub check_output_delayCommand
{
	my $node = shift;
        my $cmd = shift;
#        chomp($node);
#        chomp($cmd);
        #$node = util::trim $node;
       # $cmd = util::trim $cmd;
        open (FH, "<AXM_FT_EAM_ImmediateRespLog_EHIP.log") or die $!;

        my @file_output=<FH>;
		
		close(FH);
		
        if (grep(/ORDERED/,@file_output) && grep(/END/,@file_output) && grep(/</,@file_output))
        {
            #Te::tex "$TC", "INFO  : Received proper delay response for the command $cmd from $node";
print RFH "PASS:  Received proper delay response for the command $cmd from $node\n";
        }
        else
        {
            #Te::tex "$TC", "ERROR  : Recieved delay response is not proper for the command $cmd from $node";
 print RFH "FAIL: Recieved delay response is not proper for the command $cmd from $node\n";
		#	FRAME::end_frame "$TC";
        }
}

#Method for Checking the file Exist or Not...
sub check_file_exist
{
	my $file = $_[0];
	
	if ( -e "$file" )	{
           print RFH " PASS:Required $file has been found\n";
		 #Te::tex "$TC", "INFO  : Required $file has been found.";
	}
	else	{
            print RFH "FAIL:Couldn't find $file the required file to process\n";
		 #Te::tex "$TC", "ERROR : Couldn't find $file the required file to process.";
		# FRAME::end_frame "$TC";
	}
}
close(RFH);
system("/bin/grep FAIL /home/nmsadm/script/AXM_FT_EAM_ImmediateRespLog_EHIP_RealNode_BSCL.txt");
if ($? == 0)
{
print  "\nFAIL\n";
}
else
{
print "\nPASS\n";
#unlink("/home/nmsadm/AXM_FT_EAM_ImmediateRespLog_EHIP_RealNode_BSCL.txt");
}
