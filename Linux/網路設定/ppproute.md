``` bash
vi /etc/ppp/if-up.d/route
```

``` bash
ip rule add from $4 lookup 100
ip route add default table 100 dev ppp0
```
