#!/usr/bin/perl
#
# SCRIPT NAME:AXM_FT_EAC_CR_RecAlarmNotSubs_NO_NODE.pl
# Test Case & Priority: AXM_FT_EAC_CR_RecAlarmNotSubs (Pr.1)
# Test Case No :  6.1.3 (Common)
# AUTHOR: XROHAGR
# DATE  : 10\12\2013
# REV: A
#
################################ Description ######################
#This test case is for Checking the reception of an alarm
###################################################################

# Prerequisites  : 
# Return Value on Success : 0
# Return Value on Failure : 1
# Result File : /home/nmsadm/eam/results
# Usage :  bash RUNME -t AXM_FT_EAC_CR_RecAlarmNotSubs_NO_NODE.pl:NO_NODE 
#
# Dependency : Te.pm, crdmp.sh, PMSEerrorchk.sh, /home/nmsadm/eam/bin/INPUT/Alarm_Generator_sparc, /home/nmsadm/eam/bin/INPUT/Alarm_Generator_x86
# OutPut Files: /home/nmsadm/eam/tmp/alarm.log
#
# REV HISTORY
# DATE:                           BY                                 MODIFICATION:
#
##########################################################

# DEFINE FILES AND VARIABLES HERE

use Expect;


use IO::Socket;
use Sys::Hostname;



open(RFH,">AXM_FT_EAC_CR_RecAlarmNotSubs_NO_NODE.txt");     
$ntwrk_element=$ARGV[0];

#======================================================================

CreatingNode();
$hostname = hostname;
my($addr)=inet_ntoa((gethostbyname($hostname))[4]);
print "Server ipaddress = $addr\n";
print RFH "PASS:Setting the \"alarm_standby_file\" parameter to \"alarm\" and the \"alarm_standby_distr\" parameter to \"4\n";
#Te::tex "$TC", "\nINFO  : Setting the \"alarm_standby_file\" parameter to \"alarm\" and the \"alarm_standby_distr\" parameter to \"4\".\n"; 
 
my $status1 = system("/opt/ericsson/bin/eac_egi_config -set alarm_standby_file alarm");
my $status2 =  system("/opt/ericsson/bin/eac_egi_config -set alarm_standby_distr 4");

if ( $status1 != 0 || $status1 != 0) 
{
 print RFH "FAIL:Setting the parameters is not success\n";
		
}

my $alarm_standby_file = `/opt/ericsson/bin/eac_egi_config -get alarm_standby_file | grep "alarm_standby_file        =" | cut -d "=" -f2`;
#$alarm_standby_file =util::trim $alarm_standby_file;
chomp($alarm_standby_file);

my $alarm_standby_distr = `/opt/ericsson/bin/eac_egi_config -get alarm_standby_distr | grep "alarm_standby_distr       =" | cut -d "=" -f2`;
#$alarm_standby_distr =util::trim $alarm_standby_distr;
chomp($alarm_standby_distr);

print "alarm_standby_file = $alarm_standby_file \n";
print "alarm_standby_distr = $alarm_standby_distr \n";

#Te::tex "$TC", "\nINFO  : Verifing the \"alarm_standby_file\" parameter to \"alarm\" and the \"alarm_standby_distr\" parameter to \"4\" in eac_egi_config.\n";

print RFH "PASS:Verifing the \"alarm_standby_file\" parameter to \"alarm\" and the \"alarm_standby_distr\" parameter to \"4\" in eac_egi_config.\n";

print $alarm_standby_file;
$alarm_standby_file=`/bin/echo $alarm_standby_file | /usr/bin/tr -d '\040\011\012\015'`;
$alarm_standby_distr=`/bin/echo $alarm_standby_distr | /usr/bin/tr -d '\040\011\012\015'`;
if ( $alarm_standby_file eq "alarm")
{
	print "PASS:Set the \"alarm_standby_file\" parameter to \"alarm\" sucessfully\n";
	#Te::tex "$TC", "INFO  : Set the \"alarm_standby_file\" parameter to \"alarm\" sucessfully.";
	print RFH "PASS:Set the \"alarm_standby_file\" parameter to \"alarm\" sucessfully\n";
}
else
{
	print RFH "FAIL:Set the \"alarm_standby_file\" parameter to \"alarm\" Unsucessfully\n";
	#Te::tex "$TC", "Error : Set the \"alarm_standby_file\" parameter to \"alarm\" Unsucessfully.";
}

