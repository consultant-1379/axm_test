$TMP= "/home/nmsadm";
$scalar=`/opt/ericsson/nms_cif_sm/bin/smtool -l |grep eam`;
my @val = split(' ', $scalar);
#TESTING
for($i=0;$i<scalar(@val);$i=$i+2)
{
$var1[$j]=$val[$i];
$j++;
}
my $MCs = join " ", @var1;
$cmd = `/opt/ericsson/nms_cif_sm/bin/smtool -warmrestart $MCs -reason="other" -reasontext=" "`;
print "\nPlease wait as Warmrestart is in progress ....\n";
system("$cmd");
sleep(5);
#Te::tex "$TC", "\n";
$progress = `/opt/ericsson/nms_cif_sm/bin/smtool list $MCs`;
chomp($progress);
#$progress = util::trim $progress;
open( TFH, ">$TMP/tmp.txt" ) or die $!;
#open( EFH, ">>$TMP/result.txt" ) or die $!;

print TFH "$progress\n";
close(TFH);

open( HH, "$TMP/tmp.txt" );
my @arr = <HH>;
close(HH);

unlink("$TMP/tmp.txt");

foreach $y (@arr) {
     #$y = util::trim $y;
     chomp($y);
    if ( $y =~ /started/ || $y =~ /^\s*$/ ) {
       
     print  "EAM MC $& is warm started successfully\n";
     # print EFH "PASS";
      system("echo PASS >>result.txt");
        unlink("$TMP/tmp.txt");
        
}
    else {
      
      print "EAM MC $& couldn't be warm started\n";
        system("echo FAIL >>result.txt");
      #  print EFH "FAIL";
        	 
    }
}
system("cat result.txt |grep FAIL");
if($? == 0)
{
print "FAILED";
}
else
{
print "PASSED";
}

