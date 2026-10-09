# install update dan iptables dulu
apk update
apk add iptables

# 1. aktifkan packet forwarding
sysctl -w net.ipv4.ip_forward=1

# 2. aktifkan iptables routing.
# -t nat : menggunakan table NAT.
# -A POSTROUTING : Append POSTROUTING, tandai packet yang akan keluar dari Router dengan rule POSTROUTING chain
# -s 10.127.0.0/16 : hanya terapkan rule pada packet dari source dalam lingkup IP 10.127.0.0/16 saja, selain itu abaikan
# -o eth0 : Outputnya ke eth0, semua aturan/rule diterapkan ke eth0
# -j MASQUERADE : mengganti ip asal dengan ip output yaitu eth0 agar dikenal oleh NAT.
iptables -t nat -A POSTROUTING -s 10.127.0.0/16 -o eth0 -j MASQUERADE