if ( $alarm_standby_distr eq "4")
{
	#Te::tex "$TC", "INFO  : Set the \"alarm_standby_distr\" parameter to \"4\" sucessfully.";
  print RFH "PASS:set the \"alarm_standby_distr\" parameter to \"4\" sucessfully\n";
}
else
{
 print RFH "FAIL: Set the \"alarm_standby_distr\" parameter to \"4\" Unsucessfully\n";
	#Te::tex "$TC", "Error : Set the \"alarm_standby_distr\" parameter to \"4\" Unsucessfully.";
}


sub cmd_alarm
{
		$archFlag = 0;
		$archFlag = 1   if(`arch`=~ /sparc/);
		
		if ($archFlag == 1)
		{
			print "Selecting binary Alarm_Generator_x86\n";
		}
		else
		{
			print "Selecting binary Alarm_Generator_sparc\n";
		}
	        check_file_exist("/home/nmsadm/eam/bin/INPUT/Alarm_Generator_x86");
                $cmd = "/home/nmsadm/eam/bin/INPUT/Alarm_Generator_sparc $addr";	
		print "Sending alarm for IP address $addr\n";
		
        my $expect = Expect->new;
        $expect->spawn($cmd) or die "Cannot spawn : $!\n";
				
        $expect->log_file("alarm.log","w+");

        $expect->expect(5,'Do you wish to continue with default inputs? Y/N :');
		       
	    $expect->send("y\r");

        $expect->soft_close();
}

$alarmEntryCountBefore = `/bin/ls -lrt /var/opt/ericsson/nms_eam_eac/log/cr/stdby/ | /bin/grep "alarm.*.*" | /bin/wc -l`;

print "alarmEntryCountBefore = ",$alarmEntryCountBefore;

cmd_alarm;

$alarmEntryCountAfter = `/bin/ls -lrt /var/opt/ericsson/nms_eam_eac/log/cr/stdby/ | /bin/grep "alarm.*.*" | /bin/wc -l`;

print "alarmEntryCountAfter = ",$alarmEntryCountAfter;

if ($alarmEntryCountBefore == $alarmEntryCountAfter)
{
	#Te::tex "$TC", "ERROR  : Alarm has not created at path [/var/opt/ericsson/nms_eam_eac/log/cr/stdby/alarm.<connection_id>.<report_id] because node need to configure for $addr";
print RFH "FAIL:Alarm has not created at path [/var/opt/ericsson/nms_eam_eac/log/cr/stdby/alarm.<connection_id>.<report_id] because node need to configure for $addr\n";
	
}
else
{
print RFH "PASS:Alarm has created at path [/var/opt/ericsson/nms_eam_eac/log/cr/stdby/alarm.<connection_id>.<report_id]\n";
	#Te::tex "$TC", "INFO  : Alarm has created at path [/var/opt/ericsson/nms_eam_eac/log/cr/stdby/alarm.<connection_id>.<report_id]";
}

#=======================================================================
#FRAME::end_frame "$TC";

sub CreatingNode
{
		check_file_exist("/home/nmsadm/eam/bin/INPUT/create_ori.xml");

        my $node_from_xml =
        `/bin/grep 'ManagedElementId string='  /home/nmsadm/eam/bin/INPUT/create_ori.xml|/bin/cut -d '"' -f2`;

        system("/opt/ericsson/bin/eac_esi_config -nl | /bin/awk '{print \$1}' > MapFileData.log");

        open (FPTR,"MapFileData.log") || die "Can't Open File: MapFileData.log\n";
        @arr = <FPTR>;  #Read the file into an array
        close (FPTR);         #Close the file

        unlink("MapFileData.log"); #Deleting the temporary Log file

        #Checking the node in eac_esi_config file
        $flag = 0;
        foreach $x (@arr)       {
                $flag = 1 if($x eq "$node_from_xml");
        }

        #$node_from_xml = util::trim $node_from_xml;
        chomp($node_from_xml);

        if ( $flag == 1)
        {
               print "Node $node_from_xml has found already in eac_esi_config file\n";
        }
        else
        {
		print "Node $node_from_xml does not exist in eac_esi_config file\n";
                getIP_updateInXML($node_from_xml);
        }
}

