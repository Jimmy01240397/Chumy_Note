#!/bin/bash

data=""
bfsrc=""
bfpro=""
bfport=""
count=0
while : 
do
	sleep 0.01
	nowdata=`grep "THIS IS IPTABLE LOG "\!\!\! /var/log/kern.log | tail -n 1`
	src=`echo $nowdata | awk '{print $14}' | cut -c 5-`
	pro=`echo $nowdata | awk '{print $22}' | cut -c 7-`
	port=`echo $nowdata | awk '{print $24}' | cut -c 5-`
	if [ "$data" != "$nowdata" ]
	then
		if [ "$bfsrc" != "$src" ] || [ "$bfpro" != "$pro" ] || [ "$bfport" != "$port" ]
		then
			service=`grep -i "	$port/$pro" /etc/myserviceslist | awk '{print $1}'`
			#echo $service
			if [ "$service" = "" ]
			then
				service="$port/$pro port"
			else
				service="$service($port/$pro) service"
			fi
			echo "The $service has been ACCEPT from ip=$src" | su jimmygw -c "mail -s \"iptables notification\" <email>"
			count=1
			#echo send
		fi
		data=$nowdata
		bfsrc=$src
		bfpro=$pro
		bfport=$port
	fi
	if [ "$count" -eq 3000 ]
	then
		bfsrc=""
		bfpro=""
		bfport=""
		#echo $count
		count=0
	elif [ "$count" -ge 1 ]
	then
		count=$(($count + 1))
	fi
done
