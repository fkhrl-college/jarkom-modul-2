#!/bin/sh

set -e

echo "Menjalankan setup Chernobog otomatis..."
echo

echo "Step-1: membuat workspace directory untuk dns di /root/dns dan /root/dnsdata"
echo

mkdir -p /root/dns
mkdir -p /root/dnsdata

echo "Step-3: tambah google public dns untuk akses internet lalu install bind"
echo
echo "nameserver 8.8.8.8" > /etc/resolv.conf
apk update
apk add bind

echo "Step-4: tulis konfigurasi domain name di /root/dns/named.conf"
cat << 'EOF' > /root/dns/named.conf
options {
    directory "/root/dns";
    listen-on {
        any;
    };
    allow-query {
        any;
    };
};

logging {
    channel default_log {
        file "/root/dns/named.log" versions 3 size 5m;
        severity info;
        print-time yes;
        print-severity yes;
        print-category yes;
    };
    category default {
        default_log;
    };
    category queries {
        default_log;
    };
};

zone "localhost" {
    type master;
    file "db.localhost";
};

zone "netics.my.id" {
    type master;
    file "db.netics.my.id";
};
EOF

echo
echo "Step-5: tulis tabel yang memetakan konfigurasi nama domain"
echo "Menulis /root/dns/db.localhost"
cat << 'EOF' > /root/dns/db.localhost
$TTL 86400
@ IN SOA localhost. root.localhost. (
    1
    3600
    1800
    604800
    86400)

@ IN NS localhost.
@ IN A  127.0.0.1
EOF

echo "Menulis /root/dns/db.netics.my.id"
cat << 'EOF' > /root/dns/db.netics.my.id
$TTL 86400
@ IN SOA ns1.netics.my.id admin.netics.my.id (
    1
    3600
    1800
    604800
    8400)

@   IN  NS  ns1.netics.my.id.
ns1 IN  A   10.127.200.12
www IN  A   10.127.200.11
EOF

echo "Menambahkan netics.org"
echo "Step-5.1: append zone baru netics.org di /root/dns/named.conf"
echo
cat << 'EOF' >> /root/dns/named.conf
zone "netics.org" {
    type master;
    file "db.netics.org";
};
EOF

echo "Step-5.2: tulis db.netics.org"
echo
cat << 'EOF' > /root/dns/db.netics.org
$TTL 86400
@ IN SOA ns1.netics.org. admin.netics.org. (
    1
    3600
    1800
    604800
    86400)

@   IN NS   ns1.netics.org.
ns1 IN A    10.127.200.12
web IN A    10.127.200.11
EOF

echo
echo "Step-6: buat script starter dns server di /root/dns/start_dns.sh"
cat << 'EOF' > /root/dns/start_dns.sh
#!/bin/sh
nohup named -g -c /root/dns/named.conf > /var/log/named.log 2>&1 &
EOF

echo
echo "Step-7: jalankan server dnsnya"
chmod +x /root/dns/start_dns.sh
/root/dns/start_dns.sh

echo "Log file bisa dilihat di /var/log/named.log"