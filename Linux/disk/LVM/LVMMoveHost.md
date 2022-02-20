# old host
```
umount /dev/<vg>/<lv>

vgchange -an <vg>

vgexport <vg>
```

# new host
```
vgimport <vg>

vgchange -ay <vg>

mount /dev/<vg>/<lv> /mnt
```
