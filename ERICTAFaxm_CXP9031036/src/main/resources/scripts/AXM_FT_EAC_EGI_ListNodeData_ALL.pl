#!/usr/bin/perl
#
# SCRIPT NAME:AXM_FT_EAC_EGI_ListNodeData_ALL.pl
# Test Case & Priority:AXM_FT_EAC_EGI_ListNodeData_ALL(Pr.2)
# Test Case No :(common)
# AUTHOR:XJITKUM
# DATE  :03/12/2013
# REV:
#
################################ Description ######################
#This test case is to get the name of the TMOS node
###################################################################
# Prerequisites  :
# Return Value on Success : 0
# Return Value on Failure : 1
# Result File : /home/nmsadm/eam/results
#
# Usage :  bash RUNME -t AXM_FT_EAC_EGI_ListNodeData_ALL.pl.
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
#my $TC         = "AXM_FT_EAC_EGI_ListNodeData_ALL";
#my $RESULT_DIR = $ENV{RESULT_DIR};
#my $TMP        = $ENV{TMP};

#$ENV{tc} = AXM_FT_EAC_EGI_ListNodeData_ALL;
$ntwrk_element=$ARGV[0];#ENV{ntwrk_element};
#FRAME::start_frame "$TC";
#======================================================================
open (RFH,">AXM_FT_EAC_EGI_ListNodeData_ALL.txt");
sub node_conn
{
print "Establishing connection for $ntwrk_element\n";
        my $expect = Expect->new;
        my $command = "/opt/ericsson/bin/eaw $ntwrk_element";
        $expect->spawn($command) or die "Cannot spawn : $!\n";
        $expect->log_file("/home/nmsadm/eam/tmp/tmosinfo.txt","w+");
        $expect->expect(5,'<');
        $expect->send("tmosinfo;\r");
        $expect->expect(5,'<');
        $expect->send("quit;\r");
        $expect->soft_close();
}

node_conn;
my $tmos_es_name=`/bin/cat /home/nmsadm/eam/tmp/tmosinfo.txt|/bin/grep "NAME"|/bin/cut -d ":" -f2`;
print "TMOS SYSTEM INFORMATION for ES_NAME = $tmos_es_name";

if($tmos_es_name ne "")
{
	print RFH "PASS : ES name found successful\n";
}
else
{
	print RFH "FAIL : Not able to find Es name\n";	
}

my $es_config_node_name  = `/opt/ericsson/bin/eac_esi_config -ne $ntwrk_element|/bin/grep "name            ="|/bin/cut -d "=" -f2`;

print "EAC_ESI_CONFIG INFORMATION for NODE_NAME = $es_config_node_name";

if($es_config_node_name ne "")
{
	print RFH "PASS : Node name found successful from es_config \n";
}
else
{
	print RFH "FAIL : Not able to find Node name found from es_config\n";
}

if(`$tmos_es_name` eq `$es_config_node_name`)
{
	print RFH "PASS : Node information from tmosinfo and eac_esi_config matched successfully\n";
}
else
{
	print RFH "FAIL : Node information not matched\n";
}

my $tmos_ip_addr=`/bin/cat /home/nmsadm/eam/tmp/tmosinfo.txt|/bin/grep "ADDR"|/bin/cut -d ":" -f2`;

print "TMOS SYSTEM INFORMATION for IP_ADDR = $tmos_ip_addr";

if($tmos_ip_addr ne "")
{
	print RFH "PASS : IP_ADDR found successful from tmosinfo\n";
}
else
{
	print RFH "FAIL : Not able to find IP_ADDR\n";
}


my $es_config_ipaddr  = `/opt/ericsson/bin/eac_esi_config -ne $ntwrk_element | /bin/grep "address         ="|/bin/cut -d "=" -f2 |/bin/cut -d "," -f1`;

print "EAC_ESI_CONFIG INFORMATION for NODE_NAME = $es_config_ipaddr ";

if($es_config_ipaddr  ne "")
{
	print RFH "PASS : IP address found successful from es_config\n";
}
else
{
	print RFH "FAIL : Not able to find IP address found from es_config\n";
}

if(`$tmos_ip_addr` eq `$es_config_ipaddr`)
{
	print RFH "PASS : IP address for tmosinfo and eac_esi_config matched successfully\n";
}
else
{
	print RFH "FAIL : IP address not able to match\n";
}

close(RFH);

system("/bin/cat AXM_FT_EAC_EGI_ListNodeData_ALL.txt | /bin/grep FAIL ");
if ($? == 0)
{
print  "FAIL\n";
}
else
{
print "PASS\n";
#unlink("AXM_FT_EAC_EGI_ListNodeData_ALL.txt");
}
#=======================================================================
#FRAME::end_frame "$TC";
