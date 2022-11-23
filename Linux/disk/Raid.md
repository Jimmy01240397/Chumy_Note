# Create
``` bash
fdisk /dev/sdb
	n (1)
	t (29 = Linux Raid)
	w
	q
fdisk /dev/sdc
	n (1)
	t (29 = Linux Raid)
	w
	q
fdisk /dev/sdd
	n (1)
	t (29 = Linux Raid)
	w
	q
fdisk /dev/sde
	n (1)
	t (29 = Linux Raid)
	w
	q
fdisk /dev/sdf
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
