``` bash
vi /etc/ipsec.secrets
```

``` bash
toxinyu1 toxinyu2 : PSK "D/rQ52I2hKiIWMUMG/RQgQv2ygitDa3FXyVCGSzOL1I="
```

``` bash
vi /etc/ipsec.conf
```

``` bash
conn toxinyu1
        auto=start
        keyexchange=ikev2
        authby=secret

        type=transport
        leftid=@toxinyu1
        leftauth=psk
        leftprotoport=17/4789

        right=140.116.245.242
        rightid=@tochummy2
        rightauth=psk
        rightprotoport=17/%any
```
