#!/usr/bin/perl
#
# SCRIPT NAME:AXM_FT_Verify_mml_commands_BSCL.pl
# Test Case & Priority: AXM_FT_Verify_mml_commands_BSCL (Pr.1)
# Test Case No :
# AUTHOR: XJANTRI (Janmejay Tripathy)
# DATE  : 06/12/2013
# REV:
#
# Description :
# Prerequisites  :
# Return Value on Success : 0
# Return Value on Failure : 1
# Result File : /home/nmsadm/eam/results
#
# Usage :  bash RUNME -t AXM_FT_Verify_mml_commands_BSCL.pl:<node1>:<node2>.
#
# Dependency : Te.pm, crdmp.sh, PMSEerrorchk.sh
#
# REV HISTORY
# DATE:                           BY                                 MODIFICATION:
#
##########################################################

# DEFINE FILES AND VARIABLES HERE

use Expect;
open(RFH,">AXM_FT_Verify_mml_commands_BSCL.txt");

$ntwrk_element=$ARGV[0];#ENV{ntwrk_element};


#========================================================================

print "Starting the Execution of test case\n";
print "Sending command for $ntwrk_element\n";
my $expect = Expect->new;
my $command = "/opt/ericsson/bin/eaw $ntwrk_element";
$expect->spawn($command) or die "Cannot spawn : $!\n";

sub imm_res_cmd
{

        $expect->log_file("tryexpect.log","w+");

                $expect->expect(5,'<');
        $expect->send("caclp;\r");
        $expect->expect(5,'<');
        check_output_imm($ntwrk_element,"caclp");

        $expect->send("LASIP:BLOCK=all;\r");
        $expect->expect(5,'<');
        check_output_imm($ntwrk_element,"LASIP:BLOCK=all;");

        $expect->send("ALLIP;\r");
        $expect->expect(5,'<');
        check_output_imm($ntwrk_element,"ALLIP");
}

sub cmd_labup
{
        $expect->log_file("tryexpect_labup.log","w+");

        $expect->send("LABUP;\r");
        $expect->expect(5,'ORDERED');
        $expect->expect(5,'<');
        $expect->send("\cD");
        sleep(20);
        $expect->send("\r");
        $expect->expect(5,'<');
        check_output_labup($ntwrk_element,"LABUP");
}

sub cmd_syrip
{
        $expect->log_file("tryexpect_syrip.log","w+");

                $expect->send("SYRIP;\r");
        $expect->expect(5,'ORDERED');
        $expect->expect(5,'<');
        $expect->send("\cD");
        sleep(20);
        $expect->send("\r");
        $expect->expect(5,'<');
        check_output_syrip($ntwrk_element,"SYRIP");
}

sub cmd_exhwc
{
        $expect->log_file("tryexpect_exhwc.log","w+");

                $expect->send("EXHWC;\r");
        $expect->expect(5,'ORDERED');
        $expect->expect(5,'<');
        $expect->send("\cD");
        sleep(20);
 #       $expect->send("\r");
        $expect->expect(5,'<');
        check_output_exhwc($ntwrk_element,"EXHWC");
}

sub cmd_sytuc
{
        $expect->log_file("tryexpect_sytuc.log","w+");

                $expect->send("SYTUC;\r");
                $expect->expect(5,'SYTUC;');
                $expect->expect(5,'<');
                $expect->send(";\r");
        $expect->expect(5,'ORDERED');
        $expect->expect(5,'<');
        $expect->send("\cD");
        sleep(10);
        $expect->send("\r");
        $expect->expect(5,'<');
        check_output_sytuc($ntwrk_element,"SYTUC;");
}

sub cmd_rest
{
        $expect->log_file("tryexpect_rest.log","w+");

                $expect->send("ALHBI;\r");
                $expect->expect(5,'ALHBI;');
                $expect->expect(5,'<');
                $expect->send(";\r");
        $expect->expect(5,'<');
                check_output_rest($ntwrk_element,"ALHBI;");

                $expect->send("ALHBE;\r");
                $expect->expect(5,'ALHBE;');
                $expect->expect(5,'<');
                $expect->send(";\r");
        $expect->expect(5,'<');
                check_output_rest($ntwrk_element,"ALHBE;");
}

imm_res_cmd;
#cmd_labup;
cmd_syrip;
#cmd_exhwc;
cmd_sytuc;
#cmd_rest;
        $expect->send("exit;\r");
        $expect->soft_close();

