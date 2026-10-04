| Name           | NRP        | Kelas     |
| ---            | ---        | ----------|
|  |  |  |

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
> *This independent task is a continuation of the configurations performed in Parts A through C. Ensure that the previous configurations remain running before proceeding with the independent task.*

#### Soal 1

> Buatlah konfigurasi network seperti yang ada pada soal dengan penambahan node Web3 yang akan digunakan sebagai backend HTTP server baru. Gunakan IP address statis pada subnet yang sama dengan node Web1 dan Web2. Tentukan IP address, subnet mask, dan gateway yang digunakan oleh Web3.
>
> Configure the network for the Web3 node, which will be used as a new HTTP backend server. Use a static IP address within the same subnet as Web1 and Web2. Specify the IP address, subnet mask, and gateway used by Web3.

> [!IMPORTANT]
> Pastikan untuk menunjukkan konfigurasi tiap node, termasuk router, netics-pc-X, web1, web2 dan web3. Ikuti semua langkah yang diberikan pada dokumen soal.
>
> Yang ditunjukkan adalah network configuration, dan service configuration yand ada dalam node tersebut, misal Chernobog adalah DNS server, tunjukkan konfigurasi DNS nya, dan seterusnya.
>
> *Ensure you show the configuration for each node, including the router, netics-pc-X, web1, web2, and web3. Follow all the steps provided in the problem document.*
>
> *What is shown is the network configuration and service configuration present on that node, for example, if `Chernobog` is a DNS server, show its DNS configuration, and so on.*

**Answer:**

```
put your answer here
```

#### Soal 2

> Install dan konfigurasi nginx pada Web3 sebagai HTTP server backend, mengikuti langkah yang sama seperti pada Web1 (netics-pc-8) dan Web2 (netics-pc-9) di Bagian C: install nginx, lalu buat struktur direktori konfigurasi (`/root/myconfig`), web (`/root/myweb`), dan log (`/root/mylogs`) seperti yang digunakan pada Bagian A. Tunjukkan juga ulang konfigurasi nginx serta struktur direktori yang sudah ada pada Web1 dan Web2 sebagai pembanding/verifikasi bahwa keduanya tetap konsisten dengan Web3.
>
> *Install and configure nginx on Web3 as an HTTP backend server, following the same steps used for Web1 (netics-pc-8) and Web2 (netics-pc-9) in Part C: install nginx, then create the configuration (`/root/myconfig`), web (`/root/myweb`), and log (`/root/mylogs`) directory structure used in Part A. Also show the existing nginx configuration and directory structure on Web1 and Web2 as a comparison/verification that they remain consistent with Web3.*


**Answer:**

```
put your answer here (and screenshot)
```


#### Soal 3

> Buatlah halaman `index.html` pada Web3 yang memiliki isi berbeda dari Web1 (berisi "Ini WEB-1") dan Web2 (berisi "Ini WEB-2") sehingga dapat digunakan untuk membuktikan bahwa request berhasil diteruskan ke Web3.
>
> *Create an `index.html` page on Web3 with content different from Web1 (which contains "Ini WEB-1") and Web2 (which contains "Ini WEB-2") so that it can be used to prove that requests are successfully forwarded to Web3.*
 
**Answer:**


```
put your answer here (and screenshot)
```

#### Soal 4

> Konfigurasikan nginx pada Web3 agar HTTP server berjalan pada port `8080` (sama seperti Web1 dan Web2). Jelaskan konfigurasi `listen`, `server_name`, `root`, `index`, dan `location` yang digunakan.
> Kemudian buktikan bahwa HTTP server pada Web3 dapat diakses secara langsung dari client menggunakan alamat IP dan port `8080`. Gunakan `curl` untuk melakukan pengujian.
>
> *Configure nginx on Web3 so that the HTTP server runs on port `8080` (the same as Web1 and Web2). Explain the purpose of the `listen`, `server_name`, `root`, `index`, and `location` directives used in the configuration.*
> *Then, prove that the HTTP server on Web3 can be accessed directly from a client using its IP address and port `8080`. Use `curl` to perform the test.*
 
**Answer:**


```
put your answer here (and screenshot)
```

#### Soal 5

