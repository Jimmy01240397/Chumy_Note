server

```bash
apt-get install slapd ldap-utils
```

安裝完成後設定administrator 密碼

查看ldap 資訊指令:

```bash
slapcat 
```

設定ldap domain 資訊:

```bash
dpkg-reconfig slapd
```

選NO開始互動式設定資訊

![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/1f25bf6b-879a-418d-b9e7-37d967ad5408/Untitled.png)

設定Domain name

![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/87991fc4-7f35-4532-bab4-71616a992848/Untitled.png)

設定OU

![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/1cabd87c-bb3e-487d-9120-aab436a8941f/Untitled.png)

建立ldif 的使用者範本

ldif = LDAP Data Interchange Format

```bash
vim /etc/ldap/base.ldif
```

```bash
dn: ou=people,dc=skill39,dc=com
objectClass: organzationalUnit
ou: people

dn: ou=groups,dc=skill39,dc=com
objectClass: organzationalUnit
ou: groups
```

新增完成ldif 檔案後用ldapadd 新增進去

```bash
ldapadd -x -D "cn=admin,dc=skill39,dc=com" -W -f base.ldif
```

以上建立完成之後先新增user & group 的ldif 範本

首先需要使用slappasswd 建立使用者的密碼

```bash
slappasswd 
```

```bash
output:

New password:
Re-enter new password:
{SSHA}xxxxxxxxxxxxxxxxx
```

```bash
vim ldapuser.ldif
```

```bash
dn: cn=john,ou=people,dc=skill39,dc=com
objectClass: top
objectClass: account
objectClass: posixAccount
objectClass: shadowAccount
cn: john
uid: john
userPassword: {SSHA}xxxxxxxxxxxxxxxxx
loginShell: /bin/bash
uidNumber: 2000
gidNumber: 2000
homeDirectory: /home/john

dn: cn=john,ou=groups,dc=skill39,dc=com
objectClass: posixGroup
cn: jonn
gidNumber: 2000
memberUid: john
```

使用上面的ldapuser.ldif 新增使用

```bash
ldapadd -x -D cn=admin,dc=skill39,dc=com -W -f ldapuser.ldif
```

刪除john 使用者

```bash
ldapdelete -x -W -D 'cn=admin,dc=skill39,dc=com' "uid=john,ou=people,dc=skill39,dc=com"
```

刪除john 群組

```bash
ldapdelete -x -w -D 'cn=admin,dc=skill39,dc=com' "cn=john,ou=groups,dc=skill39,dc=com"
```

[LDAP protocol](https://www.notion.so/b5ac0093195a4d5d94b2539552577b69)
