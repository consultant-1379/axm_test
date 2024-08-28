package com.ericsson.axm.test.apiGetter;

public class AxmCommandGetter {

    //Command to find Truss Process ID
    public static String getFindTrussProcessIdCommand() {
        return "ps -eaf | grep ehip_ac_in | grep -v grep | awk ' { print $2 } '";
    }

    //Command for Truss Log Collection
    public static String getTrussLogCollectionCommand() {
        return "truss -dleaf -xall -wall -rall -vall -all -ulibeai:: -dD -o /tmp/ehip_ac_in.txt -p ";
    }

    //Command for Finding the Truss Log Collection Process ID
    public static String getTrussLogCollectionProcessIdCommand() {
        return "ps -eaf | grep ehip_ac_in | grep root | grep -v grep | awk ' {print $2}'";
    }
}
