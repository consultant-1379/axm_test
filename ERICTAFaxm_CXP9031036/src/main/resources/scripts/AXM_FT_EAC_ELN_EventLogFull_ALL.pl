#!/usr/bin/perl
# SCRIPT NAME:AXM_FT_EAC_ELN_EventLogFull_ALL.pl
# Test Case & Priority: AXM_FT_EAC_ELN_EventLogFull(Pr.2)
# Test Case No :6.6.3 (common)
# AUTHOR:XRAOSHR
# DATE  :10/10/2013
# REV:1.0
#
# Description :Verifying the event logging mechanism while connecting to the node.
# Return Value on Success : PASS
# Return Value on Failure : FAIL

#
# Usage :  /usr/local/bin/perl AXM_FT_EAC_ELN_EventLogFull_ALL.pl <node_name>
#
# Dependency : Path of tryexpect(intermediate log needs to be taken care of which is mentioned in /home/nmsadm)
#
# REV HISTORY
# DATE:                           BY                                 MODIFICATION:
# 2/9/2014                      XNNNKKR                            Modified the script into TAF Compliant.
##########################################################


use Expect;

$ntwrk_element=$ARGV[0];

open(RFH,">AXM_FT_EAC_ELN_EventLogFull_ALL.txt");

print "Starting the test Execution\n";

my $max_size=`/opt/ericsson/bin/eac_egi_config -list | /bin/grep cmd_log_max_size | /bin/cut -d "=" -f2`;
my $log_status=`/opt/ericsson/bin/eac_egi_config -list | /bin/grep event_log_status | /bin/cut -d "=" -f2`;

chomp($max_size);
chomp($log_status);


print "Setting the log size to 10000 and event status to 1\n";

my $set_size=`/opt/ericsson/bin/eac_egi_config -set cmd_log_max_size 10000`;
my $set_status=`/opt/ericsson/bin/eac_egi_config -set event_log_status 1`;

my $file_name="/var/opt/ericsson/nms_eam_eac/log/ev/eacr.new";
my $file_name1="/var/opt/ericsson/nms_eam_eac/log/ev/eacr.old";

while( -s $file_name < 9000)
{
            my $size = -s "/var/opt/ericsson/nms_eam_eac/log/ev/eacr.new";
             print "Size is: $size\n";
	    print "Sending command for $ntwrk_element\n";    
		my $expect = Expect->new;
		my $command = "/opt/ericsson/bin/eaw $ntwrk_element";
		$expect->spawn($command) or die "Cannot spawn : $!\n";
		$expect->log_file("/home/nmsadm/tryexpect.log","w");
		$expect->expect(5,'<');
		$expect->send("exit;\r");
		$expect->soft_close();
		
	
}

if( -s $file_name > 9000)
{
	if( -e $file_name && -e $file_name1)
	{
        	print RFH "PASS : event log file is renamed to an old file and a new event file is created\n";
		
	}
	else
	{
		print RFH "FAIL : Failed to create new event file\n";
		
	}
}


print "Reverting the node log parameters to default\n";
my $set_size1=`/opt/ericsson/bin/eac_egi_config -set cmd_log_max_size $max_size`;
my $set_status1=`/opt/ericsson/bin/eac_egi_config -set event_log_status $log_status`;

close(RFH);

system("/bin/cat AXM_FT_EAC_ELN_EventLogFull_ALL.txt | /bin/grep FAIL ");
if ($? == 0)
{
	print  "\nFAIL\n";
}
else
{
	print "\nPASS\n";
}