#=======================================================================


sub check_output_imm
{
            my $node = shift;
        my $cmd = shift;
        #chomp($node);
        #chomp($cmd);
        open (FH, "<tryexpect.log") or die $!;

        my @file_output=<FH>;

        if ($cmd eq "caclp")
        {
            if ( grep(/TIME/,@file_output) && grep(/END/,@file_output) &&  grep(/</,@file_output))
            {
                                print RFH "PASS :  Received proper response for $cmd from $node";

                        #       Te::tex "$TC", "INFO  : Received proper response for $cmd from $node";
            }
            else
            {
                                print RFH "FAIL : Response recieved is not proper from $node";
#Te::tex "$TC", "ERROR  : Response recieved is not proper from $node";
            }
        }

        elsif($cmd eq "ALLIP")
        {
                        if (grep(/ALARM LIST/,@file_output) && grep(/END/,@file_output) && grep(/</,@file_output))
            {

                print RFH "PASS :  Received proper response for $cmd from $node";
            }
            else
            {
                print RFH "FAIL : Response recieved is not proper from $node";
            }
        }

                else
        {
                    if (grep(/SOFTWARE UNIT IDENTITY/,@file_output) && grep(/END/,@file_output) && grep(/</,@file_output))
            {
               print RFH "PASS :  Received proper response for $cmd from $node";
            }
            else
            {
                print RFH "FAIL : Response recieved is not proper from $node";
            }
        }

                close(FH);
}

sub check_output_labup
{
            my $node = shift;
        my $cmd = shift;
        chomp($node);
        chomp($cmd);
        open (FH, "<tryexpect_labup.log") or die $!;

        my @file_output=<FH>;

        if (grep(/ORDERED/,@file_output) && grep(/END/,@file_output) && grep(/</,@file_output))
        {
            print RFH "PASS :  Received proper response for $cmd from $node";
        }
        else
        {
            print RFH "FAIL : Response recieved is not proper from $node";
        }

                close(FH);
}

sub check_output_syrip
{
            my $node = shift;
        my $cmd = shift;
        $node = chomp $node;
        $cmd = chomp $cmd;
        open (FH, "<tryexpect_syrip.log") or die $!;

        my @file_output=<FH>;

        if (grep(/ORDERED/,@file_output) && grep(/END/,@file_output) && grep(/</,@file_output))
        {
            print RFH "PASS :  Received proper response for $cmd from $node";
        }
        else
        {
            print RFH "FAIL : Response recieved is not proper from $node";
        }

                close(FH);
}

sub check_output_exhwc
{
            my $node = shift;
        my $cmd = shift;
        chomp($node);
        chomp($cmd);
        open (FH, "<tryexpect_exhwc.log") or die $!;

        my @file_output=<FH>;

        if (grep(/ORDERED/,@file_output) && grep(/END/,@file_output) && grep(/</,@file_output))
        {
           print RFH "PASS :  Received proper response for $cmd from $node";
        }
        else
        {
            print RFH "FAIL : Response recieved is not proper from $node";
        }

        close(FH);
}

sub check_output_sytuc
{
            my $node = shift;
        my $cmd = shift;
        $node = chomp $node;
        $cmd = chomp $cmd;
        open (FH, "<tryexpect_sytuc.log") or die $!;

        my @file_output=<FH>;

        if (grep(/ORDERED/,@file_output) && grep(/END/,@file_output) && grep(/</,@file_output))
        {
           print RFH "PASS :  Received proper response for $cmd from $node";
        }
        else
        {
            print RFH "FAIL : Response recieved is not proper from $node";
        }

                close(FH);
}

sub check_output_rest
{
            my $node = shift;
        my $cmd = shift;
        chomp($node);
        chomp($cmd);
        open (FH, "<tryexpect_rest.log") or die $!;

        my @file_output=<FH>;

        if ((grep(/EXECUTED/,@file_output) || grep(/FUNCTION ALREADY ACTIVATED/,@file_output)) && grep(/</,@file_output))
        {
            print RFH "PASS :  Received proper response for $cmd from $node";
        }
        else
        {
            print RFH "FAIL : Response recieved is not proper from $node";
        }

                close(FH);
}
close(RFH);
system("/bin/cat AXM_FT_Verify_mml_commands_BSCL.txt | /bin/grep FAIL ");
if ($? == 0)
{
print  "\nFAIL\n";
}
else
{
print "\nPASS\n";
}

