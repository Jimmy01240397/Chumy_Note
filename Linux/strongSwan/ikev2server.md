``` bash
apt install strongswan strongswan-pki libcharon-extra-plugins libcharon-extauth-plugins libstrongswan-extra-plugins
```
``` bash
vi /etc/easy-rsa/pki/openssl-easyrsa.cnf
```
``` bash
oid_section             = new_oids

[ new_oids ]
ikeIntermediate=1.3.6.1.5.5.8.2.2
```

``` bash
vi /etc/easy-rsa/x509-types/server
```
``` bash
extendedKeyUsage = serverAuth,ikeIntermediate
```

``` bash
vi /etc/easy-rsa/x509-types/COMMON
```
``` bash
crlDistributionPoints = URI:http://www.nsc.com/nsc.crl #解註解
```

``` bash
./easyrsa build-server-full *.nsc.com nopass
```
``` bash
cp /etc/easy-rsa/pki/ca.crt /etc/ipsec.d/cacerts/
cp /etc/easy-rsa/pki/issued/\*.nsc.com.crt /etc/ipsec.d/certs/server.crt
cp /etc/easy-rsa/pki/private/\*.nsc.com.key /etc/ipsec.d/private/server.key
```
``` bash
vi /etc/ipsec.conf
```
``` bash
conn nscvpn
        auto=add
        keyexchange=ikev2

        leftid=@vpn.nsc.com
        leftcert=server.crt
        leftsubnet=172.16.10.0/24,10.0.0.0/24

        rightauth=eap-mschapv2
        rightsourceip=10.0.0.0/24
        rightdns=172.16.10.10

        eap_identity=%identity

        mark_in=42
        mark_out=42

        ike=aes256-sha1-modp1024,aes128-sha1-modp1024,3des-sha1-modp1024!
        esp=aes256-sha256,aes256-sha1,3des-sha1!
```

``` bash
vi /etc/strongswan.conf
```
``` bash
charon {
	.
	.
	.
        install_routes = no
        install_virtual_ip = no
	.
	.
	.
}
include strongswan.d/*.conf
```

``` bash
vi /etc/ipsec.secrets
```
``` bash
: RSA "server.key"
admin : EAP "Skills39"
```

``` bash
vi /etc/network/interfaces
```
``` bash
auto eth0
iface eth0 inet static
        address 172.16.10.20/24
        gateway 172.16.10.254
        up ip tunnel add vti0 mode vti local 172.16.10.20 key 42

auto vti0
iface vti0 inet static
        address 10.0.0.254/24
```

``` bash
ifdown eth0
ifup eth0

ifup vti0
```
