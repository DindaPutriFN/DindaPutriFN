#!/bin/bash
[[ -e $(which curl) ]] && if [[ -z $(cat /etc/resolv.conf | grep "1.1.1.1") ]]; then cat <(echo "nameserver 1.1.1.1") /etc/resolv.conf > /etc/resolv.conf.tmp && mv /etc/resolv.conf.tmp /etc/resolv.conf; fi
#
#  |=================================================================================|
#  • Autoscript AIO Lite Menu By FN Project                                          |
#  • FN Project Developer @Rerechan02 | @PR_Aiman | @farell_aditya_ardian            |
#  • Copyright 2024 18 Marc Indonesia [ Kebumen ] | [ Johor ] | [ 上海，中国 ]       |
#  |=================================================================================|
#
date=$(date)
domain=$(cat /etc/noobzvpns/domain)
cpt="$(date) / $domain"
clear
echo "Mohon Menunggu, Proses Backup sedang berlangsung!!"
rm -rf /root/backup
rm -rf /root/*
mkdir -p /root/backup
cp -r /etc/noobzvpns /root/backup/noobzvpns
cd /root
zip -r backup.zip backup > /dev/null 2>&1
clear
random_number=$(gpg --gen-random 2 90 | tr -dc A-Za-z0-9 | sed 's/\(..\)/\1:/g; s/.$//')
file_path="/root/backup.zip"
api_url="https://file.io"
expiry_duration=$((14 * 24 * 60 * 60))
response=$(curl -s -F "file=@$file_path" -F "expiry=$expiry_duration" $api_url)
upload_link=$(echo $response | jq -r .link)
#telegram-send --file backup.zip --caption "${date}"
MYIP=$(curl -s ifconfig.me)
clear
TEKS="
[ Information Your Backup Data ]
================================

Your ID    : $random_number
Your IP    : $MYIP
Link Backup: $upload_link
================================
Your File Backup AutoDelete After 7 Days
"
CHATID=$(cat /etc/noobzvpns/.chatid)
KEY=$(cat /etc/noobzvpns/.keybot)
TIME="10"
URL1="https://api.telegram.org/bot$KEY/sendMessage"
curl -s --max-time $TIME -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEKS&parse_mode=html" $URL1 >/dev/null
URL2="https://api.telegram.org/bot$KEY/sendDocument"
CAPTION="${cpt}"
curl -s --max-time $TIME -F chat_id=$CHATID -F document=@backup.zip -F caption="$CAPTION" $URL2 >/dev/null
clear
echo "$TEKS"
echo "Please Save your Link Backup"
rm -fr /root/backup*
