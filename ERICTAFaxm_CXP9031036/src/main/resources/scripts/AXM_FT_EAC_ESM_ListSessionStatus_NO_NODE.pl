#!/usr/bin/perl
#
# SCRIPT NAME:AXM_FT_EAC_ESM_ListSessionStatus_NO_NODE.pl
# Test Case & Priority:AXM_FT_EAC_ESM_ListSessionStatus_NO_NODE(Pr.2)
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
# Usage :  bash RUNME -t AXM_FT_EAC_ESM_ListSessionStatus_NO_NODE.pl.
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
#my $TC         = "AXM_FT_EAC_ESM_ListSessionStatus_NO_NODE";
#my $RESULT_DIR = $ENV{RESULT_DIR};
#my $TMP        = $ENV{TMP};

#$ENV{tc} = AXM_FT_EAC_ESM_ListSessionStatus_NO_NODE;
$ntwrk_element=$ARGV[0];#$ENV{ntwrk_element};
#======================================================================

open(RFH,">AXM_FT_EAC_ESM_ListSessionStatus_NO_NODE.txt");
sub esmsessionInfo
{
        open(FILE, ">/home/nmsadm/esm_sessioninfo.txt") or die "Could not open file: $!";
        print FILE `/opt/ericsson/bin/eac_esm_info -t`;
        close(FILE);
        if ( $? == 0 )
        {
		print RFH "PASS : Eac_esm_info command is successful\n";
        }
        else
        {
		print RFH "FAIL : Eac_esm_info command is not successful\n";

        }
}


esmsessionInfo;
#my $esmdata=`/bin/cat /home/nmsadm/eam/tmp/esm_sessioninfo.txt |/bin/tail -3|/bin/awk '{print \$1}'`;
#print "Esminfo = $esmdata";

system("/bin/cat /home/nmsadm/esm_sessioninfo.txt | /bin/grep ehiplx_process_manager");

if ( $? == 0 )
{
	print RFH "PASS : EAM-TSP Session info found successful\n";
}
else
{
	print RFH "FAIL : EAM-TSP Session info not able to found\n";

}

sub single_EsmsessionInfo
{
        open(FILE, ">/home/nmsadm/esm_single_sessioninfo.txt") or die "Could not open file: $!";
        print FILE `/opt/ericsson/bin/eac_esm_info -t -p eac_sb_server`;
        close(FILE);
        if ( $? == 0 )
        {
		print RFH "PASS : Eac_esm_info command is successful\n";
        }
        else
        {
		print RFH "FAIL : Eac_esm_info command is not successful\n";

        }
}

single_EsmsessionInfo;
system("/bin/cat /home/nmsadm/esm_single_sessioninfo.txt | /bin/grep eac_sb_server");
if ( $? == 0 )
{
	print RFH "PASS : EAM-TSP Session for eac_sb_server found successful\n";
}
else
{
	print RFH "FAIL : EAM-TSP Session info for eac_sb_server able to found\n";

}

close(RFH);

system("/bin/cat AXM_FT_EAC_ESM_ListSessionStatus_NO_NODE.txt | /bin/grep FAIL ");
if ($? == 0)
{
print  "FAIL\n";
}
else
{
print "PASS\n";
#unlink("AXM_FT_EAC_ESM_ListSessionStatus_NO_NODE.txt");
}

#=======================================================================
