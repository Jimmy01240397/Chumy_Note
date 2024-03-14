# Nginx bind frontend and backend

```
server {
    listen 80;
    listen [::]:80;

    server_name yuhongtestweb.chummydns.com;

    client_max_body_size 100M;

    root /var/www/yuhongfashionweb;

    location / {
        try_files $uri $uri/ @backend1;
    }

    location @backend1 {
        proxy_set_header Host $host;
        proxy_pass http://localhost:8080;
        proxy_http_version 1.1;
        proxy_read_timeout 3600;

        proxy_intercept_errors on;
        recursive_error_pages on;
        error_page 404 = @backend2;
    }

    location @backend2 {
        proxy_set_header Host $host;
        proxy_pass http://localhost:8000;
        proxy_http_version 1.1;
        proxy_read_timeout 3600;
        proxy_intercept_errors on;
        error_page 404 =200 /;
    }

}
```
