# Setup ldap auth for samba

## Install smbldap-tools
```bash
apt install samba smbldap-tools libarchive-zip-perl
```

## Setup samba schema
```bash
cp /usr/share/doc/samba/examples/LDAP/samba.ldif /etc/ldap/schema
sudo -u openldap slapadd -b cn=config -l /etc/ldap/schema/samba.ldif
systemctl restart slapd.service
```

## Set olcDbIndex in cn=config
```bash
vi /etc/ldap/slapd.d/cn\=config/olcDatabase\=\{1\}mdb.ldif
```
```ldif
...
olcDbIndex: objectClass eq
olcDbIndex: cn,uid eq,sub
olcDbIndex: uidNumber,gidNumber eq
olcDbIndex: loginShell eq
olcDbIndex: memberUid eq,sub
olcDbIndex: member,uniqueMember eq
olcDbIndex: sambaSID eq
olcDbIndex: sambaPrimaryGroupSID eq
olcDbIndex: sambaGroupType eq
olcDbIndex: sambaSIDList eq
olcDbIndex: sambaDomainName eq
olcDbIndex: default sub,eq
...
```
```bash
sed -i "s/# CRC32.*/# CRC32 $(crc32 <(sed '1,2d' /etc/ldap/slapd.d/cn\=config/olcDatabase\=\{1\}mdb.ldif))/g" /etc/ldap/slapd.d/cn\=config/olcDatabase\=\{1\}mdb.ldif
systemctl restart slapd.service
```

## Set samba server for ldap auth
```bash
vi /etc/samba/smb.conf
```
```
...
workgroup = <workgroup>
netbios name = <netbios name>

passdb backend = ldapsam:ldap://<ldap host name>
ldap suffix = <ldap base dn>
ldap user suffix = ou=people
ldap group suffix = ou=groups
ldap machine suffix = ou=computers
ldap idmap suffix = ou=Idmap
ldap admin dn = <ldap admin dn>
ldap ssl = start tls
ldap passwd sync = yes
...
```

## smbldap-config
```
smbldap-config
```

## smbldap-populate
```
smbldap-populate -g 10000 -u 10000 -r 10000
```
