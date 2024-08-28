 #!/use/bin/perl
#
# SCRIPT NAME:AXM_FT_P1_EAC_INST_Installation_NO_NODE.pl
# Test Case & Priority: AXM_FT_EAC_INST_Installation_NO_NODE  (Pr.1)
# Test Case No :5.1.1(common)
# AUTHOR:xharcha
# DATE  :
# REV:
#
# Description :
# Prerequisites  :
# Return Value on Success : 0
# Return Value on Failure : 1
# Result File : /home/nmsadm/eam/results
#

# REV HISTORY
# DATE:                           BY                                 MODIFICATIO
#N:
#
##########################################################
#========================================================================

my @rstate_list = `/opt/ericsson/nms_cif_ist/bin/cist -status | /bin/grep -i eam | /bin/grep nms_eam | awk '{print \$NF}'`;
my @mc_list = `/opt/ericsson/nms_cif_ist/bin/cist -status | /bin/grep -i eam | /bin/grep nms_eam | awk '{print \$1}'`;

my $rstate = `/bin/pkginfo -l ERICfeam | sed -n '5p'| awk '{print \$2}'`;
$c = 0;
foreach $r (@rstate_list) {
     if ( "$r" eq "$rstate")
         {
               print "\n\nINFO  : Rstate for $mc_list[$c] is updated as per the shipment:$rstate\n";
		system("echo PASS >>install_result.txt");
         }
        else {
                print "\n\nERROR  : Rstate for $mc_list[$c] is not updated as per the shipment:$rstate\n";
		system("echo FAIL >>install_result.txt");
         }
	$c++;
    }

my $FAIL = `/opt/ericsson/nms_cif_ist/bin/cist -status | grep -i eam | grep FAILED`;
if($FAIL)
 {
        print "ERROR  : Instalation is failed... Failure in cist status\n";
	system("echo FAIL >>install_result.txt");
  }
 else
  {
        print "\n\nINFO  : cist status is updated properly\n";
	system("echo PASS >>install_result.txt");
  }


my  @MC_status = `/opt/ericsson/nms_cif_sm/bin/smtool -l | grep eam | awk '{print \$2}'`;
my  @MC_names = `/opt/ericsson/nms_cif_sm/bin/smtool -l | grep eam | awk '{print \$1}'`;
$count = 0;
foreach $MC (@MC_status)
        {  
           
		if( "$MC" =~ /started/ )
                {
                        print "\n\nINFO  :$MC_names[$count] MC started successfully\n";
			system("echo PASS >>install_result.txt");
                }
                else
                {
                        print "ERROR  :$MC_names[$count] MC not started\n";
			system("echo FAIL >>install_result.txt");
                }
		$count++;
        }


system("/bin/grep 'FAIL' install_result.txt");
if($? == 0)
{
print "\n Test script FAILED\n";
system("rm install_result.txt");

}
else
{
print "\n Test script PASSED\n";
system("rm install_result.txt");
}
