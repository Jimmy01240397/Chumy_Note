#!/bin/bash

argnum=$#
if [ $argnum -eq 0 ]
then
	echo "Missing arg..."
	exit 0
fi

user=""
template=""
location=""
ca=""
for a in $(seq 1 1 $argnum)
do
        nowarg=$1
        case "$nowarg" in
	        -h)
                        echo "addclient.sh -t <Template> -c <ca> -u <user> -l <location>"
                        exit 0
                        ;;
                -t)
                        shift
                        template=$1
                        ;;
                -c)
                        shift
                        ca=$1
                        ;;
                -u)
                        shift
                        user=$1
                        ;;
                -l)
                        shift
                        location=$1
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

if [ "$template" = "" ] || [ "$user" = "" ]
then
	echo "Missing arg..."
	exit 0
fi

if [ "$location" = "" ]
then
	location=`pwd`
fi

if [ "$ca" = "" ]
then
	ca=$template
fi


if [ `test -f  /etc/easy-rsa/$ca/pki/issued/$user.crt` ]
then
	echo Using exist certificate!
else
	cd /etc/easy-rsa/$ca
	./easyrsa build-client-full $user nopass
fi

output=$location/"$user"_"$template".ovpn

cp /etc/openvpn/client/$template.conf $output
echo "<ca>" >> $output
cat /etc/easy-rsa/$ca/pki/ca.crt >> $output
echo "</ca>" >> $output
echo "<cert>" >> $output
cat /etc/easy-rsa/$ca/pki/issued/$user.crt >> $output
echo "</cert>" >> $output
echo "<key>" >> $output
cat /etc/easy-rsa/$ca/pki/private/$user.key >> $output
echo "</key>" >> $output
