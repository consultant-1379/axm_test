#!/usr/bin/perl
#
# SCRIPT NAME: AXM_FT_P1_EAC_OM_WarmRestartMc_NO_NODE.pl
# Test Case & Priority: AXM_FT_EAC_OM_WarmStartMc_NO_NODE (Pr.1)
# Test Case No : 5.3.3
# AUTHOR:XNNNKKR
# DATE  :20/05/2014
# REV: 1.0
#
# Description : These tests aim to verify the handling of EAM MC??s.
#               Warm Restart of the eam_common, eam_eac_idl, eamhandlerAPG30, eam_handlerlp, 
#               eam_handlerlp_Mgr, eam_handlerMs, eam_handlerMs_Mgr, eam_handlerMtp, eam_handlerText, eam_nrma, 
#               eam_hanlerIplx, eam_handlerIplx_Mgr functions correctly and that no core dump is generated.
# Return Value on Success : PASS
# Return Value on Failure : FAIL
# 
# Usage :  /usr/local/bin/perl AXM_FT_P1_EAC_OM_WarmRestartMc_NO_NODE.pl 
# 
# Dependency : NA
# 
# REV HISTORY
# DATE:                           BY                                 MODIFICATION:
# 02/09/2014			XNNNKKR        	      Modified the script to TAF Compliant.
###################################################################
open(RFH,">AXM_FT_P1_EAC_OM_WarmRestartMc_NO_NODE.txt");

$scalar=`/opt/ericsson/nms_cif_sm/bin/smtool -l |/bin/grep eam`;
my @val = split(' ', $scalar);

for($i=0;$i<scalar(@val);$i=$i+2)
{
$var1[$j]=$val[$i];
$j++;
}
my $MCs = join " ", @var1;
$cmd = `/opt/ericsson/nms_cif_sm/bin/smtool -warmrestart $MCs -reason="other" -reasontext=" "`;
print "\nPlease wait as Warmrestart is in progress ....";;
sleep(10);
$progress = `/opt/ericsson/nms_cif_sm/bin/smtool list $MCs`;
chomp $progress;
open( TFH, ">/home/nmsadm/tmp.txt" ) or die $!;
print TFH "$progress\n";
close(TFH);
open( HH, "/home/nmsadm/tmp.txt" );
my @arr = <HH>;
close(HH);

#unlink("/home/nmsadm/tmp.txt");

foreach $y (@arr) {
     
     chomp($y);
    if ( $y =~ /started/ || $y =~ /^\s*$/ ) {
       
      print RFH "PASS : EAM MC $& is warm started successfully\n";
      
        
        
}
    else {
        print RFH "FAIL :EAM MC $& couldn't be warm started\n";
        
        	 
    }
}

close(RFH);

system("/bin/cat AXM_FT_P1_EAC_OM_WarmRestartMc_NO_NODE.txt | /bin/grep FAIL ");
if ($? == 0)
{
	print  "\nFAIL\n";
}
else
{
	print "\nPASS\n";
}
