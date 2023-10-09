# LDAPs setup

## letsencrypt
1. Create hook `/etc/letsencrypt/hooks/ldap.sh`
```
#!/bin/bash

setfacl -m u:openldap:rx /etc/letsencrypt/live
setfacl -m u:openldap:rx /etc/letsencrypt/archive
setfacl -R -m u:openldap:r /etc/letsencrypt/archive/<cert CN>/
setfacl -m u:openldap:rx /etc/letsencrypt/archive/<cert CN>/
```
2. Set hook `/etc/letsencrypt/renewal/<cert CN>.conf`
```
...
server = https://acme-v02.api.letsencrypt.org/directory
post_hook = /etc/letsencrypt/hooks/ldap.sh
key_type = ecdsa
...
```

## openldap set cert
1. Create ldif for enable ssl
```
dn: cn=config
changetype: modify
replace: olcTLSCACertificateFile
olcTLSCACertificateFile: /etc/letsencrypt/live/<cert CN>/chain.pem
-
replace: olcTLSCertificateFile
olcTLSCertificateFile: /etc/letsencrypt/live/<cert CN>/fullchain.pem
-
replace: olcTLSCertificateKeyFile
olcTLSCertificateKeyFile: /etc/letsencrypt/live/<cert CN>/privkey.pem
```

2. Enable ssl
```
slapmodify -b cn=config -l <ssl ldif path>
systemctl restart slapd.service
```

3. Add protocal
```
vi /etc/default/slapd
```
```
...
SLAPD_SERVICES="ldap:/// ldapi:/// ldaps:///"
...
```

## ldapsearch for client
***Client must have `/etc/ldap/ldap.conf` or ldapsearch for TLS will broken***
```
#
# LDAP Defaults
#

# See ldap.conf(5) for details
# This file should be world readable but not world writable.

#BASE   dc=example,dc=com
#URI    ldap://ldap.example.com ldap://ldap-provider.example.com:666

#SIZELIMIT  12
#TIMELIMIT  15
#DEREF      never

# TLS certificates (needed for GnuTLS)
TLS_CACERT  /etc/ssl/certs/ca-certificates.crt
```
