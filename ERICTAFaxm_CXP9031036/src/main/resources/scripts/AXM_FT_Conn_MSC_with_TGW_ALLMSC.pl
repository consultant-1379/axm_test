#!/usr/bin/perl
#
# SCRIPT NAME:AXM_FT_Conn_MSC_with_TGW_ALLMSC.pl
# Test Case & Priority: Create MSC node of version 14.1 and connect with TGW  (Pr.1)
# Test Case No : 7.2.14
# AUTHOR: JANMEJAY TRIPATHY
# DATE  : 21/11/2013
# REV: 1.0
#
# Description :To check the connection of the node via telnet master service.
# Return Value on Success : PASS
# Return Value on Failure : FAIL
#
# Usage :  /usr/local/bin/perl AXM_FT_Conn_MSC_with_TGW_ALLMSC.pl <node_name>.
#
# Dependency : Path of conn_msc_using_tgw.log(intermediate log needs to be taken care of which is mentioned in /home/nmsadm)
#
# REV HISTORY
# DATE:                           BY                                 MODIFICATION:
#02/09/2014                      XNNNKKR                            Modified the script into TAF Complaint.
##########################################################

use Expect;

$ntwrk_element=$ARGV[0];

open(RFH,">AXM_FT_Conn_MSC_with_TGW_ALLMSC.txt");


sub conn_msc_using_tgw
{
                print "Sending command for $ntwrk_element\n";
                my $expect = Expect->new;
                my $command = "telnet masterservice 52200";
                $expect->spawn($command) or die "Cannot spawn : $!\n";
                $expect->log_file("/home/nmsadm/conn_msc_using_tgw.log","w");
        	$expect->expect(5,'Userid:');
        	$expect->send("nmsadm\r");
        	$expect->expect(5,'Password:');
        	$expect->send("nms27511\r");
        	$expect->expect(5,'NE:');
        	$expect->send("NE=$ntwrk_element\r");
        	$expect->expect(5,'<');
        	$expect->soft_close();
        	
}


system("/opt/ericsson/bin/emt_tgw_useradm_cli -force -create -user nmsadm -pw nms27511");
system("/opt/ericsson/bin/emt_tgw_adjustmodel_cli");
check_output_model_adjust;
conn_msc_using_tgw;
check_output_file;


sub check_output_model_adjust
{
        if ( $? == 0 ) {
                print RFH "PASS : TGW model adjust completed successfully\n";
                
        }
        else {

                print RFH "FAIL : TGW model adjust failed\n";
                
               
        }
}



sub check_output_file
{
        system("/usr/bin/cat /home/nmsadm/conn_msc_using_tgw.log | /usr/bin/grep <");
       
        if ($? == 0)
        {
        	print RFH "FAIL : Connection to Node using TGW failed\n";
		
        }
        else
        {       
		print RFH "PASS : Connection to Node using TGW is successful\n";
        	
        }
}
close(RFH);

system("/bin/cat AXM_FT_Conn_MSC_with_TGW_ALLMSC.txt | /bin/grep FAIL");
if ($? == 0)
{
	print  "\nFAIL\n";
}
else
{
	print "\nPASS\n";
}
