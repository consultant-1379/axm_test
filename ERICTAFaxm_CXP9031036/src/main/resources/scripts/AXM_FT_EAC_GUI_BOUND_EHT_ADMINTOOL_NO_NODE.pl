#!/use/bin/perl
#
# SCRIPT NAME: AXM_FT_EAC_GUI_BOUND_EHT_ADMINTOOL_NO_NODE.pl
# Test Case & Priority: AXM_FT_EAC_GUI_BOUND_EHT_ADMINTOOL_NO_NODE (Pr.1)
# Test Case No :5.2.4
# AUTHOR: XNNNKKR
# DATE  :11/10/2013
# REV:1.0
#
# Description :Verification of eht_admintool command with nmsadm(full permission) and dummy(no permission) user
# Return Value on Success : PASS
# Return Value on Failure : FAIL
#
# Usage :  /usr/local/bin/perl AXM_FT_EAC_GUI_BOUND_EHT_ADMINTOOL_NO_NODE.pl.
#
# Dependency :Root Password should be shroot
#
# REV HISTORY
# DATE:                           BY                                 MODIFICATION:
#11/08/2014                     XNNNNKKR	                 Modified the script into TAF Compliant.
##########################################################


use Expect;
open(RFH,">AXM_FT_EAC_GUI_BOUND_EHT_ADMINTOOL_NO_NODE.txt");

sub execution_nmsadm
{
	print "\nExecuting for nmsadm\n";
  	my $expect5;
  	$expect5 = Expect->spawn("/opt/ericsson/bin/eht_admintool");
  	$expect5->log_file("/home/nmsadm/eht_admintool_nmsadm.log","w");
  	$expect5->expect (10,'<');
 	$expect5->send("quit\r");
	$expect5->soft_close();
  
}
execution_nmsadm;
system("/usr/bin/grep Allocator /home/nmsadm/eht_admintool_nmsadm.log && /usr/bin/grep Device /home/nmsadm/eht_admintool_nmsadm.log");


if ( $? == 0 ) 
{
	print RFH "PASS:Eht_admintool command is working fine\n";

}
else 
{
	print RFH "FAIL:Eht_admintool command is not working as expected\n";

}

sub cmd
{
	print "\nExecuting for DUMMY\n";
  	$expect = Expect->spawn("su - root");
  	$expect->log_file("/home/nmsadm/eht_admintool_dummy.log","w");
  	$expect->expect (10,'Password:');
  	$expect->send("shroot\r");
  	$expect->expect (5,'#');
  	$expect->send("tcsh\r");
  	$expect->expect (5,'>');
  	$expect->send("su - DUMMY\r");
  	$expect->expect (5,'>'); 
  	$expect->send("/opt/ericsson/bin/eht_admintool\r");
  	$expect->expect (10,'1>');
  	$expect->soft_close();
} 

sub cmd1
{
	print "\nExecuting for DUMMY\n";
	$expect = Expect->spawn("su - root");
 	$expect->log_file("/home/nmsadm/eht_admintool_dummy.log","w");
  	$expect->expect (10,'Password:');
  	$expect->send("shroot\r");
	

  	$expect->expect (5,'#');
  	$expect->send("tcsh\r");
  	$expect->expect (5,'>');
  	$expect->send("su - DUMMY\r");
  	$expect->expect (5,'>'); 
  	$expect->send("/opt/ericsson/bin/eht_admintool\r");
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
  		$expect3->log_file("/home/nmsadm/eht_admintool_config_user_creation_mas.log","w");
  		$expect3->expect (10,'Password:');
  		$expect3->send("shroot\r");
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

$server=`/opt/ericsson/bin/eac_esi_config -nl`;

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
  		$expect1->log_file("/home/nmsadm/eht_admintool_config_user_creation_uas.log","w");
  		$expect1->expect (10,'Password:');
  		$expect1->send("shroot\r");
  		$expect1->expect (5,'#');
  		$expect1->send("tcsh\r");
  		$expect1->expect (5,'>');
  		$expect1->send("ssh omsrvm\r");
  		$expect1->expect (5,'#');
  		$expect1->send("tcsh\r");
  		$expect1->expect (5,'#');
  		$expect1->send("/ericsson/sdee/bin/add_user.sh\r");
  		$expect1->expect (5,'LDAP Directory Manager password:');
  		$expect1->send("ldappass\r");
  		$expect1->expect (5,'New local user name:');
  		$expect1->send("DUMMY\r");
  		$expect1->expect (5,'Start of uidNumber search range [1000]:');
  		$expect1->send("1000\r");
  		$expect1->expect (5,'End of uidNumber search range [59999]:');
  		$expect1->send("59999\r");
   		$expect1->expect (5,'New local user uidNumber [1010]:');
  		$expect1->send("1011\r");
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



system("/usr/bin/grep NOT /home/nmsadm/eht_admintool_dummy.log");

if( $? == 0 )
{
	print RFH "PASS:Authorisation error is displayed\n";
	
}
else
{
	print RFH "FAIL:Authorisation error is not displayed\n";
}
   
close(RFH);

system("/usr/bin/grep FAIL AXM_FT_EAC_GUI_BOUND_EHT_ADMINTOOL_NO_NODE.txt");
if ($? == 0)
{
	print  "FAIL\n";
}
else
{
	print "PASS\n";

}
