#!/usr/bin/perl
#
# SCRIPT NAME:AXM_FT_Connection_Node_with_sessioonID_ALL.pl
# Test Case & Priority:AXM_FT_Connection_Node_with_sessioonID_ALL(Pr.1)
# Test Case No :7.2.24(common)
# AUTHOR:XJITKUM
# DATE  :28/11/2013
# REV:
#
# Description :
# Prerequisites  :
# Return Value on Success : 0
# Return Value on Failure : 1
# Result File : /home/nmsadm/eam/results
#
# Usage :  bash RUNME -t AXM_FT_Connection_Node_with_sessioonID_ALL.pl.
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
#my $TC         = "AXM_FT_Connection_Node_with_sessioonID_ALL";
#my $RESULT_DIR = $ENV{RESULT_DIR};
#my $TMP        = $ENV{TMP};

#$ENV{tc} = AXM_FT_Connection_Node_with_sessioonID_ALL;
$ntwrk_element=$ARGV[0];#$ENV{ntwrk_element};
#FRAME::start_frame "$TC";
#======================================================================

open (RFH,">AXM_FT_Connection_Node_with_sessioonID_ALL.txt");
my $val_flag = 0;
sub node_conn
{
#val_flag = 1;
print "Establishing connection for $ntwrk_element\n";
        my $expect = Expect->new;
        my $command = "/opt/ericsson/bin/eaw $ntwrk_element";
        $expect->spawn($command) or die "Cannot spawn : $!\n";
        $expect->log_file("/home/nmsadm/Session_Id.log","w+");
        $expect->expect(5,'<');
        if($val_flag == 0)
        {
        my $cr_daemon  = `/opt/ericsson/bin/eac_esi_config -ne $ntwrk_element|/bin/grep "cr_daemon       ="|/bin/cut -d "=" -f2`;
        print $cr_daemon;
        open(FILE, ">/home/nmsadm/output.txt") or die "Could not open file: $!";
        print FILE `/opt/ericsson/bin/eac_esm_info -p $cr_daemon`;
        close(FILE);
        if ( $? == 0 )
        {
		print RFH "PASS :  Eac_esm_info command is successful\n";
        }
        else
        {
		print RFH "FAIL : Eac_esm_info command is not successful\n";


        }
        }
        select STDOUT;
}

node_conn;
my $sid=`/bin/cat /home/nmsadm/output.txt |/bin/tail -1|/bin/awk '{print \$1}'`;
print "Session ID = $sid";

if($sid ne "")
{
	print RFH "PASS : New session id found successful\n";
}
else
{
	print RFH "FAIL : Not able to find new session ID\n";
}
close(RFH);

system("/bin/cat AXM_FT_Connection_Node_with_sessioonID_ALL.txt | /bin/grep FAIL ");
if ($? == 0)
{
print  "FAIL\n";
}
else
{
print "PASS\n";
#unlink("AXM_FT_Connection_Node_with_sessioonID_ALL.txt");
}
#=======================================================================
#FRAME::end_frame "$TC";
