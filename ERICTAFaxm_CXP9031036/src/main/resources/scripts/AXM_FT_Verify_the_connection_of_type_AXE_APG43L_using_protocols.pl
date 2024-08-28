#!/usr/bin/perl
#!/usr/bin/bash
#
# SCRIPT NAME:AXM_FT_Verify_the_connection_of_type_AXE_APG43L_using_protocols.pl
# Test Case & Priority: AXM_FT_Verify_the_connection_of_type_AXE_APG43L_using_protocols (Pr.1)
# Test Case No : 7.2.14/7.2.15/7.2.16/7.2.17
# AUTHOR: XROHAGR/XJANTRI
# DATE  : 06/12/2013
# REV:1.0

#
# Description :Verifying the connection of BSCwindows node of TELNET/SSH with APG43 protocol.
# Return Value on Success : PASS
# Return Value on Failure : FAIL
#
# Usage :  /usr/local/bin/perl AXM_FT_Verify_the_connection_of_type_AXE_APG43L_using_protocols.pl <node name>.
#
# Dependency : The below mentioned file is required to run this #usecase
#$EAM_DIR/lib/test_connection.tcl
#
# REV HISTORY
# DATE:                           BY                                 MODIFICATION:
#11/08/2014                      XNNNKKR                            Modified the script into TAF complaint.
##########################################################

use Expect;

$ntwrk_element = $ARGV[0];

open(RFH,">AXM_FT_Verify_the_connection_of_type_AXE_APG43L_using_protocols.txt");

$cr_protocol =`/opt/ericsson/bin/eac_esi_config -ne $ntwrk_element | grep cr_protocol | awk '{print \$3}'`;

$cr_daemon =`/opt/ericsson/bin/eac_esi_config -ne $ntwrk_element | grep cr_daemon | awk '{print \$3}'`;
    
print "The protocol is:$cr_protocol\n";
     
print "The daemon is : $cr_daemon\n";

print "THe netowrk element is :$ntwrk_element\n";
 



#Checking the node type AXE (APG43L) and TELNET|TELNET_MTS protocol

if (($cr_daemon =~ /ehip_ac_in/) && ($cr_protocol =~ /TELNET_APG43/))    
{
	print RFH "PASS : Node $ntwrk_element is of type AXE (APG43L) using TELNET|TELNET_MTS protocol\n";
      	system("/usr/local/bin/expect /home/nmsadm/eam/lib/test_connection.tcl $ntwrk_element");
        if ( $? >> 8 == 2 ) 
	{
		print RFH "PASS : $ntwrk_element Connection is Established\n";
                      
        }
                
	else 
	{
		print RFH "FAIL : $ntwrk_element Connection is not Established\n";
                 
        }

}
# Checking the node type AXE (APG43L) and SSH protocol
elsif (($cr_daemon =~ /ehip_ac_in/) && ($cr_protocol =~ /SSH_APG43/))   
{
	print "THe network element for ssh is :$ntwrk_element\n";
	print RFH "PASS : Node $ntwrk_element is of type AXE (APG43L) using SSH|SSH_MSS protocol\n";
       

	#Checking the node connection through EAM
       	system("/usr/local/bin/expect /home/nmsadm/eam/lib/test_connection.tcl $ntwrk_element");
        if ( $? >> 8 == 2 ) 
	{
		print RFH "PASS : $ntwrk_element Connection is Established\n";
                   
       	}
        else 
	{
		print RFH "FAIL : $ntwrk_element Connection is not Established\n";
                      
        }
}

else 
{
	
	print RFH "FAIL : Node $ntwrk_element is not of type AXE (APG43L) using TELNET|TELNET_MTS|SSH|SSH_MSS protocol in EAC config file\n";
 
}

close(RFH);

system("/bin/cat AXM_FT_Verify_the_connection_of_type_AXE_APG43L_using_protocols.txt | /bin/grep FAIL ");

if ($?==0)
{
	print  "\nFAIL\n";
}
else
{
	print "\nPASS\n";
}
