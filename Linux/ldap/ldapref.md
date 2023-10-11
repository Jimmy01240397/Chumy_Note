# LDAP referral

```ldif
dn: dc=subtree,dc=example,dc=net
objectClass: referral
bjectClass: extensibleObject
dc: subtree
ref: ldap://b.example.net/dc=subtree,dc=example,dc=net
```