> Konfigurasikan reverse proxy pada `Kazdel` (yang sudah memiliki blok `location` untuk `/web1` menuju Web1 dan `/web2` menuju Web2) agar request ke `http://www.netics.my.id/web3` diteruskan ke Web3 melalui port `8080`, dengan menambahkan blok `location` baru pada `nginx.conf` tanpa mengganggu konfigurasi `/web1`, `/web2`, dan `/app` yang sudah ada.
>
> *Configure the reverse proxy on `Kazdel` (which already has `location` blocks for `/web1` pointing to Web1 and `/web2` pointing to Web2) so that requests to `http://www.netics.my.id/web3` are forwarded to Web3 through port `8080`, by adding a new `location` block in `nginx.conf` without disrupting the existing `/web1`, `/web2`, and `/app` configuration.*
 
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
> *Prove that Web3 can be accessed through the reverse proxy using:*
>
> `curl http://www.netics.my.id/web3`
>
> *Make sure that the received response contains the page content served by Web3, and also show that the pre-existing `/web1` and `/web2` endpoints still work normally after adding `/web3`.*
 
**Answer:**

```
put your answer here (and screenshot)
```

#### Soal 7

> Tambahkan record DNS baru untuk domain `app.netics.my.id` pada DNS server (Chernobog, zona `netics.my.id`). Domain tersebut harus mengarah ke IP address reverse proxy `Kazdel` ([IP Prefix].200.11), bukan langsung ke Web3.
> Buktikan bahwa `app.netics.my.id` berhasil di-resolve oleh client menggunakan DNS server internal. Gunakan `ping` atau command DNS yang tersedia untuk menunjukkan hasil resolusi.
>
> *Add a new DNS record for `app.netics.my.id` on the DNS server (Chernobog, zone `netics.my.id`). The domain must point to the IP address of the reverse proxy `Kazdel` ([IP Prefix].200.11), not directly to Web3.*
> *Prove that `app.netics.my.id` can be successfully resolved by the client using the internal DNS server. Use `ping` or an available DNS command to show the resolution result.*
 
**Answer:**


```
put your answer here (and screenshot)
```

#### Soal 8

> Konfigurasikan nginx pada `Kazdel` agar `app.netics.my.id` dapat digunakan sebagai name-based virtual host. Request ke domain tersebut harus diteruskan ke Web3.
> Buktikan bahwa `app.netics.my.id` dapat digunakan untuk mengakses Web3 melalui reverse proxy menggunakan `curl`.
>
> *Configure nginx on `Kazdel` so that `app.netics.my.id` can be used as a name-based virtual host. Requests to this domain must be forwarded to Web3.*
> *Prove that `app.netics.my.id` can be used to access Web3 through the reverse proxy using `curl`.*

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
> *Prove that each of the following endpoints reaches the correct backend:*
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
> *Configure and run `termshark` and the nginx reverse proxy simultaneously using `tmux` to capture HTTP traffic when a client accesses Web3 via the reverse proxy (Kazdel).*
> *Use `termshark` to observe the HTTP request received by Web3. Identify the source IP, destination IP, source port, destination port, and HTTP information contained in the packet.*

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
> *Test access to Web3 through the reverse proxy from at least two different clients, such as `Sargon` and `Iberia`. Observe the `X-Real-IP` value for each request using `termshark`.*
>
> *Prove that the `X-Real-IP` header is forwarded by the reverse proxy to Web3. Show the value of `X-Real-IP` received by Web3.*
> *Compare the source IP address of the packet received by Web3 with the value of `X-Real-IP`. Are they the same? Explain why the two values may be different.*

**Answer:**

```
put your answer here (and screenshot)
```

#### Soal 12

> Buatlah kesimpulan mengenai arsitektur yang telah dibuat. Jelaskan hubungan antara DNS server, reverse proxy, Web1, Web2, aplikasi Flask, dan Web3. Jelaskan juga bagaimana request dari client dapat mencapai backend yang berbeda menggunakan satu reverse proxy.
>
> *Write a conclusion about the architecture you have implemented. Explain the relationship between the DNS server, reverse proxy, Web1, Web2, the Flask application, and Web3. Also explain how client requests can reach different backends through a single reverse proxy.*

**Answer:**

```
put your answer here (or additionally screenshot)
```

AJK
