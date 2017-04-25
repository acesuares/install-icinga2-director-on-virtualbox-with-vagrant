#!/bin/bash
# do this before the network is provisoned!

DEFAULT_ACCOUNT=ubuntu

echo 'Installing secure accounts...'
  
echo '  Adding my key to authorized_keys...'
sudo mkdir -p /root/.ssh
sudo echo "ssh-rsa YOURPUBKEY YOU@DOMAIN" > /root/.ssh/authorized_keys
  
echo "  Locking password for root account and default account '$DEFAULT_ACCOUNT'"
sudo passwd -l $DEFAULT_ACCOUNT
sudo passwd -l root
 
echo '  Done!'
echo

