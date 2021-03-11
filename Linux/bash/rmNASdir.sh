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

lssubans=`btrfs subvolume list /NAS | grep $folder`
if [ "$lssubans" = "" ] && [ "$isdelete" -eq 1 ]
then
	rm -r /NAS/$folder
elif [ "$lssubans" != "" ]
then
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
	sleep 1
	mount -a
	rm -r /home/$user/$folder

	while [ -e /NAS/.Temp ]
	do
		sleep 1
	done
	mkdir /NAS/.Temp

	snapper -c $folder delete-config
	if [ "$isdelete" -eq 0 ]
	then
		mv /NAS/$folder/* /NAS/$folder/.[^.]* /NAS/.Temp/
	fi

	qgroupid=`btrfs qgroup show -reF /NAS/$folder/ | awk '{print $1}' | grep 0/`
	btrfs subvolume delete /NAS/$folder/
	for a in $(btrfs qgroup show -pre /NAS | grep / | awk '{print $1}')
	do
		id=`echo $a | cut -c 3-`
		topid=`echo $a | cut -c 1-2`
		search=`btrfs subvolume list /NAS  | awk '{print $2}' | grep $id`
		if [ "$search" = "" ] && [ "$id" != "5" ] && [ "$topid" = "0/" ]
		then
			btrfs qgroup destroy $a /NAS/
		fi
	done
#	btrfs qgroup destroy $qgroupid /NAS/
	if [ "$isdelete" -eq 0 ]
	then
		mkdir /NAS/$folder
		mv /NAS/.Temp/* /NAS/.Temp/.[^.]* /NAS/$folder
		#chown -R $user:$group /NAS/$folder
	fi
	rm -r /NAS/.Temp
fi