sub getIP_updateInXML
{
        my $node =      $_[0];

        my $hostname = hostname;
        my $ipaddr=inet_ntoa((gethostbyname($hostname))[4]);
        print "Server ipaddress = $ipaddr\n";
        chomp($ipaddr);

        Verifying_IP_Address($ipaddr);

        my $text = `/bin/cat /home/nmsadm/eam/bin/INPUT/create_ori.xml | /bin/grep "ioIpAddressCluster ip_v4="`;
        chomp($text);

        print "Text = $text \n";

        if ($text =~ /"(.+?)"/)
        {
                my $xmlIP = $1;
                chomp($xmlIP);
                print "found: $xmlIP\n";
				
                Verifying_IP_Address($xmlIP);
				
                `/bin/mv /home/nmsadm/eam/bin/INPUT/create_ori.xml /home/nmsadm/eam/bin/INPUT/create.xml.old`;
                `/bin/sed -e 's/$xmlIP/$ipaddr/g' /home/nmsadm/eam/bin/INPUT/create.xml.old > /home/nmsadm/eam/bin/INPUT/create_ori.xml`;
                `/bin/rm -f /home/nmsadm/eam/bin/INPUT/create.xml.old`;

                print "Please wait for while node with server IP address is being created...\n";
                createNodeUsingIPAddr($node);
                print "Creating the node ..\n";
        }
        else
        {
           print RFH "FAIL:failed to modify IP address in xml\n";
              #  Te::tex "$TC", "\n\nERROR  : Failed to modify IP address in xml.";
             #   FRAME::end_frame "$TC";
        }
}

sub createNodeUsingIPAddr
{
        my $node =      $_[0];
        $cmd =
        `/opt/ericsson/arne/bin/import.sh -i_nau -import -f /home/nmsadm/eam/bin/INPUT/create_ori.xml > CreatingServerNode`;

        if ( $? == 0 ) {
             #   Te::tex "$TC", "\n\nINFO  : Node $node using server IP address has been created successfully.";
	print "$node using server IP address has been created successfully\n";
        print RFH "PASS :Node $node using server IP address has been created successfully\n";
   
        }
        else {
              #  Te::tex "$TC", "\n\nERROR  : Failed to create Node $node using server IP address.";
     	print RFH "FAIL:Failed to create Node $node using server IP address\n";
                #FRAME::end_frame "$TC";
        }
        #Te::tex "$TC", " ";

        

}

sub Verifying_IP_Address
{
     my $ipaddr = $_[0];
    if( $ipaddr =~ m/^(\d\d?\d?)\.(\d\d?\d?)\.(\d\d?\d?)\.(\d\d?\d?)$/ )
    {
		print("IP Address $ipaddr --> VALID FORMAT! \n");

		if($1 <= 255 && $2 <= 255 && $3 <= 255 && $4 <= 255)
		{
			print("IP address: $1.$2.$3.$4 --> All octets within range\n");
		}
		else
		{
			print("One of the octets is out of range. All octets must contain a number between 0 and 255 \n");
		}
    }
    else
    {
        print("IP Address $ipaddr --> NOT IN VALID FORMAT! \n");
    }
}

#Method for Checking the file Exist or Not...
sub check_file_exist
{
	my $file = $_[0];
	
	if ( -e "$file" )	{
		# Te::tex "$TC", "INFO  : Required $file has been found.";
                print RFH "PASS:Required $file has been found\n";
	}
	else	{
		 #Te::tex "$TC", "Error : Couldn't find $file the required file to process.";
		 #FRAME::end_frame "$TC";
            print RFH "FAIL:Couldn't find $file the required file to process\n";
	}
}
system("/bin/cat AXM_FT_EAC_CR_RecAlarmNotSubs_NO_NODE.txt| /bin/grep FAIL ");
if ($? == 0)
{
print  "FAIL\n";
}
else
{
print "PASS\n";
#unlink("AXM_FT_EAC_CR_RecAlarmNotSubs_NO_NODE.txt");
}


