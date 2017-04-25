#!/bin/bash
source /vagrant/conf.network

echo 'Installing network...'
echo '  Creating /etc/network/interfaces...'
sudo cat > /etc/network/interfaces <<NETCONF
# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
# This is 10.0.2.15 by default for Virtualbox.
# It is assigned with DHCP but that also introduces new default routes.
# So it is  declared static here, with the IP of the host as gateway.
# You need to do one vagrant reload after the first vagrant up to activate this. A simple networking restart won't work.
auto eth0
iface eth0 inet static
  address 10.0.2.15
  netmask 255.255.255.0
  #gateway $HOST_IP

# this one is for the 'private' or 'hostonly' network.
auto eth1
iface eth1 inet static
  address $PRIVATE_IP
  netmask 255.255.255.0
            
# This your bridged interface. The nameserver is set too
auto eth2
iface eth2 inet static
  address $GUEST_IP
  netmask 255.255.255.255
  gateway $HOST_IP
  pointopoint $HOST_IP
  dns-nameservers $NAMESERVERS
  
NETCONF

echo '  Fixing Grub for weird network names...'
sudo echo '
GRUB_CMDLINE_LINUX="net.ifnames=0 biosdevname=0"
' >> /etc/default/grub  

echo '  Updating grub...'
sudo update-grub

echo '  Done.'
echo

