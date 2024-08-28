#!/usr/bin/perl
#
# SCRIPT NAME:AXM_FT_EAC_ESI_ListAvailableNE_NO_NODE.pl
# Test Case & Priority: AXM_FT_EAC_ESI_ListAvailableNE_NO_NODE (Pr.2)
# Test Case No : 6.3.1
# AUTHOR:xharcha
# DATE  :
# REV:
#
# Description :
# Prerequisites  :
# Return Value on Success : 0
# Return Value on Failure : 1
# Result File : /home/nmsadm/eam/results
#
# Usage :  bash RUNME -t AXM_FT_EAC_ESI_ListAvailableNE_NO_NODE.pl.
#
# Dependency : Te.pm, crdmp.sh, PMSEerrorchk.sh
#
# REV HISTORY
# DATE:                           BY                                 MODIFICATION:
# DATE:                           BY                                 MODIFICATION:
#
##########################################################
# DEFINE FILES AND VARIABLES HERE
#use Te;
#use FRAME;
use Expect;
#use util;
#my $EAM_DIR    = $ENV{EAM_DIR};
#my $TC         = "AXM_FT_EAC_ESI_ListAvailableNE_NO_NODE";
#my $RESULT_DIR = $ENV{RESULT_DIR};
#my $TMP        = $ENV{TMP};

#$ENV{tc} =AXM_FT_EAC_ESI_ListAvailableNE_NO_NODE; 
$ntwrk_element=$ARGV[0];#$ENV{ntwrk_element};

#========================================================================
open (RFH,">AXM_FT_EAC_ESI_ListAvailableNE_NO_NODE.txt");
@config_list = `/opt/ericsson/bin/eac_esi_config -nl | /bin/awk '{print \$1}'`;

@mapfile_list =`/opt/ericsson/bin/cap_pdb_cat_map eac_esi_map | /bin/cut -d : -f2 | /bin/awk '{print \$3}' | /bin/tr -d '"'`;

$size1 = @config_list;
$size2 = @mapfile_list;

for ($i=3,$j=2;$i<$size1&&$j<$size2;$i++,$j++)
 {
        
        if(@config_list[$i] ne @mapfile_list[$j])
        {
		print RFH "FAIL : Comparision Failed for node:$config_list[$i] \n";
        }
}
	print RFH "PASS : Comparision  successfull\n";

close(RFH);

system("/bin/cat AXM_FT_EAC_ESI_ListAvailableNE_NO_NODE.txt | /bin/grep FAIL ");
if ($? == 0)
{
print  "FAIL\n";
}
else
{
print "PASS\n";
#unlink("AXM_FT_EAC_ESI_ListAvailableNE_NO_NODE.txt");
}
#=======================================================================
