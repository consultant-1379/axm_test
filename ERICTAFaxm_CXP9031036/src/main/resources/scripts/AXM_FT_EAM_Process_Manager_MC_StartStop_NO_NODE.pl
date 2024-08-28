#!/usr/bin/perl
#
# SCRIPT NAME:AXM_FT_EAM_Process_Manager_MC_StartStop_NO_NODE.pl
# Test Case & Priority: AXM_FT_EAM_Process_Manager_MC_StartStop (Pr.1)
# Test Case No : 5.9.1
# AUTHOR:
# DATE  : 
# REV: 
#
################################### Description #######################################
# This test case checks that the start order and stop order of the EAM MCs are proper #
####################################################################################### 
# Prerequisites  : 
# Return Value on Success : 0
# Return Value on Failure   : 1
# Result File : /home/nmsadm/eam/results
# 
# Usage :  bash RUNME -t AXM_FT_EAM_Process_Manager_MC_StartStop_NO_NODE.pl:NO_NODE
# 
# Dependency : Te.pm, crdmp.sh, PMSEerrorchk.sh
# 
# REV HISTORY
# DATE:                           BY                                 MODIFICATION:
#  
##########################################################

# DEFINE FILES AND VARIABLES HERE




my @EAM_MC_LIST = ("eam_common","eam_eac_idl","eam_handlerAPG30","eam_handlerIp","eam_handlerIp_Mgr","eam_handlerIpLx","eam_handlerIpLx_Mgr","eam_handlerMs","eam_handlerMs_Mgr","eam_handlerMtp","eam_handlerText","eam_nrma","eam_handlerEMA");   


#========================================================================
#Checking the start order for all EAM MC are correct
open(RFH,">AXM_FT_EAM_Process_Manager_MC_StartStop_NO_NODE.txt");
foreach $mc (@EAM_MC_LIST)
{
        my $start = `/opt/ericsson/nms_cif_sm/bin/smtool -config start | /bin/grep -i $mc| /bin/head -1 > start.log`;
        open (FH, "<start.log") or die $!;
        my @arr= <FH>;
        my $value; 
        for(my $i=0;$i<scalar(@arr);$i++)
        {
                print $arr[$i];
                my @st_order = split (' ', $arr[$i]);
                $value = $st_order[1];          
				#chomp($value);    
        }
                print "start = $value for $mc\n";
        if ($value eq 10 || ($value eq 9 && $mc eq "eam_nrma"))
        {
				print RFH "PASS : Start order for $mc is proper\n"; 
              #  Te::tex "$TC", "INFO  :Start order for $mc is proper"; 
        }
        else
        {
				print RFH "FAIL : Start order for $mc is not proper\n";
              #  Te::tex "$TC", "ERROR  : Start order for $mc is not proper";
        }

                system("/bin/rm -rf start.log ");
}

my @arr_mc33 = ("eam_eac_idl","eam_handlerAPG30","eam_handlerIp","eam_handlerEMA","eam_handlerMtp","eam_handlerText","eam_handlerMs");
my @arr_mc35 = ("eam_handlerIp_Mgr","eam_handlerIpLx","eam_handlerIpLx_Mgr","eam_handlerMs_Mgr","eam_common");

#Checking the stop order for all EAM MC are correct
foreach $mc (@EAM_MC_LIST)
{
        my $start = `/opt/ericsson/nms_cif_sm/bin/smtool -config stop | /bin/grep -i $mc| /bin/head -1 > stop.log`;
        open (FH, "<stop.log") or die $!;
        my @arr= <FH>;
        my $value; 
        for(my $i=0;$i<scalar(@arr);$i++)
        {
                print $arr[$i];
                my @st_order = split (' ', $arr[$i]);
                $value = $st_order[1];          
				#chomp($value);    
        }
                print "stop = $value for $mc\n";
        if ((grep(/^$mc$/,@arr_mc33) && $value eq 33) || (grep($mc,@arr_mc35) && $value eq 35) ||($value eq 34 && $mc eq "eam_nrma"))
        {
				print RFH "PASS : Stop order for $mc is proper\n"; 
             #   Te::tex "$TC", "INFO  :Stop order for $mc is proper"; 
        }
        else
        {
				print RFH "FAIL :  Stop order for $mc is not proper\n";
               # Te::tex "$TC", "ERROR  : Stop order for $mc is not proper";
        }

                system("/bin/rm -rf stop.log ");
}

#=======================================================================
#FRAME::end_frame "$TC";
close(RFH);
system("/bin/cat AXM_FT_EAM_Process_Manager_MC_StartStop_NO_NODE.txt | /bin/grep FAIL ");
if ($? == 0)
{
print  "\nFAIL\n";
}
else
{
print "\nPASS\n";
}
