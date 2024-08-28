#!/bin/perl

open (FH, "/home/nmsadm/taf/runner_connecting_nodes");
open(OUTPUT, "> /home/nmsadm/taf/testing.txt");
my $data = join( "", <FH> );
my @nodes = split('\n', $data);
$ENV{PATH} = "/bin:/sbin:/usr/sbin:/usr/ccs/bin:/usr/dt/bin:/opt/VRTS/bin:/opt/SUNWconn/bin:/opt/SUNWste/bin:/opt/ericsson/bin:/opt/sybase/sybase/OCS-15_0/bin:/opt/sun/jdk/java/bin:/usr/ucb:/usr/proc/bin:/opt/ericsson/sck/bin:/opt/ericsson/nms_cif_ist/bin:/usr/openwin/bin:/usr/local/bin";
$a= $ENV{PATH};
#print "the  path is : $a";

for($i=0;$i<scalar(@nodes);$i++)
{
$data[$i]=`/opt/ericsson/bin/eac_esi_config -ne $nodes[$i] | /bin/egrep 'cr_daemon|name'`;
}

for($z=0;$z<scalar(@data);$z++)
{
if ($data[$z]=~/ehip_ac_in/)
{
$ehip[$g]=$data[$z];
$g++; 
}
elsif($data[$z]=~/ehiplx_ac_in/)
{
$ehiplx[$b]=$data[$z];
$b++;
}
elsif($data[$z]=~/ehms_ac_in/)
{
$ehms[$c]=$data[$z];
$c++;
}

}
my $scalar1 = join "", @ehip;
my $scalar2 = join "", @ehiplx;
my $scalar3 = join "", @ehms;

my @val = split(' ', $scalar1);
my @val1 = split(' ', $scalar2);
my @val2 = split(' ', $scalar3);

for($j=2;$j<scalar(@val);$j=$j+6)
{
$bsc[$m]=$val[$j];
$m++;
}
for($x=2;$x<scalar(@val1);$x=$x+6)
{
$bscl[$l]=$val1[$x];
$l++;
}
for($t=2;$t<scalar(@val2);$t=$t+6)
{
$mscbc[$k]=$val2[$t];
$k++;
}
#XNNNKKR-ADDED TO PRINT THE NO OF CONNECTING NODES BASED ON TYPE
$bscwindows=@bsc;
$bsclinux=@bscl;
$mscbcwindows=@mscbc;
#XRAJPAS:
my $bsc_nodes = join ":", @bsc;
print "The Connecting Bsc nodes are:$bscwindows:$bsc_nodes\n";
#print OUTPUT "Bsc:$bsc_nodes^";
print OUTPUT "Bsc:@bsc[0]^";
my $bsc_linux = join ":", @bscl;
print "The Connecting Bsc_linux nodes are:$bsclinux:$bsc_linux\n";
#print OUTPUT "Bsc_linux:$bsc_linux^";
print OUTPUT "Bsc_linux:@bscl[0]^";
my $msc_bc = join ":", @mscbc;
print "The Connecting MSCBC nodes are:$mscbcwindows:$msc_bc\n";
#print OUTPUT "MSCBC:$msc_bc";
print OUTPUT "MSCBC:@mscbc[0]";
print "End";
print " Hello";
print " Done\n";
