#!/bin/sh
echo "before executing the eac_esi_config -nl "
/opt/ericsson/bin/eac_esi_config -nl > /home/nmsadm/taf/raja_testnode
echo $?
tail +4 /home/nmsadm/taf/raja_testnode > /home/nmsadm/taf/runner_node_list
#Remove corresponding protocols from the list
awk '{print $1}' /home/nmsadm/taf/runner_node_list > /home/nmsadm/taf/node_list_tmp
mv /home/nmsadm/taf/node_list_tmp /home/nmsadm/taf/runner_node_list
echo " before entring into loop and verifying the dependent files"
if [ -s /home/nmsadm/script/test_connection.tcl ]
then 
echo "File is available"

else
      echo "File is not available and creating the file"
fi
echo " before entring into loop"
while read line; do
#echo $line
echo " before calling .tcl"
/home/nmsadm/script/test_connection.tcl $line > /dev/null 2>&1
if [ $? -eq 2 ] ; then
echo " inside the if block"
echo $line >> /home/nmsadm/taf/runner_connecting_nodes
echo "one node added $line"
else
echo $line >> /home/nmsadm/taf/runner_bad_nodes
echo "one node not added $line"
fi
done < /home/nmsadm/taf/runner_node_list

echo " testing " 
