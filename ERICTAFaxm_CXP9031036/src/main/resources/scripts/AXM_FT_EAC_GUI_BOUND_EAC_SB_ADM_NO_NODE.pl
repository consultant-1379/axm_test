#!/use/bin/perl
# SCRIPT NAME: AXM_FT_EAC_GUI_BOUND_EAC_SB_ADM_NO_NODE.pl
# Test Case & Priority: AXM_FT_EAC_GUI_BOUND_EAC_SB_ADM_NO_NODE (Pr.1)
# Test Case No :5.2.4
# AUTHOR: XNNNKKR
# DATE  :02/05/2013
# REV:1.0
#
# Description :Verifying the eac_sb_adm -l command execution 
#using nmsadm and DUMMY(Void of command execution permission) user.
# Return Value on Success : PASS
# Return Value on Failure : FAIL
# 
#
# Usage :  /usr/local/bin/perl AXM_FT_EAC_GUI_BOUND_EAC_SB_ADM_NO_NODE.pl.
#
# Dependency : Root Password should be tds1439,modify the standalone server password accordingly
#
# REV HISTORY
#REV HISTORY
# DATE:                           BY                                 MODIFICATION:
# 11/08/2014                      XNNNKKR	          Logic #incorporated for running         the use case in vapps and #standalone server.
##########################################################


use Expect;

open(RFH,">AXM_FT_EAC_GUI_BOUND_EAC_SB_ADM_NO_NODE.txt");

sub execution_nmsadm
{
	print "\nExecuting for nmsadm\n";
	system("/opt/ericsson/bin/eac_sb_adm -l > /home/nmsadm/eac_sb_adm_nmsadm.log");
  
	if ( $? == 0 ) 
	{
    
		print RFH "PASS : Parameter list is updated in the temporary log\n";
	}
	else 
	{
		print RFH "FAIL: There is error in updating temporary log\n";
	}

}

sub cmd
{
	print "\nExecuting for DUMMY\n";
 	$expect = Expect->spawn("su - root");
  	
          $expect->log_file("/home/nmsadm/eac_sb_adm_dummy.log","w");
  	$expect->expect (10,'Password:');
  	$expect->send("shroot12\r");
  	$expect->expect (5,'#');
  	$expect->send("tcsh\r");
  	$expect->expect (5,'>');
  	$expect->send("su - DUMMY\r");
  	$expect->expect (5,'>'); 
  	$expect->send("/opt/ericsson/bin/eac_sb_adm -l\r");
  	$expect->expect (10,'1>');
  	$expect->soft_close();
} 

sub cmd1
{
	print "\nExecuting for DUMMY\n";
  	$expect = Expect->spawn("su - root");
  	
$expect->log_file("/home/nmsadm/eac_sb_adm_dummy.log","w");
  	$expect->expect (10,'Password:');
  	$expect->send("shroot12\r");
  	$expect->expect (5,'#');
  	$expect->send("tcsh\r");
  	$expect->expect (5,'>');
  	$expect->send("su - DUMMY\r");
  	$expect->expect (5,'>'); 
 	$expect->send("/opt/ericsson/bin/eac_sb_adm -l\r");
  	$expect->expect (10,'1>');
  	$expect->soft_close();
} 
sub dummy
{
 	system(" ls -lrt /home/ | /usr/bin/grep DUMMY");
  	if($? == 0)
  	{
  		print "User Already Exists\n";
  		cmd;
  	}
  	else
   	{
  		$expect3 = Expect->spawn("su - root");
  		
$expect3->log_file("/home/nmsadm/eac_sb_adm_config_user_creation_mas.log","w");
  		$expect3->expect (10,'Password:');
  		$expect3->send("shroot12\r");
  		$expect3->expect (10,'#');
  		$expect3->send("tcsh\r");
  		$expect3->expect (10,'>');
 		$expect3->send("/opt/ericsson/sck/bin/oss_adduser.sh -l yes DUMMY custom\r");
  		$expect3->expect (10,'New Password:');
  		$expect3->send("wipro123\r");
  		$expect3->expect (10,'Re-enter new Password:');
  		$expect3->send("wipro123\r");
  		$expect3->expect (100,'>');
  		$expect3->soft_close();
 		cmd;  

 	}

}
execution_nmsadm;
$server= `/opt/ericsson/bin/eac_esi_config -nl`;

if($server =~ vts)
{
	print "it is a vapp server\n";
	system(" ls -lrt /home/ | /usr/bin/grep DUMMY");
	if($? == 0)
	{
		print "User Already Exists\n";
		cmd1;
	}
	else
	{
		$expect1 = Expect->spawn("su - root");
		
$expect1->log_file("/home/nmsadm/eac_sb_adm_config_user_creation_uas.log","w");
  		$expect1->expect (10,'Password:');
  		$expect1->send("shroot12\r");
  		$expect1->expect (5,'#');
  		$expect1->send("tcsh\r");
  		$expect1->expect (5,'>');
  		$expect1->send("ssh omsrvm\r");
  		$expect1->expect (5,'#');
  		$expect1->send("tcsh\r");
  		$expect1->expect (5,'#');
  		
$expect1->send("/ericsson/opendj/bin/add_user.sh\r");
  		$expect1->expect (5,'LDAP Directory Manager password:');
  		$expect1->send("ldappass\r");
  		$expect1->expect (5,'New local user name:');
  		$expect1->send("DUMMY\r");
  		$expect1->expect (5,'Start of uidNumber search range [1000]:');
  		$expect1->send("1000\r");
  		$expect1->expect (5,'End of uidNumber search range [59999]:');
  		$expect1->send("59999\r");
   		$expect1->expect (5,'New local user uidNumber [1010]:');
  		$expect1->send("1224\r");
   		$expect1->expect (5,'New local user password:');
  		$expect1->send("wipro123\r");
   		$expect1->expect (5,'Re-enter password:');
  		$expect1->send("wipro123\r");
  		$expect1->expect (5,'New local user category <appl_adm, ass_ope, nw_ope, ope, sys_adm, custom> [ass_ope]:');
  		$expect1->send("custom\r");
  		$expect1->expect (5,'New local user description [OSS-RC user]:');
  		$expect1->send("abc\r");
 		$expect1->expect (5,'Continue to create local user [YYY] as user type [OSS_ONLY] with uidNumber [1005] and user category [custom] (y/n)? [y]');
  		$expect1->send("y\r");
  		$expect1->expect (25,'#');
  		$expect1->send("exit\r");
  		$expect1->expect (10,'#');
  		$expect1->send("exit\r");
  		$expect1->expect (10,'>');
  		$expect1->soft_close();
		cmd1;
	}
}
else
{
	print "It is a master server\n";
	dummy;
}



system("/usr/bin/grep not /home/nmsadm/eac_sb_adm_dummy.log && /usr/bin/grep TSS /home/nmsadm/eac_sb_adm_dummy.log");

if( $? == 0 )
{
	print RFH "PASS :Authorisation error is displayed\n";
}
else
{

	print RFH "FAIL :Authorisation error is not displayed\n";
}
   
close(RFH);
system("/usr/bin/grep FAIL AXM_FT_EAC_GUI_BOUND_EAC_SB_ADM_NO_NODE.txt");
if ($? == 0)
{
	print  "FAIL\n";

}
else
{
	print "PASS\n";

}
