# Create
``` bash
fdisk /dev/sdb1
	n (1)
	t (29 = Linux Raid)
	w
	q
fdisk /dev/sdc1
	n (1)
	t (29 = Linux Raid)
	w
	q
fdisk /dev/sdd1
	n (1)
	t (29 = Linux Raid)
	w
	q
fdisk /dev/sde1
	n (1)
	t (29 = Linux Raid)
	w
	q
fdisk /dev/sdf1
	n (1)
	t (29 = Linux Raid)
	w
	q
mdadm -E /dev/sd[b-f]1
mdadm --create /dev/md0 --level=6 --raid-devices=5 /dev/sd[b-f]1
```

# Add disk
``` bash
mdadm --add /dev/md0 /dev/sdf1
```

# Add size
``` bash
mdadm --grow --size=max /dev/md0
resize2fs /dev/md0
```

# Remove size
``` bash
resize2fs /dev/md0 <to size>
mdadm --grow --size=<to size> /dev/md0

```

# Remove
``` bash
mdadm --stop /dev/md0
mdadm --zero-superblock /dev/sd[b-f]1
```
