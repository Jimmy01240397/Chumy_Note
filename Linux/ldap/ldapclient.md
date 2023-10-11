# LDAP client

copy from dino

1. install ldap client and logon as ldap user 

```bash
apt-get install libnss-ldapd libpam-ldapd ldap-utils
```

2. 設定讓ldap 帳號可以本地登入

```bash
vim /etc/nsswitch.conf
```

3. 在 passwd 跟 group的後面加上ldap 

```bash
passwd:         compat systemd ldap
group:          compat systemd ldap
```

4. Write `/etc/nslcd.conf`

5. 設定PAM 讓加入ldap的有權限建立家目錄

```bash
pam-auth-update
```

![image](https://user-images.githubusercontent.com/57281249/151607602-d6251838-b6d6-4488-87d1-3ee4ec6d7d32.png)

6. Restart nslcd and nscd
```bash
systemctl restart nslcd
systemctl restart nscd
nscd -i passwd
nscd -i group
```


7. 查詢ldap 帳號
```bash
getent passwd
```
