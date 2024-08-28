#!/usr/bin/perl
#
# SCRIPT NAME:AXM_FT_EAC_Start_Stop_Order_Sequence_NO_NODE.pl
# Test Case & Priority:AXM_FT_EAC_Start_Stop_Order_Sequence_NO_NODE (Pr.1)
# Test Case No : 7.2.6(common)
# AUTHOR : XNNNKKR
# DATE  : 11/10/2013
# REV : 14/08/2013
#
############################ Description############################################
#To verify the EAM MCs start order sequence in the server using smtool -config start | grep -i eam and 
#smtool -config stop | grep -i eam command.
####################################################################################
# Prerequisites  : None
# Return Value on Success : PASS
# Return Value on Failure   : FAIL
# Result File : View JCAT Report
# 
# Usage :  /usr/local/bin/perl AXM_FT_EAC_Start_Stop_Order_Sequence_NO_NODE.pl
# 
# Dependency : Te.pm, crdmp.sh, PMSEerrorchk.sh
# 
# REV HISTORY
# DATE:                           BY                                 MODIFICATION:
# 14/08/2014		xaksgan		Modified the script into TAF Compliant. 
#######################################################################################


my @EAM_MC_LIST = ("eam_common","eam_eac_idl","eam_handlerAPG30","eam_handlerIp","eam_handlerIp_Mgr","eam_handlerIpLx","eam_handlerIpLx_Mgr","eam_handlerMs","eam_handlerMs_Mgr","eam_handlerMtp","eam_handlerText","eam_nrma","eam_handlerEMA");   
open(RFH,">AXM_FT_EAC_Start_Stop_Order_Sequence_NO_NODE.txt");
#Checking the start order for all EAM MC are correct
foreach $mc (@EAM_MC_LIST)
{
	my $start = `/opt/ericsson/nms_cif_sm/bin/smtool -config start | /bin/grep -i $mc| head -1 > start.log`;
        	open (FH, "<start.log") or die $!;
	my @arr= <FH>;
	my $value; 
        	for(my $i=0;$i<scalar(@arr);$i++)
        	{
                	print $arr[$i];
	                my @st_order = split (' ', $arr[$i]);
                	$value = $st_order[1]; 
	}

	print "start = $value for $mc\n";
        	if ($value eq 10 || ($value eq 9 && $mc eq "eam_nrma"))
	{
		print RFH "\nPASS : Start order for $mc is proper\n";
        	}
        	else
        	{
		print RFH "\nFAIL : Start order for $mc is not proper\n";
        	}

       	 `/bin/rm -rf start.log`;
}

my @arr_mc33 = ("eam_eac_idl","eam_handlerAPG30","eam_handlerIp","eam_handlerEMA","eam_handlerMtp","eam_handlerText","eam_handlerMs");
my @arr_mc35 = ("eam_handlerIp_Mgr","eam_handlerIpLx","eam_handlerIpLx_Mgr","eam_handlerMs_Mgr","eam_common");

#Checking the stop order for all EAM MC are correct
foreach $mc (@EAM_MC_LIST)
{
	my $start = `/opt/ericsson/nms_cif_sm/bin/smtool -config stop | /bin/grep -i $mc| head -1 > stop.log`;
	open (FH, "<stop.log") or die $!;
	my @arr= <FH>;
        	my $value; 
        	for(my $i=0;$i<scalar(@arr);$i++)
        	{
                	print $arr[$i];
	                my @st_order = split (' ', $arr[$i]);
                	$value = $st_order[1];          
	}
 	print "stop = $value for $mc\n";
        	if ((grep(/^$mc$/,@arr_mc33) && $value eq 33) || (grep($mc,@arr_mc35) && $value eq 35) ||($value eq 34 && $mc eq "eam_nrma"))
        	{
		print RFH "PASS : Stop order for $mc is proper\n";
          	}
        	else
        	{
		print RFH "FAIL : Stop order for $mc is not proper"; 
             	}

       	 `/bin/rm -rf stop.log`;
}

close(RFH);
system("/bin/cat AXM_FT_EAC_Start_Stop_Order_Sequence_NO_NODE.txt | /bin/grep FAIL ");
if ($? == 0)
{
	print  "\nFAIL\n";
}
else
{
	print "\nPASS\n";
}

