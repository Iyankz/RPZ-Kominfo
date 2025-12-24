# RPZ-Kominfo

Sync RPZ Kominfo

1. Lakukan pengisian form data pada link berikut http://bit.ly/FormKoneksiRPZ agar di allow kominfo.
2. Install Debian12 (BookWorm) / Ubuntu 22.04 (jammy Jellyfish)
3. Copy Paste Kode di bawah 
##
    sudo curl -Ssl https://raw.githubusercontent.com/Iyankz/RPZ-Kominfo/refs/heads/main/bind9-rpz.sh | sudo bash

4. Jika ingin merubah IP mana saja yang di Allow reqest DNS bisa edit file named.conf.optins pada bagian 0.0.0.0/0 (Secara Default Semua IP di allow)
##
    sudo nano /etc/bind/named.conf.options
##
    sudo systemctl restart bind9
