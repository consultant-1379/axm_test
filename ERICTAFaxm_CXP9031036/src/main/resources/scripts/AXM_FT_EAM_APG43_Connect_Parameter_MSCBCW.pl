#!/usr/bin/perl
#
# SCRIPT NAME:AXM_FT_EAM_APG43_Connect_Parameter_MSCBCW.pl
# Test Case & Priority: AXM_FT_EAM_APG43_Connect_Parameter  (Pr.1)
# Test Case No : 5.8.4 (Handler)
# AUTHOR:
# DATE  :
# REV:
#
################################ Description ######################
#This test case checks that connectivity parameter options after adding APG43 with MSS-BC configuration.
###################################################################
# Prerequisites  :
# Return Value on Success : 0
# Return Value on Failure : 1
# Result File : /home/nmsadm/eam/logs
#
# Usage :  bash RUNME -t AXM_FT_EAM_APG43_Connect_Parameter_MSCBCW.pl:<node name>.
#
# Dependency : Te.pm, crdmp.sh, PMSEerrorchk.sh
#
# REV HISTORY
# DATE:                           BY                                 MODIFI/bin/catION:
#
##########################################################

# DEFINE FILES AND VARIABLES HERE
use Expect;

$ntwrk_element=$ARGV[0];#ENV{ntwrk_element};

#========================================================================

open(RFH,">AXM_FT_EAM_APG43_Connect_Parameter_MSCBCW.txt"); 
my $cpnames = `/opt/ericsson/bin/eac_ehms_config -ne $ntwrk_element |/bin/grep -i cpnames | /bin/cut -d "=" -f2`;
my $spx_name=" ";
my $cp_name=" ";
#$cpnames = echomp $cpnames;
my @cp_name=split (',', $cpnames);
print "array cpname=@cp_name\n";
foreach $name(@cp_name)  {
    if($name =~ /SPX/)
        {
                $spx_name = $name;
                last;
        }
}
foreach $name1(@cp_name) {
    if($name1 =~ /CP/)
        {
                $cp_name = $name1;
                last;
        }
}
#$cp_name = chomp $cp_name;
#$spx_name = chomp $spx_name;
print "spx name =$spx_name\n";
print "cp name =$cp_name\n";
my @diff_valid_connec = ("NE=$ntwrk_element","NE=$ntwrk_element,NODE=C","NE=$ntwrk_element,CPNAME=$cp_name,CSL=1","NE=$ntwrk_element,CPNAME=$spx_name,CSL=1","NE=$ntwrk_element,CPGROUP=ALLBC","NE=$ntwrk_element,CPNAME=$cp_name,SIDE=STANDBY","NE=$ntwrk_element,CPGROUP=ALLBC,CPNAME=$cp_name,EH=2","NE=$ntwrk_element,AD=8","NE=$ntwrk_element,EXPERT=1","NE=$ntwrk_element,EXPERT=0");

my @diff_invalid_connec = ("NE=$ntwrk_element,CPNAME=CP100,CSL=1","NE=$ntwrk_element,CPGROUP=ABC");
my $val_flag = 0;

foreach $node (@diff_valid_connec) {
        
                
 #               $node = chomp $node;
                print "Establishing connection for $node\n";    
        my $expect = Expect->new;
        my $command = "/opt/ericsson/bin/eaw $node";
        $expect->spawn($command) or die "Cannot spawn : $!\n";
        $expect->log_file("tryexpect.log","w");
        $expect->expect(10,'<');
        if($node eq "NE=$ntwrk_element,NODE=C")
                {
                        $expect->send("mml\r");
                        $expect->expect(5,'<');
                }
                $expect->send("EXIT;\r");
                $expect->soft_close();
                check_output($node,$val_flag);

}
foreach $node (@diff_invalid_connec) {
        
                my $val_flag = 1;
            #    $node = chomp $node;#util::trim $node;
                print "Sending command for $node\n";    
        my $expect = Expect->new;
        my $command = "/opt/ericsson/bin/eaw $node";
        $expect->spawn($command) or die "Cannot spawn : $!\n";
        $expect->log_file("tryexpect.log","w");
        $expect->expect(5,'<');
        $expect->soft_close();
                check_output($node,$val_flag);

}
#=======================================================================
#FRAME::end_frame "$TC";


sub check_output
{
        my $node = shift;
                my $val_flag = shift;
              #  $node = chomp $node;
               # $val_flag = chomp $val_flag;
        open (FH, "<tryexpect.log") or die $!;

        my @file_output=<FH>;
                #print "@file_output\n"; 
                if ( $val_flag == 0)
                {
                        if ( grep(/</,@file_output) || grep(/>/,@file_output)) 
                        {
				print RFH "PASS : Connection established for $node\n";
              
                        }
                else
                        {
				print RFH "FAIL : Cannot establish connection for $node\n";
              
                        }
                }
                else
                {
                        
                        if ( grep(/</,@file_output) || grep(/>/,@file_output)) 
                        {
				print RFH "PASS : Connection established for invalid $node\n";
              
                        }
                        else
                        {
				print RFH "FAIL : Connection not established for invalid $node\n";
              
                        }
                }
}
close(RFH);

system("/bin/cat AXM_FT_EAM_APG43_Connect_Parameter_MSCBCW.txt | /bin/grep FAIL ");
if ($? == 0)
{
print  "FAIL\n";
}
else
{
print "PASS\n";
}
