#!/usr/bin/perl
#
# SCRIPT NAME:AXM_FT_EAC_ESM_ProcessList_NO_NODE.pl
# Test Case & Priority:AXM_FT_EAC_ESM_ProcessLis_NO_NODE(Pr.2)
# Test Case No :(common)
# AUTHOR:XJITKUM
# DATE  :02/12/2013
# REV:
#
# Description :
# Prerequisites  :
# Return Value on Success : 0
# Return Value on Failure : 1
# Result File : /home/nmsadm/eam/results
#
# Usage :  bash RUNME -t AXM_FT_EAC_ESM_ProcessList_NO_NODE.pl.
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
#my $TC         = "AXM_FT_EAC_ESM_ProcessList_NO_NODE";
#my $RESULT_DIR = $ENV{RESULT_DIR};
#my $TMP        = $ENV{TMP};

#$ENV{tc} = AXM_FT_EAC_ESM_ProcessList_NO_NODE;
$ntwrk_element=$ARGV[0];#$ENV{ntwrk_element};
#FRAME::start_frame "$TC";
#======================================================================
open RFH, ">AXM_FT_EAC_ESM_ProcessList_NO_NODE.txt" or die $!;
sub esmInfo
{
        open FILE, ">esminfo.txt" or die $!;
        print FILE `/opt/ericsson/bin/eac_esm_info -r`;
        close(FILE);
        if ( $? == 0 )
        {
		print RHF "PASS : Eac_esm_info command is successful\n";
              #  Te::tex "$TC", "\nINFO  : Eac_esm_info command is successful";
        }
        else
        {
		print RFH "FAIL : Eac_esm_info command is not successful\n";
              #  Te::tex "$TC", "\nERROR  : Eac_esm_info command is not successful";

        }
}

esmInfo;

my $esmdata=`/bin/cat esminfo.txt |/bin/tail -3|/bin/awk '{print \$1}'`;
print "Esminfo = $esmdata";

if($esmdata ne "")
{
	print RFH "PASS : EAM-TSP info found successful\n";
#       Te::tex "$TC","INFO  : EAM-TSP info found successful";
}
else
{
	print RFH "FAIL : Not able to find EAM-TSPs\n";
#        Te::tex "$TC", "ERROR  : Not able to find EAM-TSPs";
}


close(RFH);

system("/bin/cat AXM_FT_EAC_ESM_ProcessList_NO_NODE.txt| /bin/grep FAIL ");
if ($? == 0)
{
print  "FAIL\n";
}
else
{
print "PASS\n";
#unlink("AXM_FT_EAC_ESM_ProcessList_NO_NODE.txt");
}
#=======================================================================
#FRAME::end_frame "$TC";
