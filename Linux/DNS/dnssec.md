# bind9 dnssec setup

## Create ZSK and KSK
``` bash
mkdir <domain>
chown -R bind:bind <domain>
dnssec-keygen -a RSASHA256 -K /var/cache/bind/<domain> -b 2048 <domain>
dnssec-keygen -a RSASHA256 -f KSK -K /var/cache/bind/<domain> -b 2048 <domain> > /var/cache/bind/<domain>/kskname
dnssec-dsfromkey /var/cache/bind/<domain>/$(cat /var/cache/bind/<domain>/kskname).key > /var/cache/bind/<domain>/ds
```

## Setup zone on named.conf
``` bash
vi /etc/bind/named.conf.local
```
```
zone "<domain>" {
    ...
    key-directory "<domain>";
    auto-dnssec maintain;
    inline-signing yes;
    ...
}
```
