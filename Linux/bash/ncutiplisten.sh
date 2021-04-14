#!/bin/bash

nowline=`tail -n 1 /var/log/getncutiplog`
while :
do
	allline=`cat /var/log/getncutiplog`
	#allcont=`wc -l < /var/log/getncutiplog`
	
	maxcont="`echo "$allline" | wc -l`"
	cont=1
	
	while [ "`echo "$allline" | tac | sed -n ${cont}p`" != "$nowline" ] && [ "$cont" -le $maxcont ]
	do
		(( cont++ ))
	done
	(( cont-- ))

#	echo $cont

		
	for a in $(seq $cont -1 1)
	do
		nowline=`echo "$allline" | tac | sed -n ${a}p`
		myip=`echo "$nowline" | awk '{print $13}' | cut -c 5-`
		echo "update ncut ip:$myip"
		curl -X PUT 
	done
	sleep 0.1
done	
