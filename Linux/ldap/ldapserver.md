# LDAP server

copy from dino

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

![image](https://user-images.githubusercontent.com/57281249/151606974-6b1d212a-6da9-4238-91ba-739ee0a9347b.png)

設定Domain name

![image](https://user-images.githubusercontent.com/57281249/151607012-56a3eefb-0d2f-48d8-a05f-c541ac3c0ee8.png)

設定OU

![image](https://user-images.githubusercontent.com/57281249/151607043-b36fcdf7-ac6a-48e7-8421-f8ff7c006277.png)

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

|  url | protocol | transport|
|------|----------|----------|
|  ldap:// | LDAP | tcp 389 |
|  ldaps:// | LDAP over SSL | tcp 636 |
|  ldapi:// | LDAP | IPC (Unix-domain socket) |
