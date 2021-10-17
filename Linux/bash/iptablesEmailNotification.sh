#!/bin/bash

splitinspace()
{
	for a in $(cat $1)
	do
		echo $a
	done
}

lastlog=`cat /etc/iptables/lastiptableslog`
src=`echo $1 | splitinspace | grep SRC | cut -c 5-`
pro=`echo $1 | splitinspace | grep PROTO | cut -c 7-`
port=`echo $1 | splitinspace | grep DPT | cut -c 5-`
nowtime=`date +"%s"`
if [ "$lastlog" == "" ]
then
	bfsrc=0
	bfpro=0
	bfport=0
	bftime=0
else
	bfsrc=`echo $lastlog | splitinspace | grep SRC | cut -c 5-`
	bfpro=`echo $lastlog | splitinspace | grep PROTO | cut -c 7-`
	bfport=`echo $lastlog | splitinspace | grep DPT | cut -c 5-`
	bftime=`echo $lastlog | splitinspace | grep TIME | cut -c 6-`
fi
if [ "$bfsrc" != "$src" ] || [ "$bfpro" != "$pro" ] || [ "$bfport" != "$port" ] || [ $(( $nowtime - $bftime )) -ge 60 ]
then
	service=`grep -i "	$port/$pro" /etc/myserviceslist | awk '{print $1}'`
	#echo $service
	if [ "$service" = "" ]
	then
		service="$port/$pro port"
	else
		service="$service($port/$pro) service"
	fi
	echo "The $service has been ACCEPT from ip=$src"
	echo "The $service has been ACCEPT from ip=$src" | su jimmygw -c "mail -s \"iptables notification\" jimmy012403976@gmail.com"

	echo "TIME=$nowtime $1" > /etc/iptables/lastiptableslog
	#echo send
fi
