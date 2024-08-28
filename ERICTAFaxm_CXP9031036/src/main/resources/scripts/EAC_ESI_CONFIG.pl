#!/use/bin/perl
#
# SCRIPT NAME:AXM_FT_EAC_GUI_BOUND_EAC_EGI_CONFIG.pl
# Test Case & Priority: AXM_FT_EAC_GUI_BOUND_EAC_EGI_CONFIG (Pr.1)
# Test Case No :5.2.5
# AUTHOR: XNNNKKR
# DATE  :
# REV:
#
# Description :
# Prerequisites  :Root Password should be shroot
# Return Value on Success : 0
# Return Value on Failure : 1
# Result File : /home/nmsadm/eam/results
#
# Usage :  bash RUNME -t AXM_FT_EAC_GUI_BOUND_EAC_EGI_CONFIG_NO_NODE.pl:NO_NODE.
#
# Dependency : Te.pm, crdmp.sh, PMSEerrorchk.sh
#
# REV HISTORY
# DATE:                           BY                                 MODIFICATION:
#
##########################################################

# DEFINE FILES AND VARIABLES HERE

use Expect;



#========================================================================

open(RFH,">>EAC_EGI_CONFIG.txt");
 

   print "\nExecuting for nmsadm\n";
   system("eac_egi_config -l > eac_egi_config_nmsadm.log");
  
@size_search = `egrep "TMOS_node\|FILE_NOTIFICATION_ON" eac_egi_config_nmsadm.log`;

if ( scalar(@size_search) == 2 )
 {
 print RFH "PASS:Parameter list is updated in the temporary log\n";    
#Te::tex "$TC", "\nINFO  : Parameter list is updated in the temporary log";
}
else {
 print RFH "FAIL:There is error in updating temporary log\n";
    #Te::tex "$TC", "\nERROR  : There is error in updating temporary log";
    
}

#Te::tex "$TC", " ";

#Verify the admintool command as the dummy user


sub cmd
 {
  my $expect;
  $expect = Expect->spawn("su - DUMMY");
  $expect->log_file("eac_egi_config_dummy.log");
  $expect->expect (10,'Password:');
  $expect->send("wipro123\r");
  $expect->expect (10,'1>');
  $expect->send("eac_egi_config -l\r");
  $expect->expect (10,'1>');
  $expect->soft_close();
  } 


print "\nExecuting for DUMMY\n";
#print "#########################################################################
##############\n";

 sub dummy
{
  $Tss_user=`userAdmin -list`;
  if($Tss_user =~ DUMMY)
   {
  print " User Already Exists\n";
 #  Te::tex "$TC","INFO  : User Already Exists";
   cmd;
   }
   else
   {
  my $expect1;
  $expect1 = Expect->spawn("su - root");
  $expect1->log_file("eac_egi_config_user_creation.log");
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

  system("cat eac_egi_config_dummy.log | grep not > /dev/null");
if ($? == 0)
{
print RFH "PASS:Authorisation error is displayed\n";
#Te::tex "$TC","INFO  : Authorisation error is displayed";
}
else
{
print RFH "FAIL:Authorisation error is not displayed\n";
#Te::tex "$TC", "ERROR  : Authorisation error is not displayed";
}
close(RFH);
   

system("cat EAC_EGI_CONFIG.txt | grep FAIL ");
if ($? == 0)
{
print  "FAIL\n";
#Te::tex "$TC","INFO  : Authorisation error is displayed";
}
else
{
print "PASS\n";
#Te::tex "$TC", "ERROR  : Authorisation error is not displayed";
}

#=======================================================================
#FRAME::end_frame "$TC";

