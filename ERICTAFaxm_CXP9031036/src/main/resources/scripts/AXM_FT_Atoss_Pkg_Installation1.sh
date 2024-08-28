#!/bin/sh

YES_FILE="yes_file.txt"
ALL_FILE="all_file.txt"
echo "mail=
instance=overwrite
partial=nocheck
runlevel=nocheck
idepend=nocheck
rdepend=nocheck
space=nocheck
setuid=nocheck
conflict=nocheck
action=nocheck
basedir=default" > $YES_FILE

echo "all" > $ALL_FILE

/usr/bin/pkginfo -l ERICatoss
if [ $? -eq 0 ] ;then
        /bin/echo "Atoss pkg is already installed\n";
	exit 1;
else
        /bin/echo "installing Atoss pkg\n";
	
	/opt/ericsson/sck/bin/ist_run -d ERICatoss-R1A58.pkg -force -auto -pa
	
	/usr/sbin/pkgadd -a $YES_FILE -d ERICatoss-R1A58.pkg < $ALL_FILE

#	/usr/bin/su - nmsadm

	/usr/bin/gunzip /opt/ericsson/atoss/tas/lib/X86/PERL/perl-5.8.8-sol10-x86-local.gz 

#	system("exit");

	/usr/sbin/pkgadd -a $YES_FILE -d /opt/ericsson/atoss/tas/lib/X86/PERL/perl-5.8.8-sol10-x86-local < $ALL_FILE

	/opt/ericsson/atoss/tas/PF_SERVCIF/CL/bin/prehandler.pl >& output_of_PF_SERVCIF_CL_prehandler.txt
fi
