# bind rndc setup

## Create rndc key 
```bash
rndc-confgen | sed -n '2,5p' > /etc/bind/rndc.key
chown bind:bind /etc/bind/rndc.key
```

## Setup rndc key in named.conf
``` bash
vi /etc/bind/named.conf.local
```
```
include "/etc/bind/rndc.key";

controls {
    inet 127.0.0.1 port 953
    allow { 127.0.0.1; } keys { "rndc-key"; };
};
```

## Setup ddns by rndc key
``` bash
vi /etc/bind/named.conf.local
```
```
zone "<domain>" {
    ...
    allow-update { key "rndc-key"; };
    ...
};
```
