#!/bin/bash

## https://ubuntuforums.org/showthread.php?t=1630044

echo 'Installing tinydns...'

sudo DEBIAN_FRONTEND='noninteractive' apt-get -y install djbdns

echo '  Creating tinydns accounts...'
sudo adduser --no-create-home --disabled-login --shell /bin/false dnslog
sudo adduser --no-create-home --disabled-login --shell /bin/false tinydns

echo '  Configuring tinydns...'
source /vagrant/conf.network
sudo tinydns-conf tinydns dnslog /etc/tinydns/ $GUEST_IP

sudo mkdir -p /etc/service 
cd /etc/service
sudo ln -sf /etc/tinydns/

sudo rm -vrf /etc/tinydns/root
sudo ln -s /vagrant/etc/tinydns/root /etc/tinydns/root
sudo ln -s /etc/service/tinydns/log/main /var/log/tinydns

echo ' Done.'
echo

