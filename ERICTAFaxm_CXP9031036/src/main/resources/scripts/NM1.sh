#!/bin/sh
# set -x
# Comment out any test chapter below by placing a "#" character in front of it!

NETWORK_PERL_PATH=/usr/local/bin/perl

cd /opt/ericsson/nms_netconf/etc/unsupported/bin/

echo "Hello NM scripts "

PERL_INC_X86a=usr/local/lib/perl5/site_perl/5.8.8/
PERL_INC_X86b=usr/local/lib/perl5/5.8.8/
PERL_INC_SPARCa=usr/local/lib/perl5/5.8.8/
LOCAL_INC=opt/ericsson/nms_netconf/etc/unsupported/bin/

PERM="chmod 777 tail.sh listnetconfnodes.sh"
${PERM}


$NETWORK_PERL_PATH -I/$LOCAL_INC -I/$PERL_INC_X86a -I/$PERL_INC_X86b -I/$PERL_INC_SPARCa ./node.pl

$NETWORK_PERL_PATH -I/$LOCAL_INC -I/$PERL_INC_X86a -I/$PERL_INC_X86b -I/$PERL_INC_SPARCa ./synch.pl

$NETWORK_PERL_PATH -I/$LOCAL_INC -I/$PERL_INC_X86a -I/$PERL_INC_X86b -I/$PERL_INC_SPARCa ./get.pl get.txt


$NETWORK_PERL_PATH -I/$LOCAL_INC -I/$PERL_INC_X86a -I/$PERL_INC_X86b -I/$PERL_INC_SPARCa ./editConfig.pl editConfig.txt &
$NETWORK_PERL_PATH -I/$LOCAL_INC -I/$PERL_INC_X86a -I/$PERL_INC_X86b -I/$PERL_INC_SPARCa ./Edit.pl

sleep 10;

$NETWORK_PERL_PATH -I/$LOCAL_INC -I/$PERL_INC_X86a -I/$PERL_INC_X86b -I/$PERL_INC_SPARCa ./noti.pl noti.txt &
sleep 5;
$NETWORK_PERL_PATH -I/$LOCAL_INC -I/$PERL_INC_X86a -I/$PERL_INC_X86b -I/$PERL_INC_SPARCa ./Edit.pl

