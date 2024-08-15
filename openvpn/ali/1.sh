#!/bin/bash
[[ -e $(which curl) ]] && if [[ -z $(cat /etc/resolv.conf | grep "1.1.1.1") ]]; then cat <(echo "nameserver 1.1.1.1") /etc/resolv.conf > /etc/resolv.conf.tmp && mv /etc/resolv.conf.tmp /etc/resolv.conf; fi
#
#  |=================================================================================|
#  • Autoscript AIO Lite Menu By FN Project                                          |
#  • FN Project Developer @Rerechan02 | @PR_Aiman | @farell_aditya_ardian            |
#  • Copyright 2024 18 Marc Indonesia [ Kebumen ] | [ Johor ] | [ 上海，中国 ]       |
#  |=================================================================================|
#

pmenu() {
clear
echo -e "\e[33m===================================\033[0m"
echo -e "Domain anda saat ini:"
echo -e "$(cat /etc/noobzvpns/domain)"
echo ""
read -rp "Domain/Host: " -e host
echo ""
if [ -z $host ]; then
echo "DONE CHANGE DOMAIN"
echo -e "\e[33m===================================\033[0m"
read -n 1 -s -r -p "Press any key to back on menu"
menu
else
echo "$host" > /etc/noobzvpns/domain
echo -e "\e[33m===================================\033[0m"
echo -e ""
fi
}

tmenu() {
clear

add() {
clear
echo -e "
===================
[ 设置机7器人通知 ]
===================
"
read -p "API Key Bot: " api
read -p "Your Chat ID: " itd
clear
echo -e "
Information
==============================
API Bot: $api
Chatid : $itd
==============================
"
read -p "Is the data above correct? (y/n): " opw
case $opw in
y) clear ; lanjut ;;
n) clear ; add ;;
*) clear ; add ;;
esac
}

lanjut() {
rm -fr /etc/noobzvpns/.chatid
rm -fr /etc/noobzvpns/.keybot
systemctl restart cron
echo "$api" > /etc/noobzvpns/.keybot
echo "$itd" > /etc/noobzvpns/.chatid
clear
echo -e "
Your Data Bot Notirication
===========================
API Bot: $api
Chatid Own: $itd
===========================
"
}

rpot() {
echo "
Report Bug To
=====================
Telegram:

- @Rerechan02
- @farell_aditya_ardian
- @PR_Aiman
=====================
Email:

- widyabakti02@gmail.com
=====================

Thanks For Use My Script
"
}

mna() {
echo -e "
======================
[   菜单设置机器人   ]
======================

1. Setup Bot Notification
2. Setup Bot Panel All Menu
3. Report Bug On Script
======================
Press CTRL + C to exit
"
read -p "Input Option: " apws
case $apws in
1) clear ; add ;;
2) clear ; echo "Coming Soon" ;;
3) clear ; rpot ;;
*) clear ; mna ;;
esac
}

mna
}

rest() {
clear
echo "This Feature Can Only Be Used According To Vps Data With This Autoscript"
echo "Please input link to your vps data backup file."
read -rp "Link File: " -e url
cd /root
wget -O backup.zip "$url"
unzip backup.zip
rm -f backup.zip
sleep 1
echo "Tengah Melakukan Backup Data"
cd /root/backup
cp -r noobzvpns /etc/
clear
cd
rm -rf /root/backup
rm -f backup.zip
systemctl restart noobzvpns
clear
echo "Telah Berjaya Melakukan Backup"
}

restf() {
cd /root
file="backup.zip"
if [ -f "$file" ]; then
echo "$file ditemukan, melanjutkan proses..."
sleep 2
clear
unzip backup.zip
rm -f backup.zip
sleep 1
echo "Tengah Melakukan Backup Data"
cd /root/backup
cp -r noobzvpns /etc/
clear
cd
rm -rf /root/backup
rm -f backup.zip
systemctl restart noobzvpns
clear
cd
rm -rf /root/backup
rm -f backup.zip
clear
echo "Telah Berjaya Melakukan Backup"
else
    echo "Error: File $file Not Found"
fi
}

clear

bmenu() {
clear
echo "
============================
Menu Backup Data VPN in VpS
============================

1. Backup Your Data VPS
2. Restore With Link Backup
3. Restore With SFTP / Termius
4. Bot Notification Setup on Server
==============================
Press CTRL + C / X to Exit Menu
"
read -p "Input Valid Number Option: " mla
case $mla in
1) clear ; backup ;;
2) clear ; rest ;;
3) clear ; restf ;;
4) botmenu ;;
x) exit ;;
*) echo " Please Input Valid Number " ; bmenu ;;
esac
}

