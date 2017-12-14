#!/bin/bash
net_iface=$1

STATE_OK=0
STATE_WARNING=1
STATE_CRIT=2
STATE_UNKNOWN=3

RX_packets_dropped_warn=5
RX_packets_dropped_crit=10
TX_packets_dropped_warn=5
TX_packets_dropped_crit=10


#RX_packets_dropped=`ifconfig $net_iface | grep "RX packets" | awk '{print $4}' | awk -F':' '{print $2}'`
RX_packets_dropped=`cat /sys/class/net/$net_iface/statistics/rx_dropped`


#TX_packets_dropped=`ifconfig $net_iface | grep "TX packets" | awk '{print $4}' | awk -F':' '{print $2}'`
TX_packets_dropped=`cat /sys/class/net/$net_iface/statistics/tx_dropped`

now_time=`date -d now | awk -F' ' '{print $2, $3, $4}'`

#Get the file name of this bash scripts file
me=`basename "$0"`
#echo $me

#Get the full file path of this bash scripts file
#echo $(readlink -f "$me")

#Get the dir of this bash scripts file and then make the full file path of textfile
ck=$(echo $(dirname $(readlink -f "$me"))"/packets_drop_report.txt")
#echo $ck

#touch this file, so if the file is exist, touch command will do nothing else touch command will make create; 
#Neu file txt khong ton tai ma da co cau lenh get lastrow luon thi se bi loi
touch $ck

last_RX_packets_dropped=`tail -n1 $ck | awk -F' ' '{print $5}'`
#echo $last_RX_packets_dropped
last_TX_packets_dropped=`tail -n1 $ck | awk -F' ' '{print $7}'`

echo "$now_time RX_packets_dropped $RX_packets_dropped TX_packets_dropped $TX_packets_dropped" >> $ck

RX_num=`expr $RX_packets_dropped - $last_RX_packets_dropped`
TX_num=`expr $TX_packets_dropped - $last_TX_packets_dropped`

RX_num=7
TX_num=8


if [ 0 <= $RX_num && $RX_num <= $RX_packets_dropped_warn ] || [ 0 <= $TX_num && $TX_num <= $TX_packets_dropped_warn ]
then
	echo "Interface $net_iface: OK - Nums of RX packets dropped is $RX_num - Nums of TX packets dropped is $TX_num"
	exit $STATE_OK

elif [ $RX_packets_dropped_warn <= $RX_num && $RX_num <= $RX_packets_dropped_crit ] || [ $TX_packets_dropped_warn <= $TX_num && $TX_num <= $TX_packets_dropped_crit ]
then
	echo "Interface $net_iface: Warning - Nums of RX packets dropped is $RX_num - Nums of TX packets dropped is $TX_num"
	exit $STATE_WARNING
	
	elif [ $RX_num => $RX_packets_dropped_crit ] || [ $TX_num => $TX_packets_dropped_crit ]

	then
		echo "Interface $net_iface: Critical - Nums of RX packets dropped is $RX_num - Nums of TX packets dropped is $TX_num"
		exit $STATE_CRIT
	else
		echo "Interface $net_iface: Status Unknown :("
		exit $STATE_UNKNOWN
fi

