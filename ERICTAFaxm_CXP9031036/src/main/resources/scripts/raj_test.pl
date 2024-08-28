#!/usr/bin/perl
#---------------------#
#  PROGRAM:  argv.pl  #
#---------------------#

$numArgs = $#ARGV + 1;
#print "We have $numArgs nodes as an arguments:\n";
#print "$ARGV[$argnum]\n";

#====================================
#foreach $argnum (0 .. $#ARGV) {
#  print "$ARGV[$argnum]\n";
#print "Fail";
	
#}
#==================================
use Expect;

$TMP="/home/nmsadm";
#!/usr/bin/bash
#!/usr/local/bin/expect 
print "$ARGV[0]\n";
$ntwrk_element= $ARGV[0];
print "The network element is:$ntwrk_element\n";

my $expect = Expect->new;
my $command = "/opt/ericsson/bin/eaw $ntwrk_element";
$expect->spawn($command) or die "Cannot spawn : $!\n";
$expect->log_file("$TMP/connect_disconnect.log","w");
$expect->expect(5,'<');
$expect->send("ALLIP;\r");
$expect->expect(10,'<');
$expect->send("quit;\r");
$expect->soft_close();
#check_output($ntwrk_element,"ALLIP");


system("cat $TMP/connect_disconnect.log|grep FAIL");

if($? == 0)
{
print "Test case:FAILED";
}
else
{
print"Test case:PASSED";
}



