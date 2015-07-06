#!/bin/bash

if [ "$UID" -ne "0" ] #User check
then
   echo -e "Use this script as root."
   exit
else
pacman -Sy bind dnsutils
wget ftp://ftp.internic.net/domain/named.cache -O /var/named/root.hint #Root servers list
sed -i 's|file "/var/named/root.hint"|file "root.hint"|' /etc/named.conf
sudo chattr -i /etc/resolv.conf #Allow the modification of the file
sed -i 's|nameserver|#nameserver|' /etc/resolv.conf
echo "nameserver 127.0.0.1" >> /etc/resolv.conf #Set localhost as the DNS resolver
sudo chattr +i /etc/resolv.conf #Disallow the modification of the file
sudo systemctl start named && sudo systemctl enable named #Enable named at boot and start it
fi
