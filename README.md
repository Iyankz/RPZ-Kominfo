<div align="center">

# 🛡️ Auto-Sync DNS RPZ Komdigi
### Bind9 – Real-Time Response Policy Zone

Integrasi otomatis **Database Pemblokiran Konten Negatif (RPZ)**  
dari **Komdigi (sebelumnya Kominfo)** ke **DNS Server Bind9**  
dengan mekanisme **sinkronisasi real-time & terjadwal**.

<br/>

![License](https://img.shields.io/badge/License-MIT-yellow.svg)
![Ubuntu](https://img.shields.io/badge/Ubuntu-22.04%20%7C%2024.04-E95420?logo=ubuntu&logoColor=white)
![Debian](https://img.shields.io/badge/Debian-12%20%7C%2013-A81D33?logo=debian&logoColor=white)
![Bind9](https://img.shields.io/badge/DNS-Bind9-blue)

</div>

---

## 📌 Tentang Proyek

**Auto-Sync DNS RPZ Komdigi** adalah skrip otomatis untuk mengintegrasikan  
**Response Policy Zone (RPZ)** dari Komdigi langsung ke **Bind9 DNS Server**.

Proyek ini ditujukan untuk:
- ISP / NAP
- NOC & SOC
- Enterprise Network
- Data Center & Private DNS Resolver

Tujuan utama proyek ini adalah:
> **Menyederhanakan implementasi DNS filtering nasional secara aman, konsisten, dan mudah dipelihara.**

---

## ✨ Fitur Utama

- ✅ Sinkronisasi otomatis database RPZ Komdigi
- ✅ Integrasi native dengan **Bind9**
- ✅ Update real-time & terjadwal
- ✅ Logging terpusat & mudah dipantau
- ✅ Minim intervensi manual
- ✅ Siap digunakan di lingkungan produksi

---

## 🖥️ Kompatibilitas Sistem Operasi

Skrip ini telah diuji dan dioptimalkan pada sistem berikut:

| Distribusi | Versi |
|-----------|-------|
| **Debian** | 12 (Bookworm), 13 (Trixie) |
| **Ubuntu** | 22.04 LTS (Jammy), 24.04 LTS (Noble) |

> Distribusi lain berbasis Debian kemungkinan kompatibel, namun belum diuji secara resmi.

---

## ⚙️ Kebutuhan Sistem

- Bind9
- Curl
- Akses Internet
- Hak akses **root**

---

## 📝 Persyaratan Akses RPZ Komdigi (WAJIB)

Sebelum menggunakan skrip ini, **Anda wajib mendaftarkan server DNS Anda ke Komdigi**  
agar IP server di-*allow* untuk mengakses database RPZ.

### 🔗 Langkah Pendaftaran:
1. Buka tautan berikut:  
   👉 **http://bit.ly/FormKoneksiRPZ**
2. Isi seluruh form data dengan benar dan lengkap
3. Tunggu proses persetujuan dari Komdigi
4. Setelah IP dinyatakan *allow*, sinkronisasi RPZ dapat berjalan

⚠️ **Tanpa proses pendaftaran ini, server tidak akan dapat mengunduh data RPZ.**

---

## 🚀 Instalasi Cepat (One-Line Installer)

Jalankan perintah berikut di server DNS Anda:

```bash
sudo curl -sSl https://raw.githubusercontent.com/Iyankz/RPZ-Kominfo/main/bind9-rpz.sh | sudo bash
```

## 📌 Catatan:

* Skrip akan mengonfigurasi RPZ secara otomatis
* Sinkronisasi awal akan langsung dijalankan
* Cron job akan dibuat untuk update berkala

## 🔐 Konfigurasi Keamanan (PENTING)
Secara default, konfigurasi Bind9 mengizinkan query dari semua IP:
```
0.0.0.0/0
```

## ⚠️ Konfigurasi ini tidak disarankan untuk penggunaan produksi.

Rekomendasi:
Batasi akses DNS hanya ke jaringan internal atau subnet tertentu.

Langkah Konfigurasi:
```bash
sudo nano /etc/bind/named.conf.options
```
Sesuaikan parameter allow-query, lalu restart Bind9:
```bash
sudo systemctl restart bind9
```
## 📂 Struktur & Lokasi File
| Komponen                | Lokasi                               |
| ----------------------- | ------------------------------------ |
| Konfigurasi utama Bind9 | `/etc/bind/named.conf.options`       |
| Definisi zona RPZ       | `/etc/bind/named.conf.default-zones` |
| Skrip sinkronisasi      | `/usr/local/bin/sync-rpz.sh`         |
| Log aktivitas           | `/var/log/rpz-sync.log`              |

## 🚀 Cara Update Database (One-Line Command)

Jalankan perintah berikut di server DNS Anda:
```bash
sudo curl -sSl http://github.com/Iyankz/RPZ-Kominfo/blob/main/update.sh | sudo bash
```

## 📊 Monitoring & Verifikasi
### 🔍 Monitoring Log Sinkronisasi
```bash
tail -f /var/log/rpz-sync.log
```
## 📡 Verifikasi Status Zona RPZ
```bash
rndc showzone trustpositifkominfo
```
Jika zona terdaftar dan berstatus loaded, maka RPZ telah aktif.

## 🧪 Best Practice Produksi
* Gunakan internal DNS resolver
* Terapkan ACL pada Bind9
* Monitoring log secara berkala
* Backup konfigurasi sebelum update besar
* Gunakan server sekunder (slave) untuk redundansi

## 👨‍💻 Pengembang

Dikembangkan dan dipelihara oleh:

- **Iyankz**  
  🌐 https://iyankz.github.io


## ⚖️ Lisensi
Proyek ini dilisensikan di bawah MIT License.
Silakan lihat file LICENSE untuk detail lengkap.

## ⭐ Dukungan & Apresiasi
Jika proyek ini membantu pekerjaan Anda atau organisasi Anda:

## 👉 Berikan Star ⭐ pada repository ini
Dukungan Anda sangat berarti untuk pengembangan lanjutan.
