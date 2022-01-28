``` bash
vi /etc/bind/named.conf.default-zones
```
``` bash
view "global" {
  match-clients { any; };
...
};
```

``` bash
vi /etc/bind/named.conf.local
```
``` bash
view "internal" {
  match-clients { 192.168.140.0/24; };
  zone "chummy.finalexam.ncku" {
    type master;
    file "/etc/bind/db.chummy.finalexam.ncku.lan";
  };
};
view "external" {
  match-clients { any; };
  zone "chummy.finalexam.ncku" {
    type master;
    file "/etc/bind/db.chummy.finalexam.ncku.wan";
  };
};
```
