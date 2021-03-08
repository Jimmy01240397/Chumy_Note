#!/bin/bash

if [ "$#" -eq 2 ]
then
	useradd -s /bin/bash -m $1
	echo "$1:$2" | chpasswd
	printf "$2\n$2\n" | smbpasswd -a -s $1
elif [ "$1" = "-h" ]
then
	echo "mkNASuser <username> <password>"
else
	echo "bad arg..."	
fi
