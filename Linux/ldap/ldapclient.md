# LDAP client

copy from dino

install ldap client and logon as ldap user 

```bash
apt-get install libnss-ldapd libpam-ldapd ldap-utils
```

![image](https://user-images.githubusercontent.com/57281249/151607349-4cab697e-ac56-4ba3-9c38-578887a861f6.png)

![image](https://user-images.githubusercontent.com/57281249/151607375-45b54c6f-0899-40b8-b320-655f03bbcea7.png)

![image](https://user-images.githubusercontent.com/57281249/151607399-307e1d4b-1a46-4455-9cf3-56fd9e94c239.png)

![image](https://user-images.githubusercontent.com/57281249/151607413-5b278897-5ada-466a-a07a-f25a33c375b1.png)

![image](https://user-images.githubusercontent.com/57281249/151607429-96182ef1-39f1-47f7-bfe1-7ff17c7c5191.png)

![image](https://user-images.githubusercontent.com/57281249/151607447-8a0db22e-0db3-4bcc-b4d9-6a88e3d75b0d.png)

![image](https://user-images.githubusercontent.com/57281249/151607467-d666fc90-0b2c-4ec1-a5da-525663fde816.png)

![image](https://user-images.githubusercontent.com/57281249/151607486-a1c51e2c-11bb-4ef9-918b-401c60f15574.png)

![image](https://user-images.githubusercontent.com/57281249/151607502-376730c8-02a8-411b-916d-5f6b70e6508c.png)

設定讓ldap 帳號可以本地登入

```bash
vim /etc/nsswitch.conf
```

在 passwd 跟 group的後面加上ldap 

```bash
passwd:         compat systemd ldap
group:          compat systemd ldap
```

存檔

設定PAM 讓加入ldap的有權限建立家目錄

```bash
vim /etc/pam.d/common-session
```

加入在檔案的最下方

```bash
session optional        pam_mkhomedir.so skel=/etc/skel umask=077
```

```bash
pam-auth-update
```

![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/2df9f6ff-90fb-48b2-ba7b-daebf0b81156/Untitled.png)

檢查/etc/pam_ldap.conf 裡面的uri 路徑是否正確

```bash
vim /etc/pam_dap.conf
```

```bash
uri ldap://skill39.com/
```

查詢ldap 帳號
```bash
getent passwd
```
```bash
apt-get install nslcd
```
