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
