# install
``` bash
apt install dpkg-dev devscripts
apt source nginx
apt build-dep nginx
apt install libldap2-dev libssl-dev libpcre3-dev
git clone https://github.com/kvspb/nginx-auth-ldap.git
cd nginx-1.14.2/debian
vi rules

   ... \
   --add-module=<path to>/nginx-auth-ldap \
   
cd ..
debuild -b -uc -us

dpkg -i nginx-common*
dpkg -i libnginx-mod-*
dpkg -i nginx-core*
dpkg -i nginx-full*
dpkg -i nginx_*
```

# Config
``` bash
ldap_server ldapserver {
   url ldap://ldap.chummy.finalexam.ncku/dc=ldap,dc=chummy,dc=finalexam,dc=ncku?uid?sub?(&(objectClass=account)(gidNumber=2000));
   binddn "cn=admin,dc=ldap,dc=chummy,dc=finalexam,dc=ncku";
   binddn_passwd "finalexam";
   group_attribute uniquemember
   group_attribute_is_dn on;
   require valid_user;
}

server {
   ...
   location /auth {
      auth_ldap "Forbidden";
      auth_ldap_servers ldapserver;
   }
   ...
}
```
