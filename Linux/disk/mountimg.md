# mount
```
losetup --partscan --find --show disk.img
mount /dev/loop0p1 /mnt
```

# umount
```
umount /mnt
losetup -d /dev/loop0
```
