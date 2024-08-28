#!usr/bin/perl
#
# SCRIPT NAME:AXM_FT_P1_EAC_OM_ColdRestartMc_NO_NODE.pl
# Test Case & Priority : AXM_FT_P1_EAC_OM_ColdRestartMc_NO_NODE (Pr.1)
# Test Case No : 5.3.4
# AUTHOR: XNNNKKR
# DATE   
# REV 
#
# Description  These tests aim to verify the handling of EAM MCs.
#               Cold Restart of the eam_common, eam_eac_idl, eamhandlerAPG30, eam_handlerlp, 
#               eam_handlerlp_Mgr, eam_handlerMs, eam_handlerMs_Mgr, eam_handlerMtp, eam_handlerText, eam_nrma, 
#               eam_hanlerIplx, eam_handlerIplx_Mgr functions correctly and that no core dump is generated.
# Prerequisites   

# REV HISTORY
# DATE                           BY                                 MODIFICATION
#  
#########################################################
#======================================================
#Fetching the MC's present in the server
$scalar=`/opt/ericsson/nms_cif_sm/bin/smtool -l |grep eam`;
my @val = split(' ', $scalar);

for($i=0;$i<scalar(@val);$i=$i+2)
{
$var1[$j]=$val[$i];
$j++;
}
my $MCs = join " ", @var1;
$cmd = `/opt/ericsson/nms_cif_sm/bin/smtool -coldrestart $MCs -reason="other" -reasontext=" "`;
print "\n Please wait as coldrestart is in progress ....";
system("$cmd");
sleep(90);

$progress = `/opt/ericsson/nms_cif_sm/bin/smtool list $MCs`;
chomp $progress;

open( TFH, ">coldrestart_tmp.txt" ) or die $!;
print TFH "$progress\n";
close(TFH);

open( HH, "coldrestart_tmp.txt" );
my @arr = <HH>;
close(HH);

foreach $y (@arr) {
     
    if ( $y =~ /started/ || $y =~ /^\s*$/ ) {
       
       #print "INFO  : EAM MC $& is cold started successfully";
	system("echo PASS >>coldrestart_result.txt");
        unlink("coldrestart_tmp.txt");
        
}
    else {
      
        #print "ERROR : EAM MC $& couldn't be cold started";
	system("echo FAIL >>coldrestart_result.txt");
        	 
    }
}
system("grep 'FAIL' coldrestart_result.txt");
if($? == 0)
{
print "\n Test script FAILED\n";
}
else
{
print "\n Test script PASSED\n";
system("rm coldrestart_result.txt");
}
