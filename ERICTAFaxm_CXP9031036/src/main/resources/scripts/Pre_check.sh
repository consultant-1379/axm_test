#! /bin/sh
prqust_chk ()
{
    hostname
    for i in 3pp sybase tbs borland openfusion
    do
        /bin/svcs -a | /bin/grep -i $i > prqust_report
        if [ $? -eq 0 ]; then
            /bin/svcs -a | /bin/grep -i $i | /bin/cut -d " " -f1 | /bin/grep -v online >> $EAM_DIR/prqust_report
            if [ $? -eq 0 ]; then
		
		echo -e "\e[00;31mERROR : $i service not online\e[0m" | /bin/tee $EAM_DIR/prqust_report
#               echo "ERROR : $i service not online" | tee $EAM_DIR/prqust_report
		exit_flag=1
            else
                echo "INFO  : $i is ONLINE"
            fi
        else
            echo "ERROR : $i service process not in the svcs list" | /bin/tee $EAM_DIR/prqust_report
            prqust_flag=1
        fi
    done

    #XRAJPAS : Check for all dependent services 
    #if [ $exit_flag -eq 1 ]; then
	#exit 2
    #fi

}
prqust() {
#PREREQUISTE CHECK
prqust_flag=0

prqust_chk
if [ $prqust_flag -eq 1 ]; then
     echo "Prerequisite was not Met!!"
     #echo "Check $EAM_DIR/prqust_report "
     #rm $EAM_DIR/lock > /dev/null 2>&1
     exit 1;
else
     echo "INFO  : All the required PREREQUISTE HAVE BEEN MET"
fi
#XRAJPAS : Here we need to create a node list based on the availability of the Nodes on the server

/opt/ericsson/bin/eac_esi_config -nl > $EAM_DIR/first_node_list
/bin/sed -e '1,3d' $EAM_DIR/first_node_list > tmpfile
#tail +4 $EAM_DIR/first_node_list > tmpfile
}

nodes_check() {

_file="$1"
[ $# -eq 0 ] && { echo "Usage: $0 filename"; exit 1; }
[ ! -f "$_file" ] && { echo "Error: $0 file not found."; exit 2; }
 
if [ -s "$_file" ]
then
	#echo "$_file has some data."
        echo " Network elements are captured from the map file "
        /opt/ericsson/bin/eac_esi_config -nl > $EAM_DIR/node_list 

else
echo -e "\e[00;31mOOPS....No NETWORK ELEMENTS ARE CONFIGURED ON THIS SERVER ...Please configure the network elements and run this suite again....\033[0m"
fi
}
cleanup
{
/bin/rm /home/nmsadm/taf/runner_connecting_nodes
/bin/rm /home/nmsadm/connect_disconnect.log
/bin/rm /home/nmsadm/taf/runner_bad_nodes
/bin/rm /home/nmsadm/taf/testing.txt

}
/bin/mkdir /home/nmsadm/taf/
/bin/chmod 777 /home/nmsadm/taf/
EAM_DIR="/home/nmsadm/taf/"
/bin/mkdir /home/nmsadm/taf/tmp
/bin/chmod 777 /home/nmsadm/taf/tmp
TMP="/home/nmsadm/taf/tmp"
cleanup
prqust
nodes_check tmpfile
echo "PASS"

