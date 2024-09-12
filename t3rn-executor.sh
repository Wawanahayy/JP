#!/bin/bash

# Fungsi untuk menampilkan teks berwarna
print_colored() {
    local color_code=$1
    shift
    local message=$@
    echo -e "\033[${color_code}m${message}\033[0m"
}

log() {
    local level=$1
    local message=$2
    echo "[$level] $message"
}

# Menampilkan pesan dengan delay
echo "SABAR IKLAN"
sleep 5

print_colored "42;30" "========================================================="
print_colored "46;30" "========================================================="
print_colored "45;97" "======================   T3EN   ========================="
print_colored "43;30" "============== modify all by JAWA-PRIDE  ================"
print_colored "41;97" "=========== https://t.me/AirdropJP_JawaPride ============"
print_colored "44;30" "========================================================="
print_colored "42;97" "========================================================="

# Kelanjutan dari skrip
curl -s https://github.com/Wawanahayy/JP/blob/main/t3rn-executor.sh | bash
sleep 5

read -p "Masukkan Private Key Metamask: " PRIVATE_KEY_LOCAL

echo "T3rn Executor!"

remove_old_service() {
    echo "Menghentikan dan menghapus service lama jika ada..."
    sudo systemctl stop executor.service 2>/dev/null
    sudo systemctl disable executor.service 2>/dev/null
    sudo rm -f /etc/systemd/system/executor.service
    sudo systemctl daemon-reload
    echo "Service lama telah dihapus."
}

update_system() {
    echo "Memperbarui dan meng-upgrade sistem..."
    sudo apt update -q && sudo apt upgrade -qy
    if [ $? -ne 0 ]; then
        echo "Update sistem gagal. Keluar."
        exit 1
    fi
}

