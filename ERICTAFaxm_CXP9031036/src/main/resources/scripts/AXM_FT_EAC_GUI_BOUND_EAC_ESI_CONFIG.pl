#!/usr/bin/perl
#
# SCRIPT NAME:AXM_FT_EAC_GUI_BOUND_EAC_ESI_CONFIG.pl
# Test Case & Priority: AXM_FT_EAC_GUI_BOUND_EAC_ESI_CONFIG (Pr.1)
# Test Case No : 5.2.3(Common)
# AUTHOR:XNNNKKR
# DATE  :
# REV:
#
################################ Description ######################
#This test case checks that EAM client eac_esi_config fetches proper authority 
#data from TSS using GUI Bound Naming Service.
###################################################################
# Prerequisites  :Root user password should be shroot
# Return Value on Success : 0
# Return Value on Failure : 1
# Result File : /home/nmsadm/eam/results
#
# Usage :  bash RUNME -t AXM_FT_EAC_GUI_BOUND_EAC_ESI_CONFIG_NO_NODE.pl:NO_NODE.
#
# Dependency : Te.pm, crdmp.sh, PMSEerrorchk.sh
#
# REV HISTORY
#DATE
#MODIFICATION BY
##########################################################

# DEFINE FILES AND VARIABLES HERE
#use Te;
#use FRAME;
use Expect;
#use util;
#my $EAM_DIR    = $ENV{EAM_DIR};
#my $TC         = "AXM_FT_EAC_GUI_BOUND_EAC_ESI_CONFIG_NO_NODE";
#my $RESULT_DIR = $ENV{RESULT_DIR};
#my $TMP        = $ENV{TMP};
#$ENV{tc} = AXM_FT_EAC_GUI_BOUND_EAC_ESI_CONFIG_NO_NODE;


#FRAME::start_frame "$TC";
#========================================================================



open(RFH,">AXM_FT_EAC_GUI_BOUND_EAC_ESI_CONFIG_NO_NODE.txt");


print "\nExecuting for nmsadm\n";
system("/opt/ericsson/bin/eac_esi_config -nelist > eac_esi_config_nmsadm.log");
  
@size_search = `/bin/egrep "NAME\|PROTOCOL\|vts.com\|athtem.eei.ericsson.se" eac_esi_config_nmsadm.log`;

if ( scalar(@size_search) == 2 ) {
	print RFH "PASS : Parameter list is updated in the temporary log\n";
#    Te::tex "$TC", "\nINFO  : Parameter list is updated in the temporary log";
}
else {
	print RFH "FAIL : There is error in updating temporary log";
#    Te::tex "$TC", "\nERROR  : There is error in updating temporary log";
    
}

#Te::tex "$TC", " ";

#Verify the admintool command as the dummy user


sub cmd
 {
		
  my $expect;
  $expect = Expect->spawn("/bin/su - DUMMY");
  $expect->log_file("eac_esi_config_dummy.log");
  $expect->expect (10,'Password:');
  $expect->send("wipro123\r");
  $expect->expect (10,'1>');
  $expect->send("/opt/ericsson/bin/eac_esi_config -nelist\r");
  $expect->expect (10,'1>');
  $expect->soft_close();
  } 


print "\nExecuting for DUMMY\n";
print "#########################################################################
##############\n";

 sub dummy
{
  $Tss_user=`userAdmin -list`;
  if($Tss_user =~ DUMMY)
   {
	print RFH "PASS : User Already Exists\n";
	
#   Te::tex "$TC","INFO  : User Already Exists";
   cmd;
   }
   else
   {
 my $expect1;
  $expect1 = Expect->spawn("/bin/su - root");
  $expect1->log_file("eac_esi_config_user_creation.log");
  $expect1->expect (10,'Password:');
  $expect1->send("shroot\r");
  $expect1->expect (10,'#');
  $expect1->send("tcsh\r");
  $expect1->expect (10,'>');
  $expect1->send("oss_adduser.sh -l yes DUMMY custom\r");
  $expect1->expect (10,'New Password:');
  $expect1->send("wipro123\r");
  $expect1->expect (10,'Re-enter new Password:');
  $expect1->send("wipro123\r");
  $expect1->expect (100,'>');
  $expect1->soft_close();
  cmd;  

 }

}

dummy;

system("/bin/cat eac_esi_config_dummy.log | /bin/grep not > /dev/null");
if ($? == 0)
{
	print RFH "PASS : Authorisation error is displayed\n";
#Te::tex "$TC","INFO  : Authorisation error is displayed";
}
else
{
	print RFH "FAIL : Authorisation error is not displayed\n";
#Te::tex "$TC", "ERROR  : Authorisation error is not displayed";
}
close(RFH);

system("/bin/cat AXM_FT_EAC_GUI_BOUND_EAC_ESI_CONFIG_NO_NODE.txt | /bin/grep FAIL ");
if ($? == 0)
{
print  "\nFAIL\n";
}
else
{
print "\nPASS\n";
#unlink("AXM_FT_EAC_GUI_BOUND_EAC_ESI_CONFIG_NO_NODE.txt");
}
   



#=======================================================================
#FRAME::end_frame "$TC";
