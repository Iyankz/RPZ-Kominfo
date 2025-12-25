# 🛡️ Auto-Sync DNS RPZ Komdigi (Bind9)

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![OS: Ubuntu](https://img.shields.io/badge/Recommended%20OS-Ubuntu%2022.04%20%7C%2024.04-orange.svg)](https://ubuntu.com/)
[![OS: Debian](https://img.shields.io/badge/Recommended%20OS-Debian%2012%20%7C%2013-red.svg)](https://www.debian.org/)

Skrip otomatis untuk mengintegrasikan database pemblokiran konten negatif (**Response Policy Zone**) dari Komdigi (dahulu Kominfo) ke dalam server DNS Bind9 secara otomatis dan *real-time*.

---

## 🖥️ Kompatibilitas Sistem Operasi
Skrip ini telah diuji secara intensif dan dioptimalkan untuk:

| Distribusi | Versi yang Didukung |
| :--- | :--- |
| **Debian** | 12 (Bookworm), 13 (Trixie) |
| **Ubuntu** | 22.04 LTS (Jammy), 24.04 LTS (Noble) |

---

## 🚀 Cara Penggunaan

Jalankan perintah berikut di terminal server Anda untuk memulai instalasi otomatis:

```bash
sudo curl -Ssl https://raw.githubusercontent.com/Iyankz/RPZ-Kominfo/refs/heads/main/bind9-rpz.sh | sudo bash
```

## 🛠️ Konfigurasi Keamanan (Penting)
Secara default, skrip ini mengonfigurasi Bind9 untuk menerima request dari semua IP (0.0.0.0/0). Untuk keamanan, sangat disarankan membatasi akses DNS hanya untuk jaringan internal Anda. Ganti bagian allow-query dan ganti 0.0.0.0/0 menjadi IP/jaringan spesifik Anda.:
Buka file konfigurasi:
```bash
sudo nano /etc/bind/named.conf.options
sudo systemctl restart bind9
```
## 📂 Struktur & Lokasi File
Konfigurasi Utama: /etc/bind/named.conf.options
Definisi Zona: /etc/bind/named.conf.default-zones
Skrip Sinkronisasi: /usr/local/bin/sync-rpz.sh
Log Aktivitas: /var/log/rpz-sync.log

## 📊 Monitoring & Verifikasi
Pantau proses sinkronisasi database RPZ melalui log:
```bash
tail -f /var/log/rpz-sync.log
```
Cek status transfer zona:
```bash
rndc showzone trustpositifkominfo
