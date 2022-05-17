``` bash
apt install strongswan strongswan-pki libcharon-extra-plugins libcharon-extauth-plugins libstrongswan-extra-plugins
```

``` bash
vi /etc/ipsec.conf
```

``` bash
conn ikevpn
        auto=start
        keyexchange=ikev2

        leftsourceip=%config
        leftauth=eap-mschapv2

        right=vpn.chummy.finalexam.ncku
        rightsubnet=192.168.140.0/24
        rightid=%any
        rightauth=pubkey
        eap_identity=vpn

        ike=aes256-sha1-modp1024,aes128-sha1-modp1024,3des-sha1-modp1024!
        esp=aes256-sha256,aes256-sha1,3des-sha1!
```

``` bash
vi /etc/ipsec.secrets
```
``` bash
vpn : EAP "Skills39"
```

Routing base see ikev2server.md

## For DNS
```
apt-get install -y apparmor-utils
aa-complain /usr/lib/ipsec/charon
aa-complain /usr/lib/ipsec/stroke
```
