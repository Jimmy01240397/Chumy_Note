# Change lxc uid and gid map

## General
```bash
vi /etc/subuid
```
```
root:100000:65536
```
```bash
vi /etc/subgid
```
```
root:100000:65536
```

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
```perl
...
# At line 653
$raw .= "lxc.idmap = u 0 100000 65536\n";
$raw .= "lxc.idmap = g 0 100000 65536\n";
...
# At line 2334
$id_map = [ ['u', '0', '100000', '65536'],
            ['g', '0', '100000', '65536'] ];
$rootuid = $rootgid = 100000;
...
```
```bash
systemctl restart pvedaemon.service
```
