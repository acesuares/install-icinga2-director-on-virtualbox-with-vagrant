#!/bin/bash

echo 'Installing updates...'

echo '  Updating...'
sudo apt-get update

echo '  Upgrading...'
sudo DEBIAN_FRONTEND='noninteractive' apt-get -y dist-upgrade

echo '  Removing...'
sudo DEBIAN_FRONTEND='noninteractive' apt-get -y autoremove

echo '  Cleaning...'
sudo DEBIAN_FRONTEND='noninteractive' apt-get -y autoclean
 
echo '  Done.'
echo
