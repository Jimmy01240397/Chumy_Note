# Set memberof overlay

1. Write ldif
```ldif
dn: cn=module,cn=config
objectClass: olcModuleList
cn: module
olcModulePath: /usr/lib/ldap
olcModuleLoad: memberof

dn: olcOverlay=memberof,olcDatabase={1}mdb,cn=config
objectClass: olcConfig
objectClass: olcMemberOf
objectClass: olcOverlayConfig
objectClass: top
olcOverlay: memberof
olcMemberOfDangling: ignore
olcMemberOfRefInt: TRUE
olcMemberOfGroupOC: <group objectClass>
olcMemberOfMemberAD: member
olcMemberOfMemberOfAD: memberOf
```

2. Run command to setup setting
```bash
sudo -u openldap slapadd -b cn=config -l <overlay ldif file>
systemctl restart slapd.service
```
