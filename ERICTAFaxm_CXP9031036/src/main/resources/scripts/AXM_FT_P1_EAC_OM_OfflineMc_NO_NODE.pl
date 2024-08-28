#!/use/bin/perl
#
# SCRIPT NAME: AXM_FT_P1_EAC_OM_OfflineMc_NO_NODE.pl 
# Test Case & Priority: AXM_FT_EAC_OM_StopMc(Pr.1)
# Test Case No : 5.3.2
# AUTHOR: XNNNKKR
# DATE  : 
# REV: 
#
# Description : These tests aim to verify the handling of EAM MC¡Çs.
#               Stop of the eam_common, eam_eac_idl, eamhandlerAPG30, eam_handlerlp, 
#               eam_handlerlp_Mgr, eam_handlerMs, eam_handlerMs_Mgr, eam_handlerMtp, eam_handlerText, eam_nrma, 
#               eam_hanlerIplx, eam_handlerIplx_Mgr functions correctly and that no core dump is generated.
# Prerequisites  : 
# Return Value on Success : 0
# Return Value on Failure   : 1
# Result File : /home/nmsadm/eam/results
# 
# Usage :  bash RUNME -t AXM_FT_P1_EAC_OM_OfflineMc_NO_NODE.pl
# 
# Dependency : Te.pm, crdmp.sh, PMSEerrorchk.sh
# 
# REV HISTORY
# DATE      BY         MODIFICATION
#  
##########################################################

# DEFINE FILES AND VARIABLES HERE
#use Te;

#========================================================================
#Fetching the MC's present in the server
$scalar=`/opt/ericsson/nms_cif_sm/bin/smtool -l |grep eam`;
my @val = split(' ', $scalar);

for($i=0;$i<scalar(@val);$i=$i+2)
{
$var1[$j]=$val[$i];
$j++;
}
my $EAM_MC_LIST = join " ", @var1;
$cmd = `/opt/ericsson/nms_cif_sm/bin/smtool -offline $EAM_MC_LIST -reason="other" -reasontext=" "`;
print "Please wait for 80 seconds as offline of MC is in progress....";
system("$cmd");
sleep(80);

my $MC_status = `/opt/ericsson/nms_cif_sm/bin/smtool -l $EAM_MC_LIST`;
chomp $MC_status;
open( LFH, ">Offline_tmp.txt" ) or die $!;
print LFH "$MC_status\n";
close(LFH);

open( HH, "Offline_tmp.txt" );
my @arr = <HH>;
close(HH);

unlink("Offline_tmp.txt");

foreach $y (@arr) {
    if ( $y =~ /offline/ || $y =~ /^\s*$/ ) 
	{
              
	#print "INFO  :Command execution PASSED:EAM MC $& is made offline successfully";
	system("echo PASS >>Offline_result.txt");
        unlink("Offline_tmp.txt");
        
    }
    else 
	{
        
    	#print "ERROR  :Command execution FAILED\n";
	system("echo FAIL >>Offline_result.txt");
        
        
    }
}
system("grep 'FAIL' Offline_result.txt");
if($? == 0)
{
print "\n Test script FAILED\n";
}
else
{
print "\n Test script PASSED\n";
system("rm Offline_result.txt");
}


