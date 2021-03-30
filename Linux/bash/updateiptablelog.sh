#!/bin/bash

logging()
{
	if [ -e "$1" ]
	then
		allline=`grep "$2" /var/log/kern.log`
		nowline=`tail -n 1 "$1"`
		cont=1
		while [ "`echo "$allline" | tac | sed -n ${cont}p`" != "$nowline" ]
		do
			(( cont++ ))
		done
		(( cont-- ))
		for a in $(seq $cont -1 1)
		do
			echo "$allline" | tac | sed -n ${a}p >> "$1"
		done
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
