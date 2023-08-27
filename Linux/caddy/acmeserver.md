# acmeserver
1. caddyfile
```
{
    pki {
        ca {
            root_cn nsc39
            intermediate_cn N01
            intermediate {
                cert /etc/caddy/certs/N01.crt
                key /etc/caddy/certs/N01.key
            }
        }
    }
}

acme.skills39.tw {
    acme_server
    tls internal
}
```
