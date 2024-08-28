
#!/usr/bin/perl
#
# SCRIPT NAME:AXM_FT_EAM_ConnectDisconnect_MSCBCW.pl
# Test Case & Priority: AXM_FT_EAM_ConnectDisconnect_APG43_MSC-BC_R14_1  (Pr.1)
# Test Case No :
# AUTHOR:
# DATE  :
# REV:
#
# Description :
# Prerequisites  :
# Return Value on Success : 0
# Return Value on Failure : 1
# Result File : /home/nmsadm/eam/results
#
# Usage :  bash RUNME -t AXM_FT_EAM_ConnectDisconnect_MSCBCW.pl
#
# Dependency : Te.pm, crdmp.sh, PMSEerrorchk.sh
#
# REV HISTORY
# DATE:                           BY                                 MODIFICATION:
#
##########################################################

# DEFINE FILES AND VARIABLES HERE

use Expect;

#========================================================================
$ntwrk_element=$ARGV[0];
open(RFH,">AXM_FT_EAM_ConnectDisconnect_MSCBCW.txt");

my $res = 0;

my @diff_valid_connec = ("NE=$ntwrk_element");


print "Checking the cr_daemon for the given MSCBC node\n";
my $cr_daemon  = `/opt/ericsson/bin/eac_esi_config -ne $ntwrk_element | /bin/grep cr_daemon | /bin/cut -d "=" -f2`;
#$cr_daemon = util::trim $cr_daemon;  
chomp($cr_daemon); 
print"$cr_daemon\n";       
if($cr_daemon =~ /ehms_ac_in/)
{
print RFH "PASS  : cr daemon is valid for $ntwrk_element\n";
	
}
else
{
print RFH "FAIL  : cr daemon is not valid for $ntwrk_element\n";
	
}

print "Checking the protocol for the given MSCBC node\n";
my @proto = `/opt/ericsson/bin/cap_pdb_cat_map eac_esi_map|/bin/grep $ntwrk_element |/bin/head -1`;
if ( grep(/cr_protocol, s, "SSH_APG40"/,@proto) || grep(/cr_protocol, s, "TELNET_APG40"/,@proto)) 
{
   
 print RFH "PASS  : cr protocol is valid for $ntwrk_element\n";
              
}
else
{
print RFH "FAIL  : cr protocol is not valid for $ntwrk_element\n";
    
}

foreach $node (@diff_valid_connec) {	
		my $expect = Expect->new;
        my $command = "/opt/ericsson/bin/eaw $node";
        $expect->spawn($command) or die "Cannot spawn : $!\n";
        $expect->log_file("csl.log","w");
        $expect->expect(5,'<');
		$expect->send("ALLIP;\r");
		$expect->expect(15,'<');
		check_output($node,"ALLIP");
		#$expect->send("LABUP;\r");
		#check_output($node,"LABUP");
		$expect->expect(15,'<');
        $expect->send("EXIT;\r");
        $expect->soft_close();
}

#=======================================================================
#FRAME::end_frame "$TC";


sub check_output
{
        my $node = shift;
          chomp($node);
       # $node = util::trim $node;
           chomp($cmd);
	#	$cmd = util::trim $cmd;
           
        open (FH, "csl.log") or die $!;
		my @file_output=<FH>;
		if($cmd eq "ALLIP")
		{
			if ( grep(/ALARM LIST/,@file_output)) 
			{
                            print RFH "PASS  :Command output Successful for $node\n";
			}
			else
			{
                          print RFH "FAIL  :Command output unsuccessful for $node";
			
              
			}
		}
		
		
		
}
close(RFH);
system("/bin/grep FAIL AXM_FT_EAM_ConnectDisconnect_MSCBCW.txt");
if ($? == 0)
{
print  "\nFAIL\n";
}
else
{
print "\nPASS\n";
}
