#! /bin/sh
/opt/ericsson/bin/eac_esi_config -nl > /home/nmsadm/taf/raja_testnode
tail +4 /home/nmsadm/taf/raja_testnode > /home/nmsadm/taf/tmp/runner_node_list
#Remove corresponding protocols from the list
awk '{print $1}' /home/nmsadm/taf/tmp/runner_node_list > /home/nmsadm/taf/tmp/node_list_tmp
mv /home/nmsadm/taf/tmp/node_list_tmp /home/nmsadm/taf/tmp/runner_node_list

echo '#!/usr/local/bin/expect -f 

#set timeout 5

#------------------------------------------------
# This script is used to test if the coonection
# has been established for a given node.

# How to use
# expect test_connection.tcl "Node Name"
# Return Value -
# 2 - Connection Established
# Any other value means Connection Err
#------------------------------------------------
#echo "hi"
spawn eaw  "$argv"
expect {
"<" {send exit;\r; exit 2}
"Connection failed" {exit 1}
timeout {exit 1}
}' > /home/nmsadm/taf/test_connection.tcl
chmod 777 /home/nmsadm/taf/test_connection.tcl
chown nmsadm /home/nmsadm/taf/test_connection.tcl
chgrp nms /home/nmsadm/taf/test_connection.tcl
while read line; do
  #echo $line
/usr/local/bin/expect /home/nmsadm/taf/test_connection.tcl $line > /dev/null 2>&1
if [ $? -eq 2 ] ; then
echo $line >> /home/nmsadm/taf/tmp/runner_connecting_nodes
echo "one node added $line"
else
echo $line >> /home/nmsadm/taf/tmp/runner_bad_nodes
echo "one node not added $line"
fi
done < /home/nmsadm/taf/tmp/runner_node_list
echo "Raja"
