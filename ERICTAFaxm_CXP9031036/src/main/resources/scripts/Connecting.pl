#!/usr/bin/perl
use Expect;

$numArgs = $#ARGV + 1;
print "We have $numArgs nodes as an arguments:\n";
print "$ARGV[$argnum]\n";
foreach $argnum (0 .. $#ARGV)
{
print "Node is:$ind";
chomp($ind);

$TMP="/home/nmsadm";
#!/bin/bash
#!/usr/local/bin/expect 
my $protocol = `/opt/ericsson/bin/eac_esi_config -ne $ind | /bin/grep cr_protocol | cut -d "=" -f2`;
print "$protocol\n";
my $expect = Expect->new;
my $command = "/opt/ericsson/bin/eaw $ind";
$expect->spawn($command) or die "Cannot spawn : $!\n";
$expect->log_file("/home/nmsadm/connect_disconnect.log","w");
$expect->expect(5,'<');
$expect->send("ALLIP;\r");
$expect->expect(10,'<');
$expect->send("quit;\r");
$expect->soft_close();
check_output($ind,"ALLIP");
}
sub check_output
{
        my $node = shift;
        my $cmd = shift;
        chomp($node);
        chomp($cmd);
       # $node = util::trim $node;
        #        $cmd = util::trim $cmd;

       open (FH, "/home/nmsadm/connect_disconnect.log") or die $!;
                my @file_output=<FH>;
                if($cmd eq "ALLIP")
                {

                        if (grep(/ALARM LIST/,@file_output) && grep(/^END/,@file_output))
                        {
                                print" PASS  : Command output Successful for $cmd for $node\n";
  # system("echo PASS >> /home/nmsadm/result.txt");
 #system("rm /home/nmsadm/connect_disconnect.log");

                        }
                        else
                        {
                                print "FAIL  : Command output unsuccessful for $cmd for $node\n";
  #system("echo FAIL >> /home/nmsadm/result.txt);

                        }
                }
		elsif($cmd eq "EXIT")
                {
                        if (grep(/Disconnected from $node/,@file_output) || grep(/LOGGED OFF/,@file_output))
                        {
                            print "PASS  : Command output Successful for $cmd for $node\n";
 #system("echo PASS >> /home/nmsadm/result.txt");

                        }
                        else
                        {
                                print "FAIL  : Command output unsuccessful for $cmd for $node\n";
 #system("FAIL >> /home/nmsadm/result.txt");

                        }
                }
             close(FH);
}
system("cat /home/nmsadm/connect_disconnect.log|grep FAIL");
if($? == 0)
{
print "Test case:FAILED";
}
else
{
print"Test case:PASSED";
}



