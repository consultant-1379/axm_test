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

/usr/bin/ls perl-5.8.8-sol10-x86-local.gz
if [ $? -eq 0 ] ;then
        /bin/echo "File found ....Hence proceed\n";
else
        /bin/echo "File not found\n";
	exit 1;
fi

/usr/bin/ls perl-5.8.8-sol10-x86-local
if [ $? -eq 0 ] ;then
	/usr/bin/rm perl-5.8.8-sol10-x86-local
fi

/usr/bin/gunzip perl-5.8.8-sol10-x86-local.gz

/usr/sbin/pkgadd -a $YES_FILE -d perl-5.8.8-sol10-x86-local < $ALL_FILE
