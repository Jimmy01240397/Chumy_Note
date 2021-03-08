#!/bin/bash

if [ "$#" -eq 1 ]
then
	if [ "$1" = "-h" ]
	then
		echo "rmNASuser <username>"
	else
		smbpasswd -x $1
		userdel -r $1
	fi
else
	echo "bad arg..."
fi
