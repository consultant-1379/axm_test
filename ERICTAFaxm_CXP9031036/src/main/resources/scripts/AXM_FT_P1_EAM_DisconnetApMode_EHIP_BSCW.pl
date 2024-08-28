#!/use/bin/perl
#
# SCRIPT NAME:AXM_FT_P1_EAM_DisconnetApMode_EHIP_BSCW.pl
# Test Case & Priority: AXM_FT_EAM_DisconnetApMode_EHIP_T, AXM_FT_EAM_DisconnetApMode_EHIP_S
# Test Case No :5.3.3, 5.4.4(Handler)
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
# Usage :  bash RUNME -t AXM_FT_P1_EAM_DisconnetApMode_EHIP_BSCW.pl:<BSCW node>
#
# Dependency : Te.pm, crdmp.sh, PMSEerrorchk.sh
#
# REV HISTORY
# DATE:                           BY                                 MODIFICATION:
#
##########################################################

# DEFINE FILES AND VARIABLES HERE

use Expect;
$ntwrk_element=$ARGV[0];
open(RFH,">AXM_FT_P1_EAM_DisconnetApMode_EHIP_BSCW.txt");
#========================================================================

print "Starting of Test Execution\n";

my $protocol=`/opt/ericsson/bin/eac_esi_config -ne $ntwrk_element | /bin/grep cr_protocol | /bin/cut -d "=" -f2`;
#$protocol = util::trim $protocol;
#chomp($protocol);

if ($protocol =~ /SSH_*/)
{        
        print "Protocol is SSH\n";
        print "Test Case is running against $ntwrk_element with SSH Protocol $protocol\n";
	
}
else
{
    print "Protocol is TELNET\n";
    print "Test Case is running against $ntwrk_element with TELNET Protocol $protocol\n";
	
}

  
 my $expect = Expect->new;
 my $command = "/opt/ericsson/bin/eaw $ntwrk_element";
 $expect->spawn($command) or die "Cannot spawn : $!\n";
 $expect->log_file("tryexpect.log","w");
 $expect->expect(50,'<');
 $expect->send("APLOC;\r");
 $expect->expect(10,'C:\>');
 check_output($ntwrk_element,"APLOC");
 $expect->send("exit\r");
 $expect->expect(10,'<');
 check_output($ntwrk_element,"exit");
 $expect->send("EXIT;\r");
 $expect->soft_close();
 

#=======================================================================
#FRAME::end_frame "$TC";


sub check_output
{
#       my $node = shift;
#	    my $cmd = shift;
#          chomp($node);       
#          chomp($cmd);
        #$node = util::trim $node;
		#$cmd = util::trim $cmd;
        open (FH, "<tryexpect.log") or die $!;
		my @file_output=<FH>;
		if($cmd eq "APLOC")
		{
			if ( grep(/C:\\\>/,@file_output) )
			{
		
                  print RFH "PASS :Received proper response for the command $cmd from $node\n";

              
			}
			else
			{
                  print RFH "FAIL :Response recieved is not proper for $cmd from $node\n";
			
                       }
		}
		elsif($cmd eq "exit")
		{
			if ( grep(/</,@file_output) )
			{
                           print RFH "PASS : Successfully exited from aploc mode for $node\n";
				
              
			}
			else
			{
		
                          print RFH "FAIL :Unsuccessfully exited from aploc mode for $node\n";
              
			}
		}
		close(FH);
}
close(RFH);
#system("/bin/grep FAIL AXM_FT_P1_EAM_DisconnetApMode_EHIP_BSCW.txt ");
system("/bin/cat AXM_FT_P1_EAM_DisconnetApMode_EHIP_BSCW.txt | /bin/grep FAIL ");
if ($? == 0)
{
print  "\nFAIL\n";
}
else
{
print "\nPASS\n";
#unlink("AXM_FT_P1_EAM_DisconnetApMode_EHIP_BSCW.txt");
}
