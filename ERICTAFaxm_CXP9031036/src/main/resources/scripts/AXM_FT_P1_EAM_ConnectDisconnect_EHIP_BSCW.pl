#!/use/bin/perl
#
# SCRIPT NAME:AXM_FT_P1_EAM_ConnectDisconnect_EHIP_BSCW.pl
# Test Case & Priority: AXM_FT_EAM_ConnectDisconnect_EHIP_T,AXM_FT_EAM_ConnectDisconnect_EHIP_S
# Test Case No : 5.3.1, 5.4.1 (Handler)
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
# Usage :  bash RUNME -t AXM_FT_P1_EAM_ConnectDisconnect_EHIP_BSCW.pl:<node names>
#
# Dependency : Te.pm, crdmp.sh, PMSEerrorchk.sh
#
# REV HISTORY
# DATE:                           BY                                 MODIFICATION:
#
##########################################################
$ntwrk_element=$ARGV[0];#ENV{ntwrk_element};
# DEFINE FILES AND VARIABLES HERE

use Expect;


#========================================================================
open(RFH,">AXM_FT_P1_EAM_ConnectDisconnect_EHIP_BSCW.txt");
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
$expect->log_file("connect_disconnect.log","w");
$expect->expect(5,'<');
$expect->send("ALLIP;\r");
$expect->expect(5,'<');
$expect->send("EXIT;\r");
#$expect->expect(5,'>');
$expect->soft_close();
check_output($ntwrk_element,"ALLIP");
#check_output($ntwrk_element,"EXIT");



sub check_output
{
        my $node = shift;
           
         my $cmd = shift;
      
           #chomp($node);
           #chomp($cmd);
        open (FH, "connect_disconnect.log") or die $!;
                my @file_output=<FH>;
                if($cmd eq "ALLIP")
                {

                        if (grep(/ALARM LIST/,@file_output) && grep(/^END/,@file_output))
                        {
                    print RFH "PASS:Command output Successful for $cmd for $node\n";

                        }
                        else
                        {
                             
  print RFH "FAIL:Command output unsuccessful for $cmd for $node\n";
                        }
                }
		elsif($cmd eq "EXIT")
                {
                        if (grep(/Disconnected from $node/,@file_output) || grep(/LOGGED OFF/,@file_output))
                        {
          
  print RFH "PASS:Command output Successful for $cmd for $node\n";

                        }
                        else
                        {
                               
  print RFH "FAIL:Command output unsuccessful for $cmd for $node\n";

                        }
                }
             close(FH);
}
close(RFH);
system("/bin/grep FAIL AXM_FT_P1_EAM_ConnectDisconnect_EHIP_BSCW.txt");
if ($? == 0)
{
print  "\nFAIL\n";
}
else
{
print "\nPASS\n";
unlink("AXM_FT_P1_EAM_ConnectDisconnect_EHIP_BSCW.txt");
}
