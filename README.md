| Name                 | NRP        | Kelas |
| -------------------- | ---------- | ----- |
| Ahmad Fakhrul Bawani | 5025251143 | B051  |
|                      |            |       |

> [!IMPORTANT]
> Remember to use the IP prefix allocation provided earlier for this pre-lab assignment (pra-praktikan) and for future ones.
> Access it on [Linktree](https://linktr.ee/jarkom)

> [!TIP]
> **Due Date : 15th October 2026, 23.00 WIB**

## Put your GNS3 Project files here!

`Put file URL here`

# Tugas Mandiri (Bagian A, B dan C)

> [!IMPORTANT]
> Tugas mandiri ini adalah kelanjutan dari konfigurasi yang telah dikerjakan pada Bagian A hingga C. Pastikan konfigurasi sebelumnya tetap berjalan sebelum mengerjakan tugas mandiri.
>
> _This independent task is a continuation of the configurations performed in Parts A through C. Ensure that the previous configurations remain running before proceeding with the independent task._

#### Soal 1

> Buatlah konfigurasi network seperti yang ada pada soal dengan penambahan node Web3 yang akan digunakan sebagai backend HTTP server baru. Gunakan IP address statis pada subnet yang sama dengan node Web1 dan Web2. Tentukan IP address, subnet mask, dan gateway yang digunakan oleh Web3.
>
> Configure the network for the Web3 node, which will be used as a new HTTP backend server. Use a static IP address within the same subnet as Web1 and Web2. Specify the IP address, subnet mask, and gateway used by Web3.

> [!IMPORTANT]
> Pastikan untuk menunjukkan konfigurasi tiap node, termasuk router, netics-pc-X, web1, web2 dan web3. Ikuti semua langkah yang diberikan pada dokumen soal.
>
> Yang ditunjukkan adalah network configuration, dan service configuration yand ada dalam node tersebut, misal Chernobog adalah DNS server, tunjukkan konfigurasi DNS nya, dan seterusnya.
>
> _Ensure you show the configuration for each node, including the router, netics-pc-X, web1, web2, and web3. Follow all the steps provided in the problem document._
>
> _What is shown is the network configuration and service configuration present on that node, for example, if `Chernobog` is a DNS server, show its DNS configuration, and so on._

**Answer:**

**Router**

1. Ambil netics-pc sebagai router ganti nama dengan `Router` dan hubungkan ke Nat via nat0-eth0.
2. Configure dengan `configure > network configuration > klik edit` atau lewat `nano /ect/network/interfaces` dengan config berikut:

```bash
# biarkan mendapatkan ip dhcp dari nat otomatis
auto eth0
iface eth0 inet dhcp

# set static ip pada eth0 Router
auto eth1
iface eth1 inet static
	address 10.127.200.1
	netmask 255.255.255.0

# selalu cek dengan ip -br addr apakah IP address sudah terassignn dengan benar
```

3. Router sekarang dapat terhubung ke internet. Namun Router harus menjalankan tugas sebagai `Data Plane` yaitu forwarding packet, menjadi perantara yang meneruskan paket ke alamat yg sesuai. Ini bisa dilakukan dengan mengaktifkan `ip forwarding`. Lalu Nat menggunakan IP Publik, tetapi topologi menggunakan IP Private lokal, sehingga public IP nat harus disesuaikan/diterjemahkan ke IP private lokal kita. Ini bisa dilakukan dengan `iptables` :

```bash
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
```

<br />

**Switch**

1. Hubungkan Router-switch 1 dengan interface eth1-eth0
2. Hubungkan switch 1-switch 2 dengan interface eth1-eth0
3. Hubungkan switch 1-Kazdel dengan interface eth2-eth0
4. Hubungkan switch 1-Aegir dengan interface eth3-eth0
5. Hubungkan switch 2-Sargon, Iberia, Higashi, Ognisko bertuturut-turut dengan interface eth1-eth0, eth2-eth0, eth3-eth0, eth4-eth0

**Aegir (DHCP Server)**

1. Ambil netics-pc lalu konfigurasikan interface (seperti langkah 2 router) dengan konfigurasi static IP berikut:

```bash
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
	address 10.127.200.10
	netmask 255.255.255.0
	gateway 10.127.200.1 # alamat ip gerbang keluar dari local subnet, yaitu alamat IP Router karena Router lah yang terhubung ke NAT.
```

2. Nyalakan dan atur DNS-nya yg ada di `/etc/resolv.conf` menggunakan Google Public DNS `8.8.8.8` atau `8.8.4.4`. Kita gunakan `8.8.8.8` seperti ini:

```bash
echo "nameserver 8.8.8.8" > /etc/resolv.conf
```

3. Install kea-dhcp4 sebagai dhcp server seperti ini:

```bash
apk update
apk add kea-dhcp4

# cek versi terinstall
kea-dhcp4 -V
```

4. Konfigurasikan dhcp server di `/etc/kea/kea-dhcp4.conf` seperti berikut ini (di nano, alt+A untuk block tulisan, ctrl + k untuk delete):

```conf
{
  "Dhcp4": {
    "interfaces-config": {
      "interfaces": ["eth0"]
    },
    "lease-database": {
      "type": "memfile",
      "persist": true,
      "name": "/var/lib/kea/kea-leases4.csv"
    },
    "valid-lifetime": 600,
    "max-valid-lifetime": 7200,
    "subnet4": [
      {
        "id": 1,
        "subnet": "10.127.200.0/24", # subnet di 10.127.200.0 dengan netmask 24 bit. oktet akhir .0 sebagai nama subnet
        "pools": [
          { "pool": "10.127.200.100 - 10.127.200.150" } # ip address range dhcp. Hanya dari 10.127.200.1 sd. 10.127.200.254 karena .0 digunakan sebagai nama subnet dan .255 sebagai broadcast.
        ],
        "option-data": [
          { "name": "routers", "data": "10.127.200.1" } # set router Ip sebagai 10.127.200.1
        ]
      }
    ]
  }
}
```

- Tes syntax dulu, seharusnya tidak return apa-apa:
  ```bash
  kea-dhcp4 -t /etc/kea/kea-dhcp4.conf 2>&1 | grep -i -A 3 "error"
  ```

**Kazdel HTTP Server**

1. Ambil netics-server lalu configurasi IP interfacenya seperti ini:

```bash
auto eth0
iface eth0 inet static
	address 10.127.200.11
	netmask 255.255.255.0
	gateway 10.127.200.1
```

2. Tambah Google public DNS dan install nginx:

```bash
echo "nameserver 8.8.8.8" > /etc/resolv.conf
apk update
apk add nginx
```

3. Buat struktur direktori nginx workspace:

```bash
mkdir -p /root/myconfig
mkdir -p /root/myweb
mkdir -p /root/mylogs
```

4. Buat simple html di `/root/myweb/index.html`:

```html
<html>
  <head>
    <title>This is my Web in Kazdel</title>
  </head>
  <body>
    <h1>This is my Web in Kazdel</h1>
  </body>
</html>
```

5. Buat configurasi nginx di `/root/myconfig/nginx.conf`:

```conf
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
```

- Tes syntax dulu, seharusnya return `...is ok` dan `...is successful`:
  ```bash
  nginx -tc /root/myconfig/nginx.conf
  ```

6. Buat `/root/init.sh` agar nginx otomatis berjalan saat pertama menyala:

```bash
nginx -c /root/myconfig/nginx.conf
```

7. Cek dengan membuka VNC pada Ognisko dan curl pada Sargon, Iberia, Higashi.

**Sargon, Iberia, Higashi**

1. Ambil netics-pc lalu configurasikan seperti ini:

```bash
auto eth0
iface eth0 inet dhcp
```

2. Coba curl ke `http://10.127.200.11`

```bash
curl -vL http://10.127.200.11
```

**Ognisko**

1. Ambil netics-pc-desktop dan configurasikan seperti ini:

```bash
auto eth0
iface eth0 inet dhcp
```

2. Coba buka browser dan pergi ke `http://10.127.200.11`.

#### Soal 2

> Install dan konfigurasi nginx pada Web3 sebagai HTTP server backend, mengikuti langkah yang sama seperti pada Web1 (netics-pc-8) dan Web2 (netics-pc-9) di Bagian C: install nginx, lalu buat struktur direktori konfigurasi (`/root/myconfig`), web (`/root/myweb`), dan log (`/root/mylogs`) seperti yang digunakan pada Bagian A. Tunjukkan juga ulang konfigurasi nginx serta struktur direktori yang sudah ada pada Web1 dan Web2 sebagai pembanding/verifikasi bahwa keduanya tetap konsisten dengan Web3.
>
> _Install and configure nginx on Web3 as an HTTP backend server, following the same steps used for Web1 (netics-pc-8) and Web2 (netics-pc-9) in Part C: install nginx, then create the configuration (`/root/myconfig`), web (`/root/myweb`), and log (`/root/mylogs`) directory structure used in Part A. Also show the existing nginx configuration and directory structure on Web1 and Web2 as a comparison/verification that they remain consistent with Web3._

**Answer:**

```
put your answer here (and screenshot)
```

#### Soal 3

> Buatlah halaman `index.html` pada Web3 yang memiliki isi berbeda dari Web1 (berisi "Ini WEB-1") dan Web2 (berisi "Ini WEB-2") sehingga dapat digunakan untuk membuktikan bahwa request berhasil diteruskan ke Web3.
>
> _Create an `index.html` page on Web3 with content different from Web1 (which contains "Ini WEB-1") and Web2 (which contains "Ini WEB-2") so that it can be used to prove that requests are successfully forwarded to Web3._

**Answer:**

```
put your answer here (and screenshot)
```

#### Soal 4

> Konfigurasikan nginx pada Web3 agar HTTP server berjalan pada port `8080` (sama seperti Web1 dan Web2). Jelaskan konfigurasi `listen`, `server_name`, `root`, `index`, dan `location` yang digunakan.
> Kemudian buktikan bahwa HTTP server pada Web3 dapat diakses secara langsung dari client menggunakan alamat IP dan port `8080`. Gunakan `curl` untuk melakukan pengujian.
>
> _Configure nginx on Web3 so that the HTTP server runs on port `8080` (the same as Web1 and Web2). Explain the purpose of the `listen`, `server_name`, `root`, `index`, and `location` directives used in the configuration._
> _Then, prove that the HTTP server on Web3 can be accessed directly from a client using its IP address and port `8080`. Use `curl` to perform the test._

**Answer:**

```
put your answer here (and screenshot)
```

#### Soal 5

> Konfigurasikan reverse proxy pada `Kazdel` (yang sudah memiliki blok `location` untuk `/web1` menuju Web1 dan `/web2` menuju Web2) agar request ke `http://www.netics.my.id/web3` diteruskan ke Web3 melalui port `8080`, dengan menambahkan blok `location` baru pada `nginx.conf` tanpa mengganggu konfigurasi `/web1`, `/web2`, dan `/app` yang sudah ada.
>
> _Configure the reverse proxy on `Kazdel` (which already has `location` blocks for `/web1` pointing to Web1 and `/web2` pointing to Web2) so that requests to `http://www.netics.my.id/web3` are forwarded to Web3 through port `8080`, by adding a new `location` block in `nginx.conf` without disrupting the existing `/web1`, `/web2`, and `/app` configuration._

**Answer:**

```
put your answer here (and screenshot)
```

#### Soal 6

> Buktikan bahwa Web3 dapat diakses melalui reverse proxy menggunakan:
>
> `curl http://www.netics.my.id/web3`
>
> Pastikan response yang diterima menunjukkan isi halaman dari Web3, dan tunjukkan juga bahwa endpoint `/web1` dan `/web2` yang sudah ada sebelumnya tetap berfungsi normal setelah penambahan `/web3`.
>
> _Prove that Web3 can be accessed through the reverse proxy using:_
>
> `curl http://www.netics.my.id/web3`
>
> _Make sure that the received response contains the page content served by Web3, and also show that the pre-existing `/web1` and `/web2` endpoints still work normally after adding `/web3`._

**Answer:**

```
put your answer here (and screenshot)
```

#### Soal 7

> Tambahkan record DNS baru untuk domain `app.netics.my.id` pada DNS server (Chernobog, zona `netics.my.id`). Domain tersebut harus mengarah ke IP address reverse proxy `Kazdel` ([IP Prefix].200.11), bukan langsung ke Web3.
> Buktikan bahwa `app.netics.my.id` berhasil di-resolve oleh client menggunakan DNS server internal. Gunakan `ping` atau command DNS yang tersedia untuk menunjukkan hasil resolusi.
>
> _Add a new DNS record for `app.netics.my.id` on the DNS server (Chernobog, zone `netics.my.id`). The domain must point to the IP address of the reverse proxy `Kazdel` ([IP Prefix].200.11), not directly to Web3._
> _Prove that `app.netics.my.id` can be successfully resolved by the client using the internal DNS server. Use `ping` or an available DNS command to show the resolution result._

**Answer:**

```
put your answer here (and screenshot)
```

#### Soal 8

> Konfigurasikan nginx pada `Kazdel` agar `app.netics.my.id` dapat digunakan sebagai name-based virtual host. Request ke domain tersebut harus diteruskan ke Web3.
> Buktikan bahwa `app.netics.my.id` dapat digunakan untuk mengakses Web3 melalui reverse proxy menggunakan `curl`.
>
> _Configure nginx on `Kazdel` so that `app.netics.my.id` can be used as a name-based virtual host. Requests to this domain must be forwarded to Web3._
> _Prove that `app.netics.my.id` can be used to access Web3 through the reverse proxy using `curl`._

**Answer:**

```
put your answer here (and screenshot)
```

#### Soal 9

> Buktikan bahwa endpoint berikut menghasilkan backend yang sesuai:
>
> - `http://www.netics.my.id/web1` -> Web1
> - `http://www.netics.my.id/web2` -> Web2
> - `http://www.netics.my.id/app` -> Flask pada Web2
> - `http://www.netics.my.id/web3` -> Web3
> - `http://app.netics.my.id/` -> Web3
>
> _Prove that each of the following endpoints reaches the correct backend:_
>
> - `http://www.netics.my.id/web1` -> Web1
> - `http://www.netics.my.id/web2` -> Web2
> - `http://www.netics.my.id/app` -> Flask on Web2
> - `http://www.netics.my.id/web3` -> Web3
> - `http://app.netics.my.id/` -> Web3

**Answer:**

```
put your answer here (and screenshot)
```

#### Soal 10

> Konfigurasikan dan jalankan `termshark` dan nginx reverse-proxy secara bersamaan menggunakan `tmux` untuk menangkap traffic HTTP ketika client mengakses Web3 melalui reverse proxy (Kazdel).
> Gunakan `termshark` untuk mengamati request HTTP yang diterima oleh Web3. Identifikasi source IP, destination IP, source port, destination port, dan informasi HTTP yang terdapat pada packet.
>
> _Configure and run `termshark` and the nginx reverse proxy simultaneously using `tmux` to capture HTTP traffic when a client accesses Web3 via the reverse proxy (Kazdel)._
> _Use `termshark` to observe the HTTP request received by Web3. Identify the source IP, destination IP, source port, destination port, and HTTP information contained in the packet._

**Answer:**

```
put your answer here (and screenshot)
```

#### Soal 11

> Lakukan pengujian akses Web3 melalui reverse proxy dari minimal dua client yang berbeda, misalnya `Sargon` dan `Iberia`. Amati nilai `X-Real-IP` pada masing-masing request menggunakan `termshark`.
>
> Buktikan bahwa header `X-Real-IP` diteruskan oleh reverse proxy kepada Web3. Tunjukkan nilai `X-Real-IP` yang diterima oleh Web3.
> Bandingkan source IP pada packet yang diterima Web3 dengan nilai `X-Real-IP`. Apakah keduanya sama? Jelaskan mengapa nilai tersebut dapat berbeda.
>
> _Test access to Web3 through the reverse proxy from at least two different clients, such as `Sargon` and `Iberia`. Observe the `X-Real-IP` value for each request using `termshark`._
>
> _Prove that the `X-Real-IP` header is forwarded by the reverse proxy to Web3. Show the value of `X-Real-IP` received by Web3._
> _Compare the source IP address of the packet received by Web3 with the value of `X-Real-IP`. Are they the same? Explain why the two values may be different._

**Answer:**

```
put your answer here (and screenshot)
```

#### Soal 12

> Buatlah kesimpulan mengenai arsitektur yang telah dibuat. Jelaskan hubungan antara DNS server, reverse proxy, Web1, Web2, aplikasi Flask, dan Web3. Jelaskan juga bagaimana request dari client dapat mencapai backend yang berbeda menggunakan satu reverse proxy.
>
> _Write a conclusion about the architecture you have implemented. Explain the relationship between the DNS server, reverse proxy, Web1, Web2, the Flask application, and Web3. Also explain how client requests can reach different backends through a single reverse proxy._

**Answer:**

```
put your answer here (or additionally screenshot)
```

#### Troubleshooting

1. GNS3 `409 conflict, container 'xxxx' is already in use...`. Solution:
   - Go to GNS VM, in main menu click `OK` or `enter`
   - Go to Shell
   - Check any docker container:

   ```bash
   docker ps -a
   ```

   - Delete that container in `container 'xxxx' is already in use...`.
   - Or just delete all of them, but this will restart Router and reinstalling kea-dhcp4 in Aegir:

   ```bash
   docker system prune
   ```

AJK
