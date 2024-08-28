#!/usr/bin/perl
#
# SCRIPT NAME:AXM_FT_eac_esi_map_file_NO_NODE.pl
# Test Case & Priority: AXM_FT_eac_esi_map_file_NO_NODE (Pr.1)
# Test Case No :9.1.4(common)
# AUTHOR:
# DATE  :
# REV:
#
# Description :
# Prerequisites  :
# Return Value on Success : 0
# Return Value on Failure : 1
# Result File : /home/nmsadm/eam/results
#
# Usage :  bash RUNME -t AXM_FT_eac_esi_map_file_NO_NODE.pl:NO_NODE.
#
# Dependency : Te.pm, crdmp.sh, PMSEerrorchk.sh
#
# REV HISTORY
# DATE:                           BY
  # MODIFICATION:
##########################################################

# DEFINE FILES AND VARIABLES HERE

$ntwrk_element=$ARGV[0];#ENV{ntwrk_element};

#================================================================
#======
open(RFH,">AXM_FT_eac_esi_map_file_NO_NODE.txt");


system("/opt/ericsson/nms_cif_sm/bin/smtool -l |/bin/grep eam_handlerEMA > eac_esi_map.log");
system("/bin/ps -eaf|/bin/grep ehema_ac_in >> eac_esi_map.log ");
system("/bin/grep eam_handlerEMA eac_esi_map.log && /bin/grep started eac_esi_map.log && /bin/grep /opt/ericsson/nms_eam_ehema/bin/ehema_ac_in eac_esi_map.log");
if ( $? == 0 ) {
    #system("/bin/rm eac_esi_map.log");
        print RFH "PASS : PG process and initiator exists";
   # Te::tex "$TC", "\nINFO  :PG process and initiator exists";
}
else {
        print RFH "FAIL : PG process doesn't exist";
 #   Te::tex "$TC", "\nERROR  : PG process doesn't exist";

}

close(RFH);
system("/bin/cat AXM_FT_eac_esi_map_file_NO_NODE.txt | /bin/grep FAIL ");
if ($? == 0)
{
print  "\nFAIL\n";
}
else
{
print "\nPASS\n";
#unlink("AXM_FT_eac_esi_map_file_NO_NODE.txt");
}

#================================================================
#=======
#FRAME::end_frame "$TC";
