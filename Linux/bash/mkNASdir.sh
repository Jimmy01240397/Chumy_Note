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

mkdir /NAS/$folder
chown $user:$group /NAS/$folder


echo "[$folder]" > /etc/samba/conf.d/$folder.conf
echo "	path = /NAS/$folder" >> /etc/samba/conf.d/$folder.conf
echo "	security = user" >> /etc/samba/conf.d/$folder.conf
echo "	browseable = yes" >> /etc/samba/conf.d/$folder.conf
echo "	read only = no" >> /etc/samba/conf.d/$folder.conf
echo "	guest ok = no" >> /etc/samba/conf.d/$folder.conf
echo "  force create mode = 755" >> /etc/samba/conf.d/$folder.conf
echo "  force security mode = 755" >> /etc/samba/conf.d/$folder.conf
echo "  force directory mode = 0755" >> /etc/samba/conf.d/$folder.conf
echo "  force directory security mode = 0755" >> /etc/samba/conf.d/$folder.conf
echo "	force user = $user" >> /etc/samba/conf.d/$folder.conf
echo "	valid users = $user" >> /etc/samba/conf.d/$folder.conf

mkdir /home/$user/$folder

echo "/NAS/$folder /home/$user/$folder none bind 0 0" > /etc/fstabconf/conf.d/$folder

/etc/samba/mergeconf.sh

sleep 1.5
mount -a

#echo end
