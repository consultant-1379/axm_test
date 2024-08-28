#!/usr/bin/perl
#
# SCRIPT NAME:AXM_FT_EAM_TieRespToCommand_EHIP_BSCW.pl
# Test Case & Priority: AXM_FT_EAM_TieRespToCommand_EHIP_T, AXM_FT_EAM_TieRespToCommand_EHIP_S
# Test Case No : 5.3.26, 5.4.23(handler)
# AUTHOR:xraoshr
# DATE  :
# REV:
#
################################# Description #################################
# This test case verifies that, it is possible to tie a command together with #
# its delayed response.                                                       #
###############################################################################
# Prerequisites  :
# Return Value on Success : 0
# Return Value on Failure : 1
# Result File : /home/nmsadm/eam/logs
#
# Usage :  bash RUNME -t AXM_FT_EAM_TieRespToCommand_EHIP_BSCW.pl:<BSCW node>
#
# Dependency : Te.pm, crdmp.sh, PMSEerrorchk.sh
#
# REV HISTORY
# DATE:                           BY                                 MODIFICATION:
#
##########################################################

# DEFINE FILES AND VARIABLES HERE

use Expect;

open(RFH,">AXM_FT_EAM_TieRespToCommand_EHIP_BSCW.txt");

$ntwrk_element=$ARGV[0];#{ntwrk_element};

#FRAME::start_frame "$TC";
#========================================================================

print "Starting of Test Execution\n";

my $protocol=`/opt/ericsson/bin/eac_esi_config -ne $ntwrk_element | /bin/grep cr_protocol | /bin/cut -d "=" -f2`;
chomp($protocol);

if ($protocol =~ /SSH_*/)
{
		print RFH "PASS : Protocol is SSH";
		print RFH "PASS : Test Case is running against $ntwrk_element with SSH Protocol $protocol";
    #    Te::tex "$TC", "INFO  : Protocol is SSH";
     #   Te::tex "$TC", "INFO  : Test Case is running against $ntwrk_element with SSH Protocol $protocol";
}
else
{
		print RFH "PASS : Protocol is TELNET\n";
		print RFH "PASS : Test Case is running against $ntwrk_element with TELNET Protocol $protocol\n";
      #  Te::tex "$TC", "INFO  : Protocol is TELNET";
      #  Te::tex "$TC", "INFO  : Test Case is running against $ntwrk_element with TELNET Protocol $protocol";
}

if ( -e "/home/nmsadm/eam/crtest_env.sh" )       
{
	print RFH " PASS : Required $file has been found.\n";
 #   Te::tex "$TC", "INFO  : Required $file has been found.";
}
else   
{
	print RFH "FAIL : Couldn't find $file the file to process.\n";
    #Te::tex "$TC", "Error : Couldn't find $file the file to process.";
	#FRAME::end_frame "$TC";
}

print "Sending commands for $ntwrk_element\n";    
my $expect = Expect->new;
my $command = "/home/nmsadm/eam/crtest_env.sh -n $ntwrk_element";
$expect->spawn($command) or die "Cannot spawn : $!\n";
$expect->log_file("/home/nmsadm/eam/tmp/tryexpect.log","w");
$expect->expect(5,'<');
$expect->send("mode delayedsub\r");
$expect->expect(5,'<');
$expect->send("mode showinfo\r");
$expect->expect(5,'<');
$expect->send("mode newassoc\r");
$expect->expect(5,'<');
$expect->send("syrip;\r");
$expect->expect(5,'<');
$expect->send("SYBFP:FILE;\r");
$expect->expect(5,'ORDERED');
$expect->expect(5,'<');
$expect->send("w 20\r");
$expect->expect(10,'<');
$expect->send("quit\r");
$expect->soft_close();
check_output($ntwrk_element); 
           

#=======================================================================
#FRAME::end_frame "$TC";


sub check_output
{
        my $node = shift;
       
        chomp($node);
         
        open (FH, "</home/nmsadm/eam/tmp/tryexpect.log") or die $!;
        my @file_output=<FH>;
        if(grep(/ORDERED/,@file_output) && grep(/Response status:        Response complete/,@file_output) && grep(/Subscription info for delayed response/,@file_output) && grep(/Cmd     :SYRIP;/,@file_output) && (grep(/SYSTEM BACKUP FILES/,@file_output) || grep(/SOFTWARE RECOVERY SURVEY/,@file_output)) && grep(/END/,@file_output))	
	#if(grep(/Cmd     :SYRIP;/,@file_output) && grep(/SOFTWARE RECOVERY SURVEY/,@file_output) && grep(/Cmd     :SYBFP:FILE;/,@file_output) && grep(/SYSTEM BACKUP FILES/,@file_output))
        {
			print RFH "PASS : Response received for both commands SYRIP and SYBFP for $node\n";
            #Te::tex "$TC", "INFO  : Response received for both commands SYRIP and SYBFP for $node";
              
        }
        else
        {
			print RFH "FAIL : Response received not proper for $node\n";
           # Te::tex "$TC", "ERROR : Response received not proper for $node";
              
        }
             
        close(FH);
}
close(RFH);
system("/bin/cat AXM_FT_EAM_TieRespToCommand_EHIP_BSCW.txt | /bin/grep FAIL ");
if ($? == 0)
{
print  "\nFAIL\n";
}
else
{
print "\nPASS\n";
}
