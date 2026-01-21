#!/bin/bash
# ============================================================
#  RPZ Kominfo Database Updater (AXFR / IXFR)
# ------------------------------------------------------------
#  File       : update.sh
#  Repository : https://github.com/Iyankz/RPZ-Kominfo
#  Author     : Iyankz
#  License    : MIT
# ------------------------------------------------------------
#  Fungsi:
#   - Update database RPZ Kominfo menggunakan AXFR
#   - Fallback / verifikasi menggunakan IXFR
#   - Reload Bind9 setelah update
# ============================================================

# ============================================================
# CONFIGURATION
# ============================================================
RPZ_ZONE="trustpositifkominfo"
RPZ_SERVER="103.154.123.130"
RPZ_DB="/etc/bind/db.${RPZ_ZONE}"
LOG_FILE="/var/log/rpz-update.log"

# ============================================================
# COLOR VARIABLES
# ============================================================
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# ============================================================
# LOG FUNCTION
# ============================================================
log() {
    echo "$(date '+%F %T') | $1" | tee -a "$LOG_FILE"
}

# ============================================================
# BASIC CHECK
# ============================================================
if [[ $EUID -ne 0 ]]; then
    echo -e "${RED}[ERROR] Jalankan script ini sebagai root${NC}"
    exit 1
fi

# ============================================================
# HEADER
# ============================================================
echo -e "${GREEN}====================================================${NC}"
echo -e "${GREEN}   UPDATE DATABASE DNS RPZ KOMINFO (AXFR / IXFR)   ${NC}"
echo -e "${GREEN}====================================================${NC}"

log "Memulai update database RPZ Kominfo"

# ============================================================
# AXFR UPDATE
# ============================================================
echo -e "\n${YELLOW}Menjalankan AXFR...${NC}"
log "Menjalankan AXFR dari server ${RPZ_SERVER}"

if dig AXFR @"$RPZ_SERVER" "$RPZ_ZONE" +noidnout > "$RPZ_DB"; then
    log "AXFR berhasil, database diperbarui"
else
    log "ERROR: AXFR gagal"
    exit 1
fi

# ============================================================
# IXFR VERIFICATION
# ============================================================
echo -e "\n${YELLOW}Menjalankan IXFR (verifikasi)...${NC}"
log "Menjalankan IXFR verifikasi"

dig IXFR=0 "$RPZ_ZONE" @"$RPZ_SERVER" +noidnout >> "$RPZ_DB"

# ============================================================
# PERMISSION & RELOAD
# ============================================================
chown bind:bind "$RPZ_DB"
chmod 644 "$RPZ_DB"

echo -e "\n${YELLOW}Reload Bind9...${NC}"
if rndc reload "$RPZ_ZONE"; then
    log "Bind9 reload sukses"
else
    log "WARNING: rndc reload gagal, mencoba restart"
    systemctl restart bind9
fi

# ============================================================
# FINISH
# ============================================================
log "Update database RPZ Kominfo selesai"

echo -e "\n${GREEN}====================================================${NC}"
echo -e "${GREEN}           *** UPDATE DATABASE SELESAI ***          ${NC}"
echo -e "${GREEN}====================================================${NC}"
