#!/bin/sh

set -e

echo "Menjalankan setup otomatis..."
echo

echo "Step-1: install nginx"
echo
echo "nameserver 8.8.8.8" > /etc/resolv.conf
apk update
apk add nginx

echo "Step-2: membuat workspace nginx"
echo

mkdir -p /root/myconfig
mkdir -p /root/myweb
mkdir -p /root/mylogs

echo "Step-3: menulis konfigurasi nginx di /root/myconfig/nginx.conf"
echo

cat << 'EOF' > /root/myconfig/nginx.conf
user root;
worker_processes auto;
worker_cpu_affinity auto;
pid /tmp/nginx.pid;
error_log /root/mylogs/error.log;

events {
    worker_connections 768;
}

http {
    server {
        listen 8080;
        server_name _;
        root /root/myweb;
        index index.html;
        location / {
            try_files $uri $uri/ =404;
        }
    }
}
EOF

echo "Step-4: membuat web sederhana..."
echo

cat << 'EOF' > /root/myweb/index.html
<html>
  <head>
    <title>This is my web 1</title>
  </head>
  <body>
    <h1>Ini WEB-1</h1>
  </body>
</html>
EOF

echo "Step-5: jalankan nginx"
nginx -c /root/myconfig/nginx.conf