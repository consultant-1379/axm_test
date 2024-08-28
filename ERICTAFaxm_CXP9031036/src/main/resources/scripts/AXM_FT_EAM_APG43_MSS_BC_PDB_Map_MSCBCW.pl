#!/usr/bin/perl
#
# SCRIPT NAME:AXM_FT_EAM_APG43_MSS_BC_PDB_Map_MSCBCW.pl
# Test Case & Priority: AXM_FT_EAM_APG43_MSS_BC_PDB_Map_MSCBCW (Pr.1)
# Test Case No :5.8.2(Handler)
# AUTHOR:XNNNKKR
# DATE  :
# REV:
#
################################ Description ######################
#This test case checks that eac_ehms_map is updated while adding APG43 with MSS-BC configuration.
###################################################################
# Prerequisites  :
# Return Value on Success : 0
# Return Value on Failure : 1
# Result File : /home/nmsadm/eam/results
#
# Usage :  bash RUNME -t AXM_FT_Connection_of_MSCBC_clusterNode_with_AD_MSCBCW.pl:MSCBCwindows.
#
# Dependency : Te.pm, crdmp.sh, PMSEerrorchk.sh
#
# REV HISTORY
# DATE:                           BY                                 MODIFICATION:
#
##########################################################

# DEFINE FILES AND VARIABLES HERE
use Expect;
$ntwrk_element=$ARGV[0];#ENV{ntwrk_element};

#======================================================================

open(RFH,">AXM_FT_Connection_of_MSCBC_clusterNode_with_AD_MSCBCW.txt");
$data[$i]=`/opt/ericsson/bin/eac_esi_config -ne $ntwrk_element | /bin/egrep 'cr_daemon|name'`;

if($data[$i]=~/ehms_ac_in/)
{
$ehms[$c]=$data[$i];
$c++;
}
my $scalar3 = join "", @ehms;
my @val2 = split(' ', $scalar3);
for($t=2;$t<scalar(@val2);$t=$t+6)
{
$mscbc[$k]=$val2[$t];
$k++;
}

print "@mscbc";

system("/opt/ericsson/bin/cap_pdb_cat_map eac_ehms_map >> ehms_map.log");
system("/bin/grep $mscbc[0] ehms_map.log ");

if ( $? == 0 ) 
{
	print RFH "PASS : Matching with mscbc node\n";
}
else 
{
	print RFH "FAIL : Doesn't match with the mscbc node"; 
}

close(RFH);

system("bin/grep FAIL AXM_FT_Connection_of_MSCBC_clusterNode_with_AD_MSCBCW.txt");
if ($? == 0)
{
print  "FAIL\n";
}
else
{
print "PASS\n";
#unlink("AXM_FT_Connection_of_MSCBC_clusterNode_with_AD_MSCBCW.txt");
}


#=======================================================================
