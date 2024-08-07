#!/bin/bash
[[ -e $(which curl) ]] && if [[ -z $(cat /etc/resolv.conf | grep "1.1.1.1") ]]; then cat <(echo "nameserver 1.1.1.1") /etc/resolv.conf > /etc/resolv.conf.tmp && mv /etc/resolv.conf.tmp /etc/resolv.conf; fi
#
#  |=================================================================================|
#  • Autoscript AIO Lite Menu By FN Project                                          |
#  • FN Project Developer @Rerechan02 | @PR_Aiman | @farell_aditya_ardian            |
#  • Copyright 2024 18 Marc Indonesia [ Kebumen ] | [ Johor ] | [ 上海，中国 ]       |
#  |=================================================================================|
#
# // Membersihkan layar
clear

# // Ini Adalah Auto Expired Untuk Noobzvpns

# Membaca Akun Yang Aktif
data=($(grep '^###' /etc/noobzvpns/.noob | awk '{print $2}' | sort | uniq))

# Tahun-Bulan-Tanggal hari ini
now=$(date +"%Y-%m-%d")

# Mendefinisikan Bahwa user = data
for user in "${data[@]}"; do
    # Membaca Masa Aktif Username
    exp=$(grep -w "^### $user" /etc/noobzvpns/.noob | awk '{print $3}' | sort | uniq) 
    
    # Menampilkan Masa Aktif Sesuai Username
    d1=$(date -d "$exp" +%s) 
    d2=$(date -d "$now" +%s) 
    
    # Menghitung selisih hari
    exp2=$(( (d1 - d2) / 86400 )) 
    
    # Jika masa aktif sudah habis
    if [[ "$exp2" -le "0" ]]; then
        # Menghapus pengguna dari file dan sistem
        sed -i "/^### $user $exp/,/^},{/d" /etc/noobzvpns/.noob
        noobzvpns --remove-user "$user"
        
        # Menyiapkan teks untuk notifikasi
        TEKS="
════════════════════════════
Username Expired
════════════════════════════

User: $user
Exp : $exp
════════════════════════════
"
        # Mengambil CHATID dan KEY dari file
        CHATID=$(cat /etc/noobzvpns/.chatid)
        KEY=$(cat /etc/noobzvpns/.keybot)
        TIME="10"
        URL="https://api.telegram.org/bot$KEY/sendMessage"

        # Mengirim notifikasi ke Telegram
        response=$(curl -s --max-time $TIME -d "chat_id=$CHATID&text=$TEKS" $URL)

        # Memeriksa apakah pengiriman berhasil
        if [[ $(echo "$response" | jq -r '.ok') == "true" ]]; then
            clear
            echo "$TEKS"
        else
            echo "Gagal mengirim notifikasi ke Telegram."
            echo "Response: $response"
        fi
    fi
done