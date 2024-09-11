Crontab_file="/usr/bin/crontab"
Green_font_prefix="\033[32m"
Red_font_prefix="\033[31m"
Green_background_prefix="\033[42;37m"
Red_background_prefix="\033[41;37m"
Font_color_suffix="\033[0m"
Info="[${Green_font_prefix}Informasi${Font_color_suffix}]"
Error="[${Red_font_prefix}Kesalahan${Font_color_suffix}]"
Tip="[${Green_font_prefix}Perhatian${Font_color_suffix}]"
disk_info=$(df -h | grep -E '^/dev/' | sort -k4 -h -r)
max_disk=$(echo "$disk_info" | head -n 1 | awk '{print $1}')
max_disk_path=$(echo "$disk_info" | head -n 1 | awk '{print $6}')
cd "$max_disk_path" || exit

cek_root() {
    [[ $EUID != 0 ]] && echo -e "${Error} Anda tidak menggunakan akun ROOT (atau tidak memiliki hak akses ROOT), tidak dapat melanjutkan operasi. Silakan ganti ke akun ROOT atau gunakan perintah ${Green_background_prefix}sudo su${Font_color_suffix} untuk mendapatkan hak akses ROOT sementara (mungkin akan diminta untuk memasukkan kata sandi akun saat ini)." && exit 1
}

instal_btc_full_node() {
    cek_root
    sudo apt update && sudo apt upgrade -y
    sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential git make ncdu unzip zip -y
    sudo ufw allow 8333

    echo "Path disk terbesar adalah: $max_disk_path"

    info_versi_terbaru=$(curl -s https://api.github.com/repos/bitcoin/bitcoin/releases/latest | grep "tag_name" | cut -d'"' -f4)
    versi_terbaru=${info_versi_terbaru#v}
    link_unduh="https://bitcoincore.org/bin/bitcoin-core-$versi_terbaru/bitcoin-$versi_terbaru-x86_64-linux-gnu.tar.gz"
    path_bitcoin_coin="$max_disk_path/bitcoin-core.tar.gz"
    
    wget -O $path_bitcoin_coin $link_unduh && \
    tar -xvf $path_bitcoin_coin && \
    direktori_bitcoin=$(tar -tf $path_bitcoin_coin | head -n 1 | cut -f1 -d'/') && \
    mv "$direktori_bitcoin" bitcoin-core && \
    chmod +x bitcoin-core

    echo "# Variabel lingkungan Bitcoin" >> ~/.bashrc
    echo "export BTCPATH=$max_disk_path/bitcoin-core/bin" >> ~/.bashrc
    echo 'export PATH=$BTCPATH:$PATH' >> ~/.bashrc

    mkdir $max_disk_path/btc-data

    file_konfigurasi="$max_disk_path/btc-data/bitcoin.conf"
    isi_konfigurasi=$(cat <<EOL
server=1
daemon=1
txindex=1
rpcuser=mybtc
rpcpassword=mybtc123
addnode=101.43.124.195:8333
addnode=27.152.157.149:8333
addnode=101.43.95.152:8333
addnode=222.186.20.60:8333
addnode=175.27.247.104:8333
addnode=110.40.210.253:8333
addnode=202.108.211.135:8333
addnode=180.108.105.174:8333
EOL
)
    # Cek apakah file konfigurasi sudah ada, jika belum buat baru
    if [ ! -f "$file_konfigurasi" ]; then
        echo "$isi_konfigurasi" > "$file_konfigurasi"
        echo "bitcoin.conf telah dibuat di $file_konfigurasi"
    else
        echo "bitcoin.conf sudah ada di $file_konfigurasi"
    fi

    source ~/.bashrc
}

jalankan_btc_full_node() {
    source ~/.bashrc
    bitcoin-cli -datadir=$max_disk_path/btc-data stop > /dev/null 2>&1
    bitcoind -datadir=$max_disk_path/btc-data -txindex
}

cek_tinggi_block_btc_full_node() {
    source ~/.bashrc
    bitcoin-cli -rpcuser=mybtc -rpcpassword=mybtc123 getblockchaininfo
}

cek_log_btc_full_node() {
    source ~/.bashrc
    tail -f $max_disk_path/btc-data/debug.log
}

echo && echo -e " ${Red_font_prefix}dusk_network Script Instalasi Satu Klik${Font_color_suffix} by \033[1;35mTimplexz\033[0m
Skrip ini sepenuhnya gratis dan open-source, ${Green_font_prefix}TIMPLEXZ${Font_color_suffix},
Silakan follow, jika ada yang mencoba meminta bayaran, itu penipuan.
 ———————————————————————
 ${Green_font_prefix} 1. Instal Lingkungan Full Node Bitcoin ${Font_color_suffix}
 ${Green_font_prefix} 2. Jalankan Full Node Bitcoin ${Font_color_suffix}
 ${Green_font_prefix} 3. Cek Tinggi Block Full Node Bitcoin ${Font_color_suffix}
 ${Green_font_prefix} 4. Cek Log Full Node Bitcoin ${Font_color_suffix}
 ———————————————————————" && echo
read -e -p " Masukkan nomor sesuai langkah di atas:" num
case "$num" in
1)
    instal_btc_full_node
    ;;
2)
    jalankan_btc_full_node
    ;;
3)
    cek_tinggi_block_btc_full_node
    ;;
4)
    cek_log_btc_full_node
    ;;
*)
    echo
    echo -e " ${Error} Masukkan angka yang benar"
    ;;
esac
