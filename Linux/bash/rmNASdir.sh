#!/bin/bash

argnum=$#
if [ $argnum -eq 0 ]
then
	echo "Missing arg..."
	exit 0
fi

isdelete=0
user=""
folder=""
for a in $(seq 1 1 $argnum)
do
	nowarg=$1
	case "$nowarg" in
		-h)
			echo "rmNASdir [-r] -u <user> -f <foldername>"
			exit 0
			;;
		-r)
			isdelete=1
			;;
		-u)
			shift
			user=$1
			;;
		-f)
			shift
			folder=$1
			;;
		*)
			if [ "$nowarg" = "" ]
			then
				break
			fi
			echo "bad arg..."
			exit 0
			;;
	esac	
	shift
done


if [ "$folder" = "" ] || [ "$user" = "" ]
then
	echo "Missing arg..."
	exit 0
fi

rm /etc/samba/conf.d/$folder.conf
rm /etc/fstabconf/conf.d/$folder
/etc/samba/mergeconf.sh
umount /home/$user/$folder
sleep 1
mount -a
rm -r /home/$user/$folder

if [ "$isdelete" -eq 1 ]
then
	rm -r /NAS/$folder
fi

