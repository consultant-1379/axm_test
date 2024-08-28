#!/bin/bash
# SCRIPT NAME:AXM_FT_EAM_EHIP_Specific_Separate_EHIP_BSCW.sh
# Test name : AXM_FT_EAM_EHIP_Specific_Separate_EHIP_T, AXM_FT_EAM_EHIP_Specific_Separate_EHIP_S
# Test Case No : 5.3.6, 5.4.7
# AUTHOR: SANJEEV KUMAR SHARMA
# DATE  :
# REV:
############################### Description ####################
# Connect to the NE and check that the A/B sides are seperated #
# and working using the command OCINP:IPN=ALL;                 #
################################################################
# Prerequisites  :
# Return Value on Success : 0
# Return Value on Failure : 1
# Result File : /home/nmsadm/eam/logs
#
# Usage :  bash RUNME -t AXM_FT_EAM_EHIP_Specific_Separate_EHIP_BSCW.sh:<node name>
#
# Dependency :
#
# REV HISTORY
# DATE:
# BY
# MODIFICATION:
#
##########################################################

source /home/nmsadm/eam/lib/library_function.sh
ntwrk_element=$1

check_output() {
/bin/echo "PASS  : Checking the output of OCINP command" | /bin/tee -a AXM_FT_EAM_EHIP_Specific_Separate_EHIP_BSCW.txt
ipn_data=$(/bin/grep -nw 'IPN DATA' /home/nmsadm/eam/tmp/output|/bin/cut -d ":" -f1)

ipn=$(/bin/grep -nw 'IPN       STATE     RPHM      LRPBI     PRPBI     PCB' /home/nmsadm/eam/tmp/output|/bin/cut -d ":" -f1)

end=$(/bin/grep -nw 'END' /home/nmsadm/eam/tmp/output|/bin/cut -d ":" -f1)

if [ $ipn_data -lt $ipn -a $ipn -lt $end ] ; then
    /bin/echo "PASS  : Output is just like Expected"| /bin/tee -a AXM_FT_EAM_EHIP_Specific_Separate_EHIP_BSCW.txt
    return 0
else
    /bin/echo "FAIL : Mismatch, Actual output differs from Expected"| /bin/tee -a AXM_FT_EAM_EHIP_Specific_Separate_EHIP_BSCW.txt
    /bin/echo "PASS  : Actual output is"| /bin/tee -a AXM_FT_EAM_EHIP_Specific_Separate_EHIP_BSCW.txt
    /bin/cat /home/nmsadm/eam/tmp/output | /bin/tee -a AXM_FT_EAM_EHIP_Specific_Separate_EHIP_BSCW.txt
    return 1
fi
}
#=============================================================================================

protocol=$(/opt/ericsson/bin/eac_esi_config -ne $ntwrk_element | /bin/grep cr_protocol | /bin/cut -d "=" -f2 |/bin/sed -e 's/^[ \t]*//')

if [[ $protocol == SSH_* ]]; then
  /bin/echo "Protocol is SSH"
  source /home/nmsadm/eam/lib/ehip_s
  /bin/echo "PASS  : Test Case is running against $ntwrk_element with SSH Protocol $protocol" | /bin/tee -a AXM_FT_EAM_EHIP_Specific_Separate_EHIP_BSCW.txt
else
  /bin/echo "Protocol is TELNET"
  source /home/nmsadm/eam/lib/ehip_t
  /bin/echo "PASS  : Test Case is running against $ntwrk_element with TELNET Protocol $protocol"| /bin/tee -a AXM_FT_EAM_EHIP_Specific_Separate_EHIP_BSCW.txt
fi

$EXPECT /home/nmsadm/eam/lib/run_eaw_cmd.tcl $ntwrk_element OCINP:IPN=ALL >  /home/nmsadm/eam/tmp/output 2>&1
if [ $? -eq 0 ] ; then
     check_output
fi
/bin/pkill -9 "emt_tgw_eaw"
#=============================================================================================

/bin/cat AXM_FT_EAM_EHIP_Specific_Separate_EHIP_BSCW.txt | /bin/grep FAIL
if [ $? -eq 0 ] ;then
        /bin/echo "FAIL";
else
        /bin/echo "PASS";
fi
