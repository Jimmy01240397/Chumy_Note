#!/bin/bash


argnum=$#
if [ $argnum -eq 0 ]
then
	echo "Missing arg..."
	exit 0
fi

user=""
serverconf=""
fqdn=""
for a in $(seq 1 1 $argnum)
do
        nowarg=$1
        case "$nowarg" in
	        -h)
                        echo "addwguser.sh -s <ServerConfPath> -u <username> -f <fqdn>"
                        exit 0
                        ;;
                -s)
                        shift
                        serverconf=$1
                        ;;
                -u)
                        shift
                        user=$1
                        ;;
                -f)
                        shift
                        fqdn=$1
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

if [ "$serverconf" = "" ] || [ "$user" = "" ] || [ "$fqdn" = "" ]
then
	echo "Missing arg..."
fi

function atoi
{
	#Returns the integer representation of an IP arg, passed in ascii dotted-decimal notation (x.x.x.x)
	IP=$1; IPNUM=0
	for (( i=0 ; i<4 ; ++i )); do
		((IPNUM+=${IP%%.*}*$((256**$((3-${i}))))))
		IP=${IP#*.}
	done
	echo $IPNUM 
} 

function itoa
{
	#returns the dotted-decimal ascii form of an IP arg passed in integer format
	echo -n $(($(($(($((${1}/256))/256))/256))%256)).
	echo -n $(($(($((${1}/256))/256))%256)).
	echo -n $(($((${1}/256))%256)).
	echo $((${1}%256)) 
}

nowip=`atoi $(grep AllowedIPs $serverconf | grep -oP '(?<=AllowedIPs\s=\s)\d+(\.\d+){3}' | tail -n 1)`
nowmask=`grep Address $serverconf | grep -oP '(?<=Address\s=\s)\d+(\.\d+){3}\K/\d+' | tail -n 1`
nowpsk=`wg genpsk`
nowprk=`wg genkey`
nowpuk=`echo $nowprk | wg pubkey`
serverport=`grep ListenPort $serverconf | grep -oP '(?<=ListenPort\s=\s)\d+' | tail -n 1`
serverpuk=`grep PrivateKey $serverconf | grep -oP '(?<=PrivateKey\s=\s).*' | tail -n 1 | wg pubkey`

((nowip++))

echo "" >> $serverconf
echo [Peer] >> $serverconf
echo "# $user" >> $serverconf
echo "AllowedIPs = $(itoa $nowip)/32" >> $serverconf
echo "PreSharedKey = $nowpsk" >> $serverconf
echo "PublicKey = $nowpuk" >> $serverconf



echo [Interface] > /etc/wireguard/client/$user.conf
echo "Address = $(itoa $nowip)$nowmask" >> /etc/wireguard/client/$user.conf
echo "PrivateKey = $nowprk" >> /etc/wireguard/client/$user.conf
echo "" >> /etc/wireguard/client/$user.conf
echo [Peer] >> /etc/wireguard/client/$user.conf
echo "AllowedIPs = 192.168.100.254/32" >> /etc/wireguard/client/$user.conf
echo "Endpoint = $fqdn:$serverport" >> /etc/wireguard/client/$user.conf
echo "PreSharedKey = $nowpsk" >> /etc/wireguard/client/$user.conf
echo "PublicKey = $serverpuk" >> /etc/wireguard/client/$user.conf


sed '/Address/d' $serverconf > /tmp/wgconf.conf
wg syncconf $(echo $serverconf | grep -oP '[^/]*(?=\.conf)') /tmp/wgconf.conf
rm /tmp/wgconf.conf

qrencode -t ansiutf8 < /etc/wireguard/client/$user.conf
