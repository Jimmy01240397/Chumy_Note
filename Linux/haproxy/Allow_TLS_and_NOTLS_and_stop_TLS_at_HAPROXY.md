# Allow TLS and NOTLS and stop TLS at HAPROXY

Need 2 haproxy server to implement.

# Proxy1

```
frontend nckuctfbegin
    mode tcp
    bind [::]:29000-29999 v4v6
    tcp-request inspect-delay 100ms
    tcp-request content accept if { req_ssl_hello_type 1 }
    use_backend reverseproxy if { req_ssl_hello_type 1 }
    default_backend nckuctfbegin

backend reverseproxy
    mode tcp
    option ssl-hello-chk
    server reverseproxy 10.128.0.2

backend nckuctfbegin
    mode tcp
    server nckuctfbegin 10.130.0.5
```

# Proxy2

```
frontend nckuctfbegin
    mode tcp
    bind [::]:29000-29999 v4v6 ssl crt /etc/haproxy/certs
    default_backend nckuctfbegin

backend nckuctfbegin
    mode tcp
    server nckuctfbegin 10.130.0.5
```
