## ntp client 
``` bash
apt-get install ntp 

vim /etc/ntp.conf

add inline 

server 10.0.0.1
restrict 10.0.0.1
```
## verify 
``` bash
ntpq 
ntpq> peers 

timedatectl 

NTP synchronized:yes 

if "Failed to create bus connection: No such file or directory"

apt-get install dbus
```
