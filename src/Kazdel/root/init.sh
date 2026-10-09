#!/bin/sh

set -e

echo
echo "Menjalankan setup Kazdel otomatis..."
echo

echo "Step-1: tambah google public dns agar request client ke internet bisa diterjemahkan google"
echo

echo "nameserver 8.8.8.8" > /etc/resolv.conf

echo "Step-2: install nginx"
echo
apk update
apk add nginx

echo
echo "Step-3: setup workspace directory untuk nginx kita"
echo
mkdir -p /root/myconfig
mkdir -p /root/myweb
mkdir -p /root/mylogs

echo "Step-4: tulis /root/myweb/index.html sederhana"
echo

cat << 'EOF' > /root/myweb/index.html
<html>
  <head>
    <title>This is my Web in Kazdel</title>
  </head>
  <body>
    <h1>This is my Web in Kazdel</h1>
  </body>
</html>
EOF

echo "Step-5: menulis konfigurasi nginx di /root/myconfig/nginx.conf"
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
        listen 80;
        server_name _;
        root /root/myweb;
        index index.html;
        location / {
            try_files $uri $uri/ =404;
        }
    }
}
EOF

echo "Establish netic.org..."
echo

echo "Step-5.1: menambahkan web /root/myweb-netics-org"
echo

mkdir -p /root/myweb-netics-org
cat << 'EOF' > /root/myweb-netics-org/index.html
<html>
  <head>
    <title>netics.org</title>
  </head>
  <body>
    <h1>This is my NETICS-ORG</h1>
  </body>
</html>
EOF

echo "Step-5.2: mengedit nginx.conf"
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
        listen 80;
        server_name www.netics.my.id;
        root /root/myweb;
        index index.html;
        location / {
            try_files $uri $uri/ =404;
        }
        location = /Web1 {
            proxy_pass http://10.127.200.20:8080/;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
        }
        location = /Web2 {
            proxy_pass http://10.127.200.21:8080/;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
        }
        location = /app {
            proxy_pass http://10.127.200.21:5000/;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
        }
    }
    server {
        listen 80;
        server_name web.netics.org;
        root /root/myweb-netics-org;
        index index.html;
        location / {
            try_files $uri $uri/ =404;
        }
    }
}
EOF

echo "Step-6: jalankan nginx"
nginx -c /root/myconfig/nginx.conf