addn() {
domain=$(cat /etc/xray/domain)
clear
echo -e "
════════════════════════════
Add Account NoobzVPN
════════════════════════════"
read -p "Username  : " user
read -p "Password  : " pass
read -p "Masa Aktif: " masaaktif
clear
noobzvpns --add-user "$user" "$pass"
noobzvpns --expired-user "$username" "$masaaktif"
expi=`date -d "$masaaktif days" +"%Y-%m-%d"`
echo "### ${user} ${expi}" >>/etc/noobzvpns/.noob
clear
TEKS="
════════════════════════════
NoobzVPN Account
════════════════════════════
Hostname  : $domain
Username  : $user
Password  : $pass
════════════════════════════
TCP_STD/HTTP  : 8080
TCP_SSL/HTTPS : 8443
════════════════════════════
PAYLOAD   : GET / HTTP/1.1[crlf]Host: [host][crlf]Upgrade: websocket[crlf][crlf]
════════════════════════════
Expired   : $expi
════════════════════════════"
CHATID=$(grep -E "^#bot# " "/etc/bot/.bot.db" | cut -d ' ' -f 3)
KEY=$(grep -E "^#bot# " "/etc/bot/.bot.db" | cut -d ' ' -f 2)
TIME="10"
URL="https://api.telegram.org/bot$KEY/sendMessage"
curl -s --max-time $TIME -d "chat_id=$CHATID&text=$TEKS" $URL
clear
echo "$TEKS"
}

deln() {
mna=$(grep -e "^### " "/etc/noobzvpns/.noob" | cut -d ' ' -f 2-3 | column -t | sort | uniq)
clear
echo -e "
════════════════════════════
Delete Account
════════════════════════════
$mna
════════════════════════════
"
read -p "Input Name: " name
if [ -z $name ]; then
menu
else
exp=$(grep -we "^### $user" "/etc/noobzvpns/.noob" | cut -d ' ' -f 3 | sort | uniq)
sed -i "/^### $user $exp/,/^},{/d" /etc/noobzvpns/.noob
noobzvpns --remove-user "$name"
clear
TEKS="
════════════════════════════
Username Delete
════════════════════════════

User: $name
Exp : $exp
════════════════════════════
"
CHATID=$(grep -E "^#bot# " "/etc/bot/.bot.db" | cut -d ' ' -f 3)
KEY=$(grep -E "^#bot# " "/etc/bot/.bot.db" | cut -d ' ' -f 2)
TIME="10"
URL="https://api.telegram.org/bot$KEY/sendMessage"
curl -s --max-time $TIME -d "chat_id=$CHATID&text=$TEKS" $URL
clear
echo "$TEKS"
fi
}

list() {
clear
noobzvpns --info-all-user
}

tampilan() {
white='\e[037;1m'
RED='\e[31m'
GREEN='\e[32m'
NC='\033[0;37m'
domain=$(cat /etc/xray/domain)
clear
if [[ $(systemctl status noobzvpns | grep -w Active | awk '{print $2}' | sed 's/(//g' | sed 's/)//g' | sed 's/ //g') == 'active' ]]; then
    status="${GREEN}ON${NC}";
else
    status="${RED}OFF${NC}";
fi
clear
echo -e "════════════════════════════════" | lolcat
echo -e "${GREEN}[ ${RED}<== ${white}NOOBZVPN STORE『EA』 ${RED}==> ${GREEN}]"
echo "════════════════════════════════" | lolcat
echo -e "Noobz: $status
${white}
Domain: $domain

1. Add Account
2. Delete Account
3. List Active Account
4. Backup & Restore
5. Bot Notif Telegram
6. Change Domain / Ganti Host"
echo "════════════════════════════════" | lolcat
echo "Preess CTRL or X to exit"
echo "════════════════════════════════" | lolcat
read -p "Input Option: " inrere
case $inrere in
1|01) clear ; addn ;;
2|02) clear ; deln ;;
3|03) clear ; list ;;
4|04) clear ; bmenu ;;
5|05) clear ; tmenu ;;
6|06) clear ; pmenu ;;
x|X) exit ;;
*) echo "Wrong Number " ; tampilan ;;
esac
}
tampilan
