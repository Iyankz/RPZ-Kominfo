#!/bin/bash
# ============================================================
#  Auto Installer DNS RPZ Kominfo (Bind9)
# ------------------------------------------------------------
#  Repository : https://github.com/Iyankz/RPZ-Kominfo
#  Author     : Iyankz
#  License    : MIT
# ------------------------------------------------------------
#  Fungsi:
#   - Update sistem
#   - Install Bind9 & utilities
#   - Backup konfigurasi lama
#   - Download konfigurasi RPZ Kominfo
#   - Input IP Public (replace placeholder)
#   - Sinkronisasi AXFR / IXFR
#   - Restart & verifikasi layanan Bind9
# ============================================================

# ============================================================
# COLOR VARIABLES
# ============================================================
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# ============================================================
# HEADER
# ============================================================
echo -e "${GREEN}====================================================${NC}"
echo -e "${GREEN}   START INSTALL DNS RPZ SINKRON DATABASE KOMINFO   ${NC}"
echo -e "${GREEN}====================================================${NC}"

# ============================================================
# 1. UPDATE & UPGRADE SYSTEM
# ============================================================
echo -e "\n${YELLOW}[1/6] Memperbarui Repositori & Sistem...${NC}"
apt update && apt upgrade -y

# ============================================================
# 2. INSTALL BIND9
# ============================================================
echo -e "\n${YELLOW}[2/6] Menginstall Bind9 & Utilities...${NC}"
apt-get install bind9 bind9utils bind9-dnsutils bind9-doc bind9-host -y

# ============================================================
# 3. BACKUP EXISTING CONFIGURATION
# ============================================================
echo -e "\n${YELLOW}[3/6] Mencadangkan Konfigurasi Lama...${NC}"

[ -f /etc/bind/named.conf.default-zones ] && \
mv /etc/bind/named.conf.default-zones /etc/bind/named.conf.default-zones.bak

[ -f /etc/bind/named.conf.options ] && \
mv /etc/bind/named.conf.options /etc/bind/named.conf.options.bak

# ============================================================
# 4. DOWNLOAD NEW RPZ CONFIGURATION
# ============================================================
echo -e "\n${YELLOW}[4/6] Mengunduh Konfigurasi RPZ Kominfo...${NC}"

wget --no-check-certificate \
https://raw.githubusercontent.com/Iyankz/RPZ-Kominfo/refs/heads/main/named.conf.default-zones \
-P /etc/bind/

wget --no-check-certificate \
https://raw.githubusercontent.com/Iyankz/RPZ-Kominfo/refs/heads/main/named.conf.options \
-P /etc/bind/

# ============================================================
# INPUT IP PUBLIC (ALLOW AXFR)
# ============================================================
echo "----------------------------------------------------"
echo "Tambahkan IP Public"
echo "----------------------------------------------------"
read -p "Masukan Blok IP Anda: " ipaddress

echo "----------------------------------------------------"
echo "Update IP Public"
echo "----------------------------------------------------"
sed -i 's/123.456.789.0/'"$ipaddress"'/g' /etc/bind/named.conf.default-zones
sed -i 's/123.456.789.0/'"$ipaddress"'/g' /etc/bind/named.conf.default-options

echo "----------------------------------------------------"
echo "Restart bind9"
echo "----------------------------------------------------"
systemctl restart bind9

# ============================================================
# 5. DATABASE SYNCHRONIZATION (AXFR / IXFR)
# ============================================================
echo -e "\n${YELLOW}[5/6] Memulai Sinkronisasi AXFR / IXFR ke Server Kominfo...${NC}"

echo "----------------------------------------------------"
echo "AXFR Trust Positif Kominfo"
dig AXFR @103.154.123.130 trustpositifkominfo +noidnout

echo "----------------------------------------------------"
echo "IXFR Trust Positif Kominfo"
dig IXFR=0 trustpositifkominfo @103.154.123.130 +noidnout

# ============================================================
# 6. RESTART & VERIFY BIND9
# ============================================================
echo -e "\n${YELLOW}[6/6] Restarting Bind9 Service...${NC}"
systemctl restart bind9
systemctl status bind9 --no-pager | grep active

# ============================================================
# FINISH
# ============================================================
echo -e "\n${GREEN}====================================================${NC}"
echo -e "${GREEN}             *** INSTALLASI SELESAI ***              ${NC}"
echo -e "${GREEN}====================================================${NC}"
