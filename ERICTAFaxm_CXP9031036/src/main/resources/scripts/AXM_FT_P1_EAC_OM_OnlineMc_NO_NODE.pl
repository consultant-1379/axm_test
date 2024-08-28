#!/use/bin/perl
#
# SCRIPT NAME: AXM_FT_P1_EAC_OM_OnlineMc_NO_NODE.pl
# Test Case & Priority: AXM_FT_EAC_OM_StartMc_NO_NODE (Pr.1)
# Test Case No : 5.3.1 (FT Common Spec)
# AUTHOR: XNNNKKR
# DATE  : 
# REV: 
#
# Description : These tests aim to verify the handling of EAM MCs.
#               Start of the eam_common, eam_eac_idl, eamhandlerAPG30, eam_handlerlp, 
#               eam_handlerlp_Mgr, eam_handlerMs, eam_handlerMs_Mgr, eam_handlerMtp, eam_handlerText, eam_nrma, 
#               eam_hanlerIplx, eam_handlerIplx_Mgr functions correctly and that no core dump is generated.
# Prerequisites  : 
# Return Value on Success : 0
# Return Value on Failure   : 1

# REV HISTORY
# DATE:                           BY   MODIFICATION:
#  
##########################################################

# DEFINE FILES AND VARIABLES HERE
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
$cmd = `/opt/ericsson/nms_cif_sm/bin/smtool -online $EAM_MC_LIST`;
print "Please wait for 80 seconds as online of MC is in progress....";
system("$cmd");
sleep(80);


my $MC_status = `/opt/ericsson/nms_cif_sm/bin/smtool -l $EAM_MC_LIST`;
chomp $MC_status;
open( LFH, ">>online_tmp.txt" ) or die $!;
print LFH "$MC_status\n";
close(LFH);

open( HH, "online_tmp.txt" );
my @arr = <HH>;
close(HH);

#unlink("online_tmp.txt");

foreach $y (@arr) {
    if ( $y =~ /started/ || $y =~ /^\s*$/ ) 
	{
        chomp $y;
        
		#print"INFO  :Command execution PASSED:EAM MC $& is made online successfully";
	system("echo PASS >>online_result.txt");
        unlink("online_tmp.txt");
        
    }
    else 
	{
        $y=~/.*\s/;
    	#print "ERROR  :Command execution FAILED\n";
	system("echo FAIL >>Onfline_result.txt");
        
        
    }
}
system("/bin/grep 'FAIL' online_result.txt");
if($? == 0)
{
print "\n Test script FAILED\n";
}
else
{
print "\n Test script PASSED\n";
system("rm online_result.txt");
}



