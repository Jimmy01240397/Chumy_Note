# Real world Mail server

## 參考連結

[Tiger-Workshop Blog](https://blog.tiger-workshop.com/tag/postfix/)

[mail tester](https://www.mail-tester.com/)


## Postfix

### init
```bash
apt-get install postfix
```

### `main.cf`

```
smtpd_banner = $myhostname ESMTP $mail_name (Debian/GNU)
biff = no

# appending .domain is the MUA's job.
append_dot_mydomain = no

# Uncomment the next line to generate "delayed mail" warnings
#delay_warning_time = 4h

readme_directory = no

# See http://www.postfix.org/COMPATIBILITY_README.html -- default to 3.6 on
# fresh installs.
compatibility_level = 3.6

# TLS parameters
smtpd_tls_cert_file=/etc/postfix/ssl/tscctf.com/fullchain.pem
smtpd_tls_key_file=/etc/postfix/ssl/tscctf.com/privkey.pem
smtpd_tls_security_level=may
smtpd_use_tls = yes
smtp_tls_CApath=/etc/ssl/certs
smtp_tls_security_level=may
smtp_tls_session_cache_database = btree:${data_directory}/smtp_scache

smtpd_tls_ciphers = high
smtpd_tls_protocols = TLSv1,!SSLv2,!SSLv3
smtpd_tls_exclude_ciphers = aNULL,DES,3DES,MD5,DES+MD5,RC4

# DKIM
milter_default_action = accept
milter_protocol = 6
smtpd_milters = local:/run/opendkim/opendkim.sock
non_smtpd_milters = local:/run/opendkim/opendkim.sock

smtpd_helo_required=yes
smtpd_recipient_restrictions=reject_non_fqdn_hostname reject_non_fqdn_sender reject_invalid_hostname reject_unknown_sender_domain reject_unknown_recipient_domain reject_non_fqdn_recipient permit
smtpd_helo_restrictions = reject_invalid_helo_hostname
maximal_queue_lifetime = 1h
bounce_queue_lifetime = 1h
notify_classes = bounce, delay, policy, protocol, resource, software
defer_transports =

smtpd_relay_restrictions = permit_mynetworks permit_sasl_authenticated defer_unauth_destination
myhostname = tscctf.com
mydomain = tscctf.com
alias_maps = hash:/etc/aliases
alias_database = hash:/etc/aliases
myorigin = /etc/mailname
mydestination = $myhostname, mail.tscctf.com, TSC-mail, localhost.localdomain, localhost
relayhost =
mynetworks = 127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128
mailbox_size_limit = 0
recipient_delimiter = +
inet_interfaces = all
inet_protocols = all
```

### `master.cf``

```
smtp      inet  n       -       y       -       -       smtpd
submission inet n       -       y       -       -       smtpd
  -o syslog_name=postfix/submission
  -o smtpd_sasl_auth_enable=yes
  -o smtpd_tls_auth_only=yes
  -o smtpd_sasl_local_domain=$myhostname
  -o smtpd_sasl_security_options=noanonymous
  -o smtpd_sasl_type=dovecot
  -o smtpd_sasl_path=private/auth
  -o broken_sasl_auth_clients=yes
  -o smtpd_recipient_restrictions=permit_mynetworks,permit_sasl_authenticated,reject_unauth_destination,reject_authenticated_sender_login_mismatch
```

### `/etc/mailname`
```
tscctf.com
```

### restart
```
systemctl restart postfix.service
systemctl reload postfix.service
```

## opendkim

### init

```bash
apt-get install opendkim opendkim-tools
usermod -a -G opendkim postfix
mkdir -p /var/spool/postfix/run/opendkim
mkdir -p /etc/opendkim/keys/tscctf.com
cd /etc/opendkim/keys/tscctf.com
opendkim-genkey -t -s mail -d tscctf.com
chown -R opendkim:opendkim /etc/opendkim
```

### `/etc/default/opendkim`

```
RUNDIR=/var/spool/postfix/run/opendkim
```

### `/etc/opendkim.conf`

```
# Key table
KeyTable           /etc/opendkim/KeyTable
SigningTable       /etc/opendkim/SigningTable
```

### `/etc/opendkim/KeyTable`

```
mail._domainkey.tscctf.com tscctf.com:mail:/etc/opendkim/keys/tscctf.com/mail.private
```

### `/etc/opendkim/SigningTable`

```
tscctf.com mail._domainkey.tscctf.com
```

### restart
```
systemctl restart opendkim.service
systemctl reload opendkim.service
```

## DNS
```
<IP rdns> 1 IN PTR mail.tscctf.com.

mail.tscctf.com.	1	IN	A	<IP>
tscctf.com.	1	IN	MX	10 mail.tscctf.com.
_dmarc.tscctf.com.	1	IN	TXT	"v=DMARC1; p=none; rua=mailto:postmaster@tscctf.com"
mail._domainkey.tscctf.com.	1	IN	TXT	</etc/opendkim/keys/tscctf.com/mail.txt>
tscctf.com.	1	IN	TXT	"v=spf1 ip4:140.116.246.59 ~all"
```

## dovecot

### init

```bash
apt install dovecot-core dovecot-imapd
```

### `10-auth.conf`

```
auth_username_format = %n
auth_mechanisms = plain login
```

### `10-ssl.conf`

```
ssl = yes
ssl_cert = </etc/postfix/ssl/tscctf.com/fullchain.pem
ssl_key = </etc/postfix/ssl/tscctf.com/privkey.pem
ssl_client_ca_dir = /etc/ssl/certs
ssl_dh = </usr/share/dovecot/dh.pem
ssl_min_protocol = TLSv1.2
```

### `10-master.conf`

```
  # Postfix smtp-auth
  unix_listener /var/spool/postfix/private/auth {
    mode = 0666
    user = postfix
    group = postfix
  }
```




