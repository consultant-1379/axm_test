#!/usr/local/bin/expect -f 

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
spawn /opt/ericsson/bin/eaw "$argv"
expect {
"<" {send exit\;\r; exit 2}
"Connection failed" {exit 1}
timeout {exit 15}
}
