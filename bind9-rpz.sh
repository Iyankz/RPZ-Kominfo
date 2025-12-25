#!/bin/bash

# --- Variabel Warna untuk Tampilan Lebih Rapi ---
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}====================================================${NC}"
echo -e "${GREEN}  START INSTALL DNS RPZ SINKRON DATABASE KOMINFO    ${NC}"
echo -e "${GREEN}====================================================${NC}"

# 1. Update & Upgrade
echo -e "\n${YELLOW}[1/6] Memperbarui Repositori & System...${NC}"
apt update && apt upgrade -y

# 2. Install Bind9
echo -e "\n${YELLOW}[2/6] Menginstall Bind9 & Utilities...${NC}"
apt-get install bind9 bind9utils bind9-dnsutils bind9-doc bind9-host -y

# 3. Backup Konfigurasi Lama
echo -e "\n${YELLOW}[3/6] Mencadangkan Konfigurasi (Backup)...${NC}"
# Menggunakan -f agar tidak error jika file tidak ada, dan cp untuk keamanan sebelum mv
[ -f /etc/bind/named.conf.default-zones ] && mv /etc/bind/named.conf.default-zones /etc/bind/named.conf.default-zones.bak
[ -f /etc/bind/named.conf.options ] && mv /etc/bind/named.conf.options /etc/bind/named.conf.options.bak

# 4. Download Konfigurasi Baru
echo -e "\n${YELLOW}[4/6] Mengunduh Konfigurasi RPZ Kominfo...${NC}"
wget --no-check-certificate https://raw.githubusercontent.com/Iyankz/RPZ-Kominfo/refs/heads/main/named.conf.default-zones -P /etc/bind/
wget --no-check-certificate https://raw.githubusercontent.com/Iyankz/RPZ-Kominfo/refs/heads/main/named.conf.options -P /etc/bind/

# 5. Sinkronisasi Database (Transfer Zone)
echo -e "\n${YELLOW}[5/6] Memulai Sinkronisasi AXFR/IXFR ke Server Kominfo...${NC}"

echo "----------------------------------------------------"
echo "AXFR Trust Positif Kominfo"
dig AXFR @103.154.123.130 trustpositifkominfo +noidnout

echo "----------------------------------------------------"
echo "IXFR Trust Positif Kominfo"
dig IXFR=0 trustpositifkominfo @103.154.123.130 +noidnout

# 6. Restart & Verifikasi
echo -e "\n${YELLOW}[6/6] Restarting Bind9 Service...${NC}"
systemctl restart bind9
systemctl status bind9 --no-pager | grep active

echo -e "\n${GREEN}====================================================${NC}"
echo -e "${GREEN}             *** INSTALLASI SELESAI *** ${NC}"
echo -e "${GREEN}====================================================${NC}"
