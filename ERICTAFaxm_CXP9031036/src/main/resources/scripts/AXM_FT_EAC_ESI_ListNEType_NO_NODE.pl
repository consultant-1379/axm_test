#!/usr/bin/perl
#
# SCRIPT NAME:AXM_FT_EAC_ESI_ListNEType_NO_NODE.pl
# Test Case & Priority: AXM_FT_EAC_ESI_ListNEType_NO_NODE (Pr.2)
# Test Case No : 6.3.3
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
# Usage :  bash RUNME -t AXM_FT_EAC_ESI_ListNEType_NO_NODE.pl:NO_NODE
#
# Dependency : Te.pm, crdmp.sh, PMSEerrorchk.sh
#
# REV HISTORY
# DATE:                           BY                                 MODIFICATION:
#
##########################################################
# DEFINE FILES AND VARIABLES HERE
#set -x
#use Te;
#use FRAME;
use Expect;
#use util;
#my $EAM_DIR    = $ENV{EAM_DIR};:
#my $TC         = "AXM_FT_EAC_ESI_ListNEType_NO_NODE";
#my $RESULT_DIR = $ENV{RESULT_DIR};
#my $TMP        = $ENV{TMP};

#$ENV{tc} =AXM_FT_EAC_ESI_ListNEType_NO_NODE; 
$ntwrk_element=$ARGV[0];#$ENV{ntwrk_element};

#========================================================================

open(RFH,">AXM_FT_EAC_ESI_ListNEType_NO_NODE.txt");
@node = `/opt/ericsson/bin/eac_esi_config -nl | /bin/awk '{print \$1}'`;
$node_size = @node;
$newsize = $node_size - 3;
@node_list = `/opt/ericsson/bin/eac_esi_config -nl | /bin/awk '{print \$1}' | /bin/tail -$newsize`;
$count = 0;

foreach $node (@node_list)
{	
	print RFH "PASS : Node Name : $node\n";
	chomp($node);

	for($i=2 ;$i <32 ; $i++)
	{
		@array[$i] = `/opt/ericsson/bin/cap_pdb_cat_map eac_esi_map | grep 'name, s, "$node"' | /bin/sed 's/: /?/g' | cut -d "?" -f$i | /bin/awk '{print \$3}' | /bin/tr -d '"'`;
	

}

$nsize = @array;

for($b=0,$c=0;$c<$nsize;$b++,$c++)
{
        if($c == 15)
        {
                $b--;
        }
        else
        {
                @array_new[$b]=@array[$c];
        }
}


@array1 = `/opt/ericsson/bin/eac_esi_config -ne "$node" | /bin/awk '{print \$3}' | /bin/sed '14d'`;


$size = @array1;
$size1= @array_new;

for ($j=0,$k=2;$j<$size-1,$k<$size1-1;$j++,$k++)
{
	if(@array1[$j] ne @array_new[$k])
	{
		print RFH "FAIL : Comparison failed for node: $node in the parameter: @array1[$j] of eac_esi_config and @array_new[$k] of map file
";
        }
}
print RFH "PASS : Comparision executed successfully for the node:$node\n";
$count++;
}

close(RFH);

system("/bin/cat AXM_FT_EAC_ESI_ListNEType_NO_NODE.txt | /bin/grep FAIL ");
if ($? == 0)
{
print  "FAIL\n";
}
else
{
print "PASS\n";
#unlink("AXM_FT_EAC_ESI_ListNEType_NO_NODE.txt");
}
#=======================================================================#
