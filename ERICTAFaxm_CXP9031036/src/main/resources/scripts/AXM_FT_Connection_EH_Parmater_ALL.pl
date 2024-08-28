#!/usr/bin/perl
#
# SCRIPT NAME:AXM_FT_Connection_EH_Parmater_ALL.pl
# Test Case & Priority: AXM_FT_Connection_EH_Parmater (Pr.1)
# Test Case No :10.1.5(common)
# AUTHOR:XNNNKKR
# DATE  :
# REV:
#
# Description :
# Prerequisites  :
# Return Value on Success : 0
# Return Value on Failure : 1
# Result File : /home/nmsadm/eam/results
#
# Usage :  bash RUNME -t AXM_FT_Connection_EH_Parmater_ALL.pl:ALL(types).
#
# Dependency : Te.pm, crdmp.sh, PMSEerrorchk.sh
#
# REV HISTORY
# DATE:                           BY                                 MODIFICATION:
#
##########################################################

# DEFINE FILES AND VARIABLES HERE
#use Te;
#use FRAME;
use Expect;
#use util;
#my $EAM_DIR    = $ENV{EAM_DIR};
#my $TC         = "AXM_FT_Connection_EH_Parmater_ALL";
#my $RESULT_DIR = $ENV{RESULT_DIR};
#my $TMP        = $ENV{TMP};

#$ENV{tc} = AXM_FT_Connection_EH_Parmater_ALL;
$ntwrk_element=$ARGV[0];#$ENV{ntwrk_element};

#FRAME::start_frame "$TC";
#======================================================================

my @arr1=("EH=16,AD=18","AD=17,EH=16");

open (RFH,">AXM_FT_Connection_EH_Parmater_ALL.txt"); 
    
foreach $node (@arr1)
{ 
  print "Establishing connection for $ntwrk_element\n";    
        my $expect = Expect->new;
       

        my $command = "/opt/ericsson/bin/eaw $ntwrk_element,$node";
        $expect->spawn($command) or die "Cannot spawn : $!\n";
        $expect->log_file("EH_Parameter.log","w");
	$expect->expect(5,'<');
        $expect->send("quit;\r");
        $expect->soft_close();
}
 
#@size_search = `/bin/egrep "AD-18\|AD-17" /home/nmsadm/eam/tmp/EH_Parameter.log`;

#system("/bin/cat /home/nmsadm/eam/tmp/EH_Parameter.log | grep AD-18 && grep AD-17");
#system("grep AD-18 /home/nmsadm/eam/tmp/EH_Parameter.log && grep AD-17 /home/nmsadm/eam/tmp/EH_Parameter.log");
system("/bin/grep AD- EH_Parameter.log");
#if ( scalar(@size_search) == 2  )
if ($? == 0) 
{    
    system("/bin/rm EH_Parameter.log");
	print RFH "PASS :  Connection is successful\n";
    
}
else 
{
    system("/bin/rm EH_Parameter.log");
	print RFH "FAIL : Connection is not successful\n"; 
    
}

close(RFH);
system("/bin/cat AXM_FT_Connection_EH_Parmater_ALL.txt | /bin/grep FAIL");
if($? == 0)
{
print "FAIL\n";
}
else
{
print "PASS\n";
#unlink("AXM_FT_Connection_EH_Parmater_ALL.txt");
}

#=======================================================================
#FRAME::end_frame "$TC";