download_and_extract_binary() {
    LATEST_VERSION=$(curl -s https://api.github.com/repos/t3rn/executor-release/releases/latest | grep 'tag_name' | cut -d\" -f4)
    EXECUTOR_URL="https://github.com/t3rn/executor-release/releases/download/${LATEST_VERSION}/executor-linux-${LATEST_VERSION}.tar.gz"
    EXECUTOR_FILE="executor-linux-${LATEST_VERSION}.tar.gz"

    echo "Versi terbaru terdeteksi: $LATEST_VERSION"
    echo "Mengunduh binary Executor dari $EXECUTOR_URL..."
    curl -L -o $EXECUTOR_FILE $EXECUTOR_URL

    if [ $? -ne 0 ]; then
        echo "Gagal mengunduh binary Executor. Periksa koneksi internet Anda dan coba lagi."
        exit 1
    fi

    echo "Mengekstrak binary..."
    tar -xzvf $EXECUTOR_FILE
    if [ $? -ne 0 ]; then
        echo "Ekstraksi gagal. Keluar."
        exit 1
    fi

    rm -rf $EXECUTOR_FILE
    cd executor/executor/bin || exit
    echo "Binary berhasil diunduh dan diekstrak."
}

set_environment_variables() {
    export NODE_ENV=testnet
    export LOG_LEVEL=info
    export LOG_PRETTY=false
    echo "Variabel lingkungan disetel: NODE_ENV=$NODE_ENV, LOG_LEVEL=$LOG_LEVEL, LOG_PRETTY=$LOG_PRETTY"
}

set_private_key() {
    while true; do
        read -p "Masukkan Private Key Metamask Anda (tanpa prefix 0x): " PRIVATE_KEY_LOCAL
        PRIVATE_KEY_LOCAL=${PRIVATE_KEY_LOCAL#0x}

        if [ ${#PRIVATE_KEY_LOCAL} -eq 64 ]; then
            export PRIVATE_KEY_LOCAL
            echo "Private key telah disetel."
            break
        else
            echo "Private key tidak valid. Harus 64 karakter panjangnya (tanpa prefix 0x)."
        fi
    done
}

set_enabled_networks() {
    read -p "Apakah Anda ingin mengaktifkan 5 jaringan default (arbitrum-sepolia, base-sepolia, blast-sepolia, optimism-sepolia, l1rn)? (y/n): " aktifkan_lima

    if [[ "$aktifkan_lima" == "y" || "$aktifkan_lima" == "Y" ]]; then
        ENABLED_NETWORKS="arbitrum-sepolia,base-sepolia,blast-sepolia,optimism-sepolia,l1rn"
        echo "Mengaktifkan 5 jaringan default: $ENABLED_NETWORKS"
    else
        echo "Anda tidak memilih untuk mengaktifkan 5 jaringan default."
        exit 0
    fi

    # Menambahkan jaringan tambahan jika diinginkan
    read -p "Apakah Anda ingin menambahkan jaringan tambahan? (y/n): " tambah_jaringan

    if [[ "$tambah_jaringan" == "y" || "$tambah_jaringan" == "Y" ]]; then
        while true; do
            echo "Pilih jaringan tambahan yang ingin ditambahkan:"
            echo "1. arbitrum-sepolia"
            echo "2. base-sepolia"
            echo "3. blast-sepolia"
            echo "4. optimism-sepolia"
            echo "5. l1rn"
            echo "6. Selesai menambahkan jaringan"

            read -p "Masukkan angka untuk memilih jaringan tambahan (contoh: 1): " pilihan_tambahan

            case $pilihan_tambahan in
                1)
                    if [[ "$ENABLED_NETWORKS" != *"arbitrum-sepolia"* ]]; then
                        ENABLED_NETWORKS+=",arbitrum-sepolia"
                    else
                        echo "arbitrum-sepolia sudah diaktifkan."
                    fi
                    ;;
                2)
                    if [[ "$ENABLED_NETWORKS" != *"base-sepolia"* ]]; then
                        ENABLED_NETWORKS+=",base-sepolia"
                    else
                        echo "base-sepolia sudah diaktifkan."
                    fi
                    ;;
                3)
                    if [[ "$ENABLED_NETWORKS" != *"blast-sepolia"* ]]; then
                        ENABLED_NETWORKS+=",blast-sepolia"
                    else
                        echo "blast-sepolia sudah diaktifkan."
                    fi
                    ;;
                4)
                    if [[ "$ENABLED_NETWORKS" != *"optimism-sepolia"* ]]; then
                        ENABLED_NETWORKS+=",optimism-sepolia"
                    else
                        echo "optimism-sepolia sudah diaktifkan."
                    fi
                    ;;
                5)
                    if [[ "$ENABLED_NETWORKS" != *"l1rn"* ]]; then
                        ENABLED_NETWORKS+=",l1rn"
                    else
                        echo "l1rn sudah diaktifkan."
                    fi
                    ;;
                6)
                    echo "Selesai menambahkan jaringan."
                    break
                    ;;
                *)
                    echo "Pilihan tidak valid: $pilihan_tambahan"
                    ;;
            esac
        done
    else
        echo "Tidak ada jaringan tambahan yang ditambahkan."
    fi

    echo "Pengaturan selesai. Jaringan yang diaktifkan: $ENABLED_NETWORKS"
}

create_systemd_service() {
    SERVICE_FILE="/etc/systemd/system/executor.service"
    sudo bash -c "cat > $SERVICE_FILE" <<EOL
[Unit]
Description=Executor Service
After=network.target

[Service]
User=root
WorkingDirectory=/root/executor/executor
Environment="NODE_ENV=testnet"
Environment="LOG_LEVEL=info"
Environment="LOG_PRETTY=false"
Environment="PRIVATE_KEY_LOCAL=0x$PRIVATE_KEY_LOCAL"
Environment="ENABLED_NETWORKS=$ENABLED_NETWORKS"
ExecStart=/root/executor/executor/bin/executor
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
EOL
}

start_service() {
    sudo systemctl daemon-reload
    sudo systemctl enable executor.service
    sudo systemctl start executor.service
    echo "Setup selesai! Service Executor telah dibuat dan dijalankan."
    echo "Anda dapat memeriksa status service menggunakan: sudo systemctl status executor.service"
}

display_log() {
    echo "Menampilkan log dari service executor:"
    sudo journalctl -u executor.service -f
}

# Eksekusi fungsi-fungsi
remove_old_service
update_system
download_and_extract_binary
set_environment_variables
set_private_key
set_enabled_networks
create_systemd_service
start_service
display_log
