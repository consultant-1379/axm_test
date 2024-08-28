#!/usr/bin/perl
#
# SCRIPT NAME:AXM_FT_verify_the_PortNumber_NO_NODE.pl
# Test Case & Priority: AXM_FT_PortNumber (Pr.1)
# Test Case No : 7.2.5 (Common)
# AUTHOR: XROHAGR
# DATE  : 18\11\2013
# REV: A
#
# Description :
# Prerequisites  :
# Return Value on Success : 0
# Return Value on Failure : 1
# Result File : /home/nmsadm/eam/results
#
# Usage :  bash RUNME -t AXM_FT_verify_the_PortNumber_NO_NODE.pl:NO_NODE
#
# Dependency : Te.pm, crdmp.sh, PMSEerrorchk.sh
# OutPut Files: /home/nmsadm/PortNumber.log
# REV HISTORY
# DATE:                           BY                                 MODIFICATION:
#
##########################################################

# DEFINE FILES AND VARIABLES HERE

use Expect;

#$ntwrk_element=$ENV{ntwrk_element};
open(RFH,">AXM_FT_verify_the_PortNumber_NO_NODE.txt");
#======================================================================
$path="/etc/opt/ericsson/nms_eam_eac/";
$fname="init_ports_ehiplx";

	print RFH "PASS : Verifing the contents of $fname file under path $path\n";
   # Te::tex "$TC","INFO  : Verifing the contents of $fname file under path $path\n"; 
   
    ## Open a file.  If unsuccessful, print an error message and quit.

	open (FPTR,"/etc/opt/ericsson/nms_eam_eac/init_ports_ehiplx") || die "Can't Open File:$fname\n";
#           open (FPTR,$path/$fname);
	
	system("/bin/cat $path/$fname > /home/nmsadm/PortNumber.log"); 
	@filestuff = <FPTR>;  #Read the file into an array
	check_contents(@filestuff);
	
close (FPTR);         #Close the file
	
#=======================================================================


sub check_contents
{
        my @arr = @_;
		
		if ( grep(/65511:ehiplx_ac_in_1/,@arr) && grep(/65512:ehiplx_ac_in_2/,@arr) && grep(/65513:ehiplx_ac_in_3/,@arr) && grep(/65514:ehiplx_ac_in_4/,@arr) && grep(/65515:ehiplx_ac_in_5/,@arr) && grep(/65516:ehiplx_ac_in_6/,@arr) && grep(/65517:ehiplx_ac_in_7/,@arr) && grep(/65518:ehiplx_ac_in_8/,@arr) && grep(/65519:ehiplx_ac_in_9/,@arr))			
		{
			print RFH "PASS : Required Contents (Port Numbers) are present in the path /etc/opt/ericsson/nms_eam_eac/init_ports_ehiplx";
			#Te::tex "$TC", "INFO  : Required Contents (Port Numbers) are present in the path /etc/opt/ericsson/nms_eam_eac/init_ports_ehiplx";
              
		}
		else
		{
			print RFH "FAIL : Required Contents (Port Numbers) are not present in the path /etc/opt/ericsson/nms_eam_eac/init_ports_ehiplx";
		#	Te::tex "$TC", "ERROR  : Required Contents (Port Numbers) are not present in the path /etc/opt/ericsson/nms_eam_eac/init_ports_ehiplx";
              
		}
}
close(RFH);
system("/bin/cat AXM_FT_verify_the_PortNumber_NO_NODE.txt | /bin/grep FAIL ");
if ($? == 0)
{
print  "\nFAIL\n";
}
else
{
print "\nPASS\n";
#unlink("AXM_FT_verify_the_PortNumber_NO_NODE.txt");
}
