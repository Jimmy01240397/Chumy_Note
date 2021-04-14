#!/bin/bash

data=`tail -n 1 /var/log/iptables`
bfsrc=""
bfpro=""
bfport=""
count=0
while : 
do
	allline="`cat /var/log/iptables`"
	cont=1

	maxcont="`echo "$allline" | wc -l`"

	while [ "`echo "$allline" | tac | sed -n ${cont}p`" != "$data" ] && [ "$cont" -le $maxcont ]
	do
		(( cont++ ))
	done
	(( cont-- ))
	
#	echo $cont

	for a in $(seq $cont -1 1)
	do
		nowdata=`echo "$allline" | tac | sed -n ${a}p`
		src=`echo $nowdata | awk '{print $14}' | cut -c 5-`
		pro=`echo $nowdata | awk '{print $22}' | cut -c 7-`
		port=`echo $nowdata | awk '{print $24}' | cut -c 5-`
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
			echo "The $service has been ACCEPT from ip=$src"
			echo "The $service has been ACCEPT from ip=$src" | su jimmygw -c "mail -s \"iptables notification\" jimmy012403976@gmail.com"
			count=1
			#echo send
		fi
		data=$nowdata
		bfsrc=$src
		bfpro=$pro
		bfport=$port
		#echo $data
	done
	if [ "$count" -ge 300 ]
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
	sleep 0.1
done
