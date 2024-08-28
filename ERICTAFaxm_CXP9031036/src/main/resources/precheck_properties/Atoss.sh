#!/usr/sunos/bin/sh
USER=$1
PASSWD=$2
AXMTESTPATH=$3

$AXMTESTPATH/installation1.exp $USER $PASSWD $AXMTESTPATH

if [ $? -eq 0 ]
then
echo "Script Successful";
else
echo "Script not successful";
fi

