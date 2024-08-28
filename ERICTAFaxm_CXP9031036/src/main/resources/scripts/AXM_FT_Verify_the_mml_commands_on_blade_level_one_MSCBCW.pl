#!/usr/bin/perl
#
# SCRIPT NAME:AXM_FT_Verify_the_mml_commands_on_blade_level_one_MSCBCW.pl
# Test Case & Priority:AXM_FT_Verify_the_mml_commands_on_blade_level_one_MSCBCW(Pr.1)
# Test Case No :8.1.1(common)
# AUTHOR:XJITKUM
# DATE  :
# REV:
#
# Description :
# Prerequisites  :
# Return Value on Success : 0
# Return Value on Failure : 1
# Result File : /home/nmsadm/eam/results
#
# Usage :  bash RUNME -t AXM_FT_Verify_the_mml_commands_on_blade_level_one_MSCBCW.pl.
#
# Dependency : Te.pm, crdmp.sh, PMSEerrorchk.sh
#
# REV HISTORY
# DATE:                           BY                                 MODIFICATION:
#
##########################################################

# DEFINE FILES AND VARIABLES HERE

use Expect;


$ntwrk_element=$ARGV[0];#ENV{ntwrk_element};

#======================================================================
open(RFH,">AXM_FT_Verify_the_mml_commands_on_blade_level_one_MSCBCW.txt");
sub node_conn
{
print "Establishing connection for $ntwrk_element\n";
        my $expect = Expect->new;
        my $command = "/opt/ericsson/bin/eaw $ntwrk_element";
        $expect->spawn($command) or die "Cannot spawn : $!\n";
        $expect->log_file("Blade_cluster_node_AD.log","w+");
        $expect->expect(50,'<');
        $expect->send("aploc;\r");
        $expect->expect(10,'>');
        $expect->send("cpgls\r");
        $expect->expect(10,'>');
        $expect->send("quit;\r");
        $expect->soft_close();

}

node_conn;
system("/bin/cat Blade_cluster_node_AD.log | /bin/grep ALLBC");

if ( $? == 0 )
{
	print RFH "PASS : Blade Switch is successful\n";
  #  Te::tex "$TC", "\nINFO  :Blade Switch is successful";
}
else
{
	print RFH "FAIL : Blade Switch is not successful\n";
   # Te::tex "$TC", "\nERROR  : Blade Switch is not successful";

}

 sub node_conn_cp
{
my $match = `/bin/cat Blade_cluster_node_AD.log | /bin/grep "ALLBC:" |/bin/cut -d ':' -f2`;
my @string= split /[,]/,$match;
print $string[0];
print $string[1];
print "Establishing connection for $ntwrk_element\n";
        my $expect = Expect->new;
        my $command = "/opt/ericsson/bin/eaw $ntwrk_element,CPNAME='$string[0]',EH=16";
        $expect->spawn($command) or die "Cannot spawn : $!\n";
        $expect->log_file("Blade_cluster_node_cp_eh.log","w+");
        $expect->expect(50,'<');
        $expect->send("CACLP;\r");
        $expect->expect(10,'<');
        $expect->send("LASIP:BLOCK=all;\r");
        $expect->expect(10,'<');
        $expect->send("ALLIP;\r");
        $expect->expect(10,'<');
        $expect->send("SYBFP:FILE;\r");
        $expect->expect(10,'<');
        $expect->send("LABUP;\r");
        $expect->expect(10,'<');
        $expect->send("ALHBI;\r");
        $expect->expect(10,'<');
        $expect->send("quit;\r");
        $expect->soft_close();
}
node_conn_cp;
system("/bin/cat Blade_cluster_node_cp_eh.log | /bin/grep ACT");

if ( $? == 0 )
{
	print RFH "PASS : Blade level node with CP connection is successful\n";
  #  Te::tex "$TC", "\nINFO  :Blade level node with CP connection is successful";
}
else
{
	print RFH "FAIL : Blade level node with CP connection is not successful\n";
  #  Te::tex "$TC", "\nERROR  :Blade level node with CP connection is not successful";

}

my @result = qx {/opt/sybase/sybase/OCS-15_0/bin/isql -Usa -Psybase11 <<EOF
use tapdb
go
select command_str from eacr_command_log
go
exit
EOF
};

my $arrSize = @result;
#my $data=$result['$arrSize'- 3];
my $sql_res_allip=$result['$arrSize'- 6];
my $string_alp = 'ALLIP;';
my $sql_res_sybf=$result['$arrSize'- 5];
my $string_sybf= 'SYBFP:FILE;';
my $sql_res_labup=$result['$arrSize'- 4];
my $string_labup= 'LABUP;';
my $sql_res_alhbi=$result['$arrSize'- 3];
my $string_alhbi= 'ALHBI;';

if ($sql_res_allip==$string_alp)
{
		print RFH "PASS : Command ALLIP executed successful verified with database\n";
       # Te::tex "$TC", "\nINFO  :Command ALLIP executed successful verified with database";
}#
else
{
		print RFH "FAIL : :Command ALLIP not executed successful\n";

       # Te::tex "$TC", "\nERROR  :Command ALLIP not executed successful";
}

if ($sql_res_sybf==$string_sybf)
{
		print RFH "PASS : :Command SYBFP:FILE executed successful verified with database\n";

       # Te::tex "$TC", "\nINFO  :Command SYBFP:FILE executed successful verified with database";
}
else
{
		print RFH "FAIL : Command SYBFP:FILE not executed successful\n";
       # Te::tex "$TC", "\nERROR  :Command SYBFP:FILE not executed successful";
}


if ($sql_res_labup==$string_labup)
{
		print RFH "PASS : Command LABUP executed successful verified with database\n";
      #  Te::tex "$TC", "\nINFO  :Command LABUP executed successful verified with database";
}
else
{
		print RFH "FAIL : Command LABUP not executed successful\n";
      #  Te::tex "$TC", "\nERROR  :Command LABUP not executed successful";
}

if ($sql_res_alhbi==$string_alhbi)
{
		print RFH "PASS : Command ALHBI executed successful verified with database\n";
     #   Te::tex "$TC", "\nINFO  :Command ALHBI executed successful verified with database";
}
else
{
		print RFH "FAIL : Command ALHBI not executed successful\n";
       # Te::tex "$TC", "\nERROR  :Command ALHBI not executed successful";
}


#=======================================================================
#FRAME::end_frame "$TC";

close(RFH);
system("/bin/cat AXM_FT_Verify_the_mml_commands_on_blade_level_one_MSCBCW.txt | /bin/grep FAIL ");
if ($? == 0)
{
print  "\nFAIL\n";
}
else
{
print "\nPASS\n";
}

