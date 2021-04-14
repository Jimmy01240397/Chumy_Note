#!/bin/bash

logging()
{
	if [ -e "$1" ]
	then
		allline=`grep "$2" /var/log/kern.log`
		nowline=`tail -n 1 "$1"`
		cont=1
		nowcont=`wc -l < "$1"`
		maxcont=`grep "$2" /var/log/kern.log | wc -l`

		if [ "$(($maxcont - $nowcont))" -lt 0 ] 
		then
			grep "$2" /var/log/kern.log > "$1"
			#echo dead
		else
			for a in $(seq $(($maxcont - $nowcont)) -1 1)
			do
				echo "$allline" | tac | sed -n ${a}p >> "$1"
			done
		fi
	else
		grep "$2" /var/log/kern.log > "$1"
	fi
}

while :
do
	logging /var/log/iptables "THIS IS IPTABLE LOG "\!\!\!
	logging /var/log/getncutiplog "THIS IS IPTABLE GETIP"\!\!\!
	sleep 0.1
done	
