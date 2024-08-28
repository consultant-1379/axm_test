#!/use/bin/perl
#
# SCRIPT NAME:AXM_FT_EAM_Process_Manager_MC_FileExistence_NO_NODE.pl
# Test Case & Priority: AXM_FT_EAM_Process_Manager_MC_FileExistence (Pr.1)
# Test Case No :5.9.1
# AUTHOR:
# DATE  :
# REV:
#
############################### Description ######################################
# This test case checks that the process manager MCs are added and working fine. #
##################################################################################
# Prerequisites  :
# Return Value on Success : 0
# Return Value on Failure : 1
# Result File : /home/nmsadm/eam/logs
#
# Usage :  bash RUNME -t AXM_FT_EAM_Process_Manager_MC_FileExistence_NO_NODE.pl:NO_NODE
#
# Dependency : Te.pm, crdmp.sh, PMSEerrorchk.sh
#
# REV HISTORY
# DATE:                           BY                                 MODIFICATION:
#
##########################################################

# DEFINE FILES AND VARIABLES HERE



#========================================================================
open(RFH,">AXM_FT_EAM_Process_Manager_MC_FileExistence_NO_NODE.txt");
print "Checking for existence of files associated with EAM_Process_Manager\n";

my $res = 0;
opendir (DH,"/etc/opt/ericsson/nms_eam_eac/") or die "Couldn't open dir : $!";
my @files = readdir DH;

check_files(@files);

closedir DH;

print "Checking the contents of the file\n";


check_contents("/etc/opt/ericsson/nms_eam_eac/init_ports_ehip","/home/nmsadm/eam/bin/INPUT/init_ports_ehip_test");
check_contents("/etc/opt/ericsson/nms_eam_eac/init_ports_ehms","/home/nmsadm/eam/bin/INPUT/init_ports_ehms_test");
check_contents("/etc/opt/ericsson/nms_eam_eac/eam_initiator.conf","/home/nmsadm/eam/bin/INPUT/eam_initiator.conf_test");
#=======================================================================



sub check_files
{
        my @arr = @_;
		
		if ( grep(/init_ports_ehip/,@arr) && grep(/init_ports_ehms/,@arr) && grep(/eam_initiator.conf/,@arr))			
		{
			print RFH "PASS : Files are present in the path /etc/opt/ericsson/nms_eam_eac/\n";
		#	Te::tex "$TC", "INFO  : Files are present in the path /etc/opt/ericsson/nms_eam_eac/";
              
		}
		else
		{
			print RFH "FAIL : Files are not present in the path /etc/opt/ericsson/nms_eam_eac/\n";
			#Te::tex "$TC", "ERROR  : Files are not present in the path /etc/opt/ericsson/nms_eam_eac/";
              
		}
		
		
}
sub check_contents
{

	my ( $fileA, $fileB ) = @_;	
    open my $file1, '<', $fileA;
    open my $file2, '<', $fileB;

    while (my $lineA = <$file1>) {
        next if $lineA eq <$file2>;
	print RFH "FAIL : Contents of the file are not proper\n";
       # Te::tex "$TC", "ERROR  : Contents of the file are not proper"; 
		last;
    }

	print RFH "PASS : Contents of the file are proper\n"; 
  #  Te::tex "$TC", "INFO  : Contents of the file are proper"; 
}
close(RFH);
system("/bin/cat AXM_FT_EAM_Process_Manager_MC_FileExistence_NO_NODE.txt | /bin/grep FAIL ");
if ($? == 0)
{
print  "\nFAIL\n";
}
else
{
print "\nPASS\n";
}

