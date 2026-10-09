#!/bin/sh
set -e

echo
echo "Menjalankan setup Aegir otomatis..."
echo

echo
echo "Step-1: tambah google public dns"
echo

echo "nameserver 8.8.8.8" > /etc/resolv.conf

echo
echo "Step-2: menulis konfigurasi udhcpd di /etc/dhcpd.conf"
echo

touch /etc/dhcpd.leases
cat << 'EOF' > /etc/dhcpd.conf
start 10.127.200.100
end 10.127.200.150
max_leases 50
pidfile /etc/dhcpd.pid
lease_file /etc/dhcpd.leases
option subnet 255.255.255.0
option router 10.127.200.1
EOF

echo
echo "Step-3: Jalankan dhcp server di background"
echo

udhcpd -f /etc/dhcpd.conf > /var/log/dhcpd.log 2>&1 &

echo "File log udhcp disimpan di /var/log/dhcpd.log"
echo "Setup selesai"

echo "Step-4: tambahkan konfigurasi dns ke /etc/dhcpd.conf"
# matikan udhcpd lama
killall udhcpd 2>/dev/null || true
echo "option dns 10.127.200.12 8.8.8.8" >> /etc/dhcpd.conf
# nyalakan kembali 
udhcpd -f /etc/dhcpd.conf > /var/log/dhcpd.log 2>&1 &