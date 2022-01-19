``` bash
mkdir /mnt/cdrom
mount /dev/cdrom /mnt/cdrom
tar zxpf /mnt/cdrom/VMwareTools-x.x.x-yyyy.tar.gz
umount /dev/cdrom 
cd vmware-tools-distrib
sudo ./vmware-install.pl
```
