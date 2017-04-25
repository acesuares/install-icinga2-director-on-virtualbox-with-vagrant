#!/bin/bash

echo 'Installing software...'

for i in `cat /vagrant/conf.software`
  do
    TO_INSTALL="$TO_INSTALL $i"
  done

sudo DEBIAN_FRONTEND='noninteractive' apt-get -y install $TO_INSTALL

echo '  Done.'
echo
