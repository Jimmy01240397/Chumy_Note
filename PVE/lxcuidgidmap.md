# Change lxc uid and gid map

## For single lxc
```bash
vi /etc/pve/lxc/<lxcid>.conf
```

```
...
lxc.idmap = u 0 100000 65536
lxc.idmap = g 0 100000 65536
...
```

## For all lxc
``` bash
vi /usr/share/perl5/PVE/LXC.pm
```
```
...
# At line 653
$raw .= "lxc.idmap = u 0 100000 65536\n";
$raw .= "lxc.idmap = g 0 100000 65536\n";
...
```
