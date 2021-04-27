#!/bin/bash


argnum=$#
if [ $argnum -eq 0 ]
then
	echo "Missing arg..."
	exit 0
fi

user=""
group=""
folder=""
for a in $(seq 1 1 $argnum)
do
	nowarg=$1
	case "$nowarg" in
		-h)
			echo "mkNASdir -u <user> -g <group> -f <foldername>"
			exit 0
			;;
		-u)
			shift
			user=$1
			;;
		-g)
			shift
			group=$1
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


if [ "$user" = "" ] || [ "$group" = "" ] || [ "$folder" = "" ]
then
	echo "Missing arg..."
	exit 0
fi


lssubans=`btrfs subvolume list /NAS | grep $folder`
if [ "$lssubans" != "" ] 
then
	echo "folder is Exist!!"
	exit 0
fi

while [ -e /NAS/.Temp2 ]
do
	sleep 1
done
mkdir /NAS/.Temp2
if [ -e /NAS/$folder ]
then
	mv /NAS/$folder/* /NAS/$folder/.[^.]* /NAS/.Temp2/
	rm -r /NAS/$folder
fi

btrfs subvolume create /NAS/$folder
mv /NAS/.Temp2/* /NAS/.Temp2/.[^.]* /NAS/$folder/
rm -r /NAS/.Temp2
chown $user:$group /NAS/$folder
snapper -c $folder create-config /NAS/$folder

echo "[$folder]" > /etc/samba/conf.d/$folder.conf
echo "	path = /NAS/$folder" >> /etc/samba/conf.d/$folder.conf
echo "	security = user" >> /etc/samba/conf.d/$folder.conf
echo "	browseable = yes" >> /etc/samba/conf.d/$folder.conf
echo "	read only = no" >> /etc/samba/conf.d/$folder.conf
echo "	guest ok = no" >> /etc/samba/conf.d/$folder.conf
echo "	create mask = 0755" >> /etc/samba/conf.d/$folder.conf
echo "	directory mask = 0755" >> /etc/samba/conf.d/$folder.conf
echo "	force user = $user" >> /etc/samba/conf.d/$folder.conf
echo "	valid users = $user" >> /etc/samba/conf.d/$folder.conf

mkdir /home/$user/$folder

uuid=`blkid /dev/md127  | awk '{print $2}' | cut -c 7-42`

echo "UUID=$uuid	/home/$user/$folder	btrfs	subvol=$folder	0	1" > /etc/fstabconf/conf.d/$folder

/etc/samba/mergeconf.sh

sleep 1
mount -a

#echo end
