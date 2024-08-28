#!/usr/bin/perl
#
# SCRIPT NAME:AXM_FT_Interactive_AP_Verification_ALL.pl
# Test Case & Priority: AXM_FT_Interactive_AP_Verification_ALL (Pr.1)
# Test Case No :
# AUTHOR: XJANTRI (Janmejay Tripathy)
# DATE  : 06/12/2013
# REV:1.0
#
# Description :Verifying the execution of interactive AP Command
# Prerequisites  :Node should be passed as an argument
# Return Value on Success : PASS
# Return Value on Failure : FAIL
# Usage :  /usr/local/bin/perl AXM_FT_Interactive_AP_Verification_ALL.pl.
#
# Dependency :Real node is required to run this usecase
#
# REV HISTORY
# DATE:                           BY                                 MODIFICATION:
#11/08/2014                     XNNNKKR                            Modifying scripts into TAF Compliant.
##########################################################


use Expect;
$ntwrk_element=$ARGV[0];
$str1 = "NOT ACCEPTED";

open(RFH,">AXM_FT_Interactive_AP_Verification_ALL.txt");

sub node_conn
{
	print "Establishing connection for $ntwrk_element\n";
        my $expect = Expect->new;
        my $command = "/opt/ericsson/bin/eaw $ntwrk_element";
        $expect->spawn($command) or die "Cannot spawn : $!\n";
        $expect->log_file("/home/nmsadm/ap_verification.log","w");
        $expect->expect(5,'<');
        $expect->send("aploc;\r");
        $expect->expect(5,'>');
	$expect->send("alogset -i yes\r");
	$expect->expect(5,'Enter y or n [default: n]:');
	$expect->send("n\r");
	$expect->expect(5,'>');
	$expect->send("alogset -i yes\r");
	$expect->expect(5,'Enter y or n [default: n]:');
	$expect->send("y\r");
	$expect->expect(5,'>');
}

sub condn_check
{

	my @arr = @_;
	if ( grep(/Not authorised/,@arr) || grep(/ERROR/,@arr) || grep(/NOT ACCEPTED/,@arr) || grep(/Command not found/,@arr))
	{
		print RFH "FAIL : Interective AP command failed";
	
    
	}
	else 
	{
		print RFH "PASS : Interective AP commands is working as expected";
  
	}
}

node_conn;

open (FPTR,"/home/nmsadm/ap_verification.log") || die "Can't Open File: $fname\n";
@filestuff = <FPTR>;
condn_check(@filestuff);
close (FPTR);

close(RFH);

system("/bin/cat AXM_FT_Interactive_AP_Verification_ALL.txt | /bin/grep FAIL ");

if ($? == 0)
{
	print  "\nFAIL\n";
}
else
{
	print "\nPASS\n";
}
