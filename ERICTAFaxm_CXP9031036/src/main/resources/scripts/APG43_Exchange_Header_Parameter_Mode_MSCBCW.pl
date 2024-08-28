#!/use/bin/perl
#!/usr/local/bin/expect
#
# SCRIPT NAME:AXM_FT_EAM_APG43_Exchange_Header_Parameter_Mode_MSCBCW.pl
# Test Case & Priority: AXM_FT_EAM_APG43_Exchange_Header_Parameter (Pr.1)
# Test Case No :5.8.3 (handler)
# AUTHOR:xraoshr
# DATE  :
# REV:
#
# Description :
# Prerequisites  :
# Return Value on Success : 0
# Return Value on Failure : 1
# Result File : /home/nmsadm/eam/logs
#
# Usage :  bash RUNME -t AXM_FT_EAM_APG43_Exchange_Header_Parameter_Mode_MSCBCW.pl:<node name>.
#
# Dependency : Te.pm, crdmp.sh, PMSEerrorchk.sh
#
# REV HISTORY
# DATE:     25022014                      BY       XROHAGR                    MODIFICATION:
#
##########################################################

# DEFINE FILES AND VARIABLES HERE
use Expect;
$ntwrk_element= $ARGV[0];
#my $EAM_DIR    = $ENV{EAM_DIR};
#my $TC         = "AXM_FT_EAM_APG43_Exchange_Header_Parameter_Mode_MSCBCW";
#my $RESULT_DIR = $ENV{RESULT_DIR};
#my $TMP        = $ENV{TMP};

#$ENV{tc} = AXM_FT_EAM_APG43_Exchange_Header_Parameter_Mode_MSCBCW;
#$ntwrk_element=$ENV{ntwrk_element};

#FRAME::start_frame "$TC";
#========================================================================
open(RFH,">>APG43_Exchange_Header_Parameter_Mode.txt");
print "Starting the execution of test\n";
# Added By XROHAGR
    my $user_id = 
      `eac_esi_config -ne $ntwrk_element | grep "user_id         = " | cut -d "=" -f2`;	
	#user_id =util::trim $user_id;
        chomp($user_id);
	
	my $cr_daemon =
      `eac_esi_config -ne $ntwrk_element | grep "cr_daemon       =" | cut -d "=" -f2`;
	##$_daemon =util::trim $cr_daemon;
	chomp($cr_daemon);
	
	if ( "$cr_daemon" eq "ehms_ac_in" && "$user_id" eq "netsim")	{
	print "node $ntwrk_element having cr_daemon value as $cr_daemon and user_id value as netsim. This TC should be execute with real node only\n";
		#Te::tex "$TC","INFO  : node $ntwrk_element having cr_daemon value as $cr_daemon and user_id value as netsim. This TC should be execute with real node only"; 
		#FRAME::end_frame "$TC";
	}


	print "Sending command for $ntwrk_element\n";    
        
	my $expect = Expect->new;
        my $command = "eaw NE=$ntwrk_element,EXPERT=1";
        $expect->spawn($command) or die "Cannot spawn : $!\n";
        $expect->log_file("tryexpect.log","w");
        $expect->expect(5,'<');
        $expect->send("exchhdron\r");
		$expect->expect(5,'<');
		check_output($ntwrk_element,"exchhdron");
		$expect->send("exchhdroff\r");
		$expect->expect(5,'<');
		check_output($ntwrk_element,"exchhdroff");
		$expect->send("EXIT;\r");
        $expect->soft_close();
		


#=======================================================================
#FRAME::end_frame "$TC";


sub check_output
{
        my $node = shift;
		my $cmd = shift;
	#	$node = util::trim $node;
	#$cmd = util::trim $cmd;
         chomp($node);
         chomp($cmd);
        open (FH, "tryexpect.log") or die $!;

        my @file_output=<FH>;
		#print "@file_output\n"; 
		if ($cmd eq 'exchhdron')
		{
		
			if ( grep(/EXCHANGE HEADERS ON/,@file_output))			
			{
  print RFH "PASS:Received proper response for the $cmd command from $node\n";
				#Te::tex "$TC", "INFO  : Received proper response for the $cmd command from $node";
              
			}
			else
			{
print RFH "FAIL:Response recieved is not proper for $cmd from $node\n";
				#Te::tex "$TC", "ERROR  : Response recieved is not proper for $cmd from $node";
              
			}
		}
		elsif ($cmd eq 'exchhdroff')
		{
			if ( grep(/EXCHANGE HEADERS OFF/,@file_output))
			{
    print RFH "PASS:Received proper response for $cmd command from $node\n";
			#	Te::tex "$TC", "INFO  : Received proper response for $cmd command from $node";
              
			}
			else
			{
   print RFH "FAIL:Response recieved is not proper for $cmd from $node\n";
			#	Te::tex "$TC", "ERROR  : Response recieved is not proper for $cmd from $node";
              
			}
		}
		close(FH);
}

close(RFH);
system("cat APG43_Exchange_Header_Parameter_Mode.txt|grep FAIL");
if($? == 0)
{
print "FAIL\n";
#system("rm tryexpect.log");
}
else
{
print "PASS\n";
system("rm tryexpect.log");
system("rm  APG43_Exchange_Header_Parameter_Mode.txt");
}

