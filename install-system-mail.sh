#!/bin/bash

## https://ubuntuforums.org/showthread.php?t=1630044

echo 'Installing system mail, logcheck, and fail2ban...'

sudo DEBIAN_FRONTEND='noninteractive' apt-get -y install postfix fail2ban logcheck

echo '  Binding mail to 127.0.0.1 on IPv4 only...'
cat /etc/postfix/main.cf \
	| sed "s/inet_interfaces = all/inet_interfaces = 127.0.0.1/" \
	| sed "s/inet_protocols = all/inet_protocols = ipv4/" \
	> /tmp/main.cf.new
sudo cp /tmp/main.cf.new /etc/postfix/main.cf
sudo chown root.root /etc/postfix/main.cf

echo '  Adding YOU@EXAMPLE.COM to aliases...'
cp /etc/aliases /tmp
echo '
root: YOU@EXAMPLE.COM

' >> /tmp/aliases
sudo cp /tmp/aliases /etc/aliases
sudo chown root.root /etc/aliases
sudo newaliases
sudo service postfix restart

echo '  Configuring fail2ban...'

echo '
[Definition]
logtarget = SYSLOG
' > /tmp/fail2ban.local
sudo cp /tmp/fail2ban.local /etc/fail2ban
sudo chown root.root /etc/fail2ban/fail2ban.local

echo '
[DEFAULT]
bantime  = -1
maxretry = 2
findtime = 3600000
' > /tmp/jail.local
sudo cp /tmp/jail.local /etc/fail2ban
sudo chown root.root /etc/fail2ban/jail.local
sudo service fail2ban restart

echo ' Done.'
echo

