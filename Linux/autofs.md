# autofs

## Indirect MAP

`/etc/auto.master`
```
/NAS    /etc/auto.master.d/NAS  --timeout=10
```

`/etc/auto.master.d/NAS`
```
dirname     -fstype=cifs,vers=3.0,<option>  :<remote>
dirname     -fstype=cifs,vers=3.0,username=<username>,password=<password>,mfsymlinks,nobrl  ://192.168.100.110/home
dirname     -fstype=fuse.sshfs,follow_symlinks,uid=0,gid=0  :<username>@192.168.100.110\:home
```

## Direct MAP
``
`/etc/auto.master`
```
/-    /etc/auto.master.d/NAS  --timeout=10
```

`/etc/auto.master.d/NAS`
```
<path>     -fstype=cifs,vers=3.0,<option>  :<remote>
/NAS     -fstype=cifs,vers=3.0,username=<username>,password=<password>,mfsymlinks,nobrl  ://192.168.100.110/home
/NAS     -fstype=fuse.sshfs,follow_symlinks,uid=0,gid=0  :<username>@192.168.100.110\:home
```
