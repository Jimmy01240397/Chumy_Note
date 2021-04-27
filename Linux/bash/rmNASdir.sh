#!/bin/bash

argnum=$#
if [ $argnum -eq 0 ]
then
	echo "Missing arg..."
	exit 0
fi

isdelete=0
folder=""
for a in $(seq 1 1 $argnum)
do
	nowarg=$1
	case "$nowarg" in
		-h)
			echo "rmNASdir [-r] -f <foldername>"
			exit 0
			;;
		-r)
			isdelete=1
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


if [ "$folder" = "" ]
then
	echo "Missing arg..."
	exit 0
fi

user=`stat -c '%U' /NAS/$folder/`
group=`stat -c '%G' /NAS/$folder/`

umans=`lsof /home/$user/$folder`
if [ "$umans" != "" ]
then
	echo "is busy!"
	exit 0
fi
umount /home/$user/$folder
rm /etc/samba/conf.d/$folder.conf
rm /etc/fstabconf/conf.d/$folder
/etc/samba/mergeconf.sh
sleep 1.5
mount -a
rm -r /home/$user/$folder

if [ "$isdelete" -eq 1 ]
then
	rm -r /NAS/$folder
fi
