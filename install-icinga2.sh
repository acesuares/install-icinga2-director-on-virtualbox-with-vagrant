#!/bin/bash

# set some passwords
PW_MYSQL_ROOT=`pwgen -s 33 1`
PW_DIRECTOR_API=`pwgen -s 33 1`
PHP_TIMEZONE='America/Curacao'
PW_DIRECTOR_DATABASE=`pwgen -s 33 1`


# set mysql root password via debconf
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $PW_MYSQL_ROOT"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $PW_MYSQL_ROOT"

# install mysql-server (and mysql-client too) and software to use othere repos, and debconf-utils and curl
sudo apt-get -y install python-software-properties software-properties-common mysql-server debconf-utils php-curl curl

# install icinga2 repo
wget -O - http://packages.icinga.com/icinga.key | apt-key add -
sudo add-apt-repository 'deb http://packages.icinga.com/ubuntu icinga-xenial main'
sudo apt-get update

# set options for icinga2-ido-mysql (uses dbconfig)
# see http://askubuntu.com/questions/859568/non-interactive-setup-rsyslog-mysql/859655
sudo debconf-set-selections << 'END'
icinga2-ido-mysql	icinga2-ido-mysql/password-confirm	password	
# MySQL application password for icinga2-ido-mysql:
icinga2-ido-mysql	icinga2-ido-mysql/mysql/app-pass	password	
icinga2-ido-mysql	icinga2-ido-mysql/mysql/admin-pass	password	
icinga2-ido-mysql	icinga2-ido-mysql/app-password-confirm	password	
# Host running the MySQL server for icinga2-ido-mysql:
icinga2-ido-mysql	icinga2-ido-mysql/remote/newhost	string	
# Configure database for icinga2-ido-mysql with dbconfig-common?
icinga2-ido-mysql	icinga2-ido-mysql/dbconfig-install	boolean	true
# Delete the database for icinga2-ido-mysql?
icinga2-ido-mysql	icinga2-ido-mysql/purge	boolean	false
icinga2-ido-mysql	icinga2-ido-mysql/internal/skip-preseed	boolean	false
icinga2-ido-mysql	icinga2-ido-mysql/enable	boolean	true
icinga2-ido-mysql	icinga2-ido-mysql/missing-db-package-error	select	abort
# Back up the database for icinga2-ido-mysql before upgrading?
icinga2-ido-mysql	icinga2-ido-mysql/upgrade-backup	boolean	true
# Connection method for MySQL database of icinga2-ido-mysql:
icinga2-ido-mysql	icinga2-ido-mysql/mysql/method	select	Unix socket
icinga2-ido-mysql	icinga2-ido-mysql/mysql/admin-user	string	debian-sys-maint
icinga2-ido-mysql	icinga2-ido-mysql/install-error	select	abort
icinga2-ido-mysql	icinga2-ido-mysql/upgrade-error	select	abort
# Database type to be used by icinga2-ido-mysql:
icinga2-ido-mysql	icinga2-ido-mysql/database-type	select	mysql
# Reinstall database for icinga2-ido-mysql?
icinga2-ido-mysql	icinga2-ido-mysql/dbconfig-reinstall	boolean	false
icinga2-ido-mysql	icinga2-ido-mysql/passwords-do-not-match	error	
# MySQL database name for icinga2-ido-mysql:
icinga2-ido-mysql	icinga2-ido-mysql/db/dbname	string	icinga2
# MySQL username for icinga2-ido-mysql:
icinga2-ido-mysql	icinga2-ido-mysql/db/app-user	string	icinga2
icinga2-ido-mysql	icinga2-ido-mysql/remote/port	string	
# Perform upgrade on database for icinga2-ido-mysql with dbconfig-common?
icinga2-ido-mysql	icinga2-ido-mysql/dbconfig-upgrade	boolean	true
# Deconfigure database for icinga2-ido-mysql with dbconfig-common?
icinga2-ido-mysql	icinga2-ido-mysql/dbconfig-remove	boolean	true
icinga2-ido-mysql	icinga2-ido-mysql/remove-error	select	abort
# Host name of the MySQL database server for icinga2-ido-mysql:
icinga2-ido-mysql	icinga2-ido-mysql/remote/host	select	localhost
icinga2-ido-mysql	icinga2-ido-mysql/internal/reconfiguring	boolean	false
END

# now install icinga2, icinga2-ido-mysql and icingaweb2
sudo apt-get -y install icinga2 icinga2-ido-mysql icingaweb2

# make apache use ssl
sudo a2dissite 000-default
sudo a2ensite default-ssl
sudo a2enmod ssl

# set timezone
sudo sed -i "s_^;date.timezone =_date.timezone = '$PHP_TIMEZONE'_" /etc/php/7.0/apache2/php.ini

# set DoucmentRoot to icingaweb2 docroot
sudo sed -i "s_/var/www/html_/usr/share/icingaweb2/public_" /etc/apache2/sites-available/default-ssl.conf

# certs
sudo ln -ds /vagrant/etc/certs /etc/apache2/certs
sudo sed -i "s_/etc/ssl/certs/ssl-cert-snakeoil.pem_/etc/apache2/certs/YOURDOMAIN.crt_" /etc/apache2/sites-available/default-ssl.conf
sudo sed -i "s_/etc/ssl/private/ssl-cert-snakeoil.key_/etc/apache2/certs/YOURDOMAIN.key_" /etc/apache2/sites-available/default-ssl.conf
sudo sed -i "s_#SSLCertificateChainFile /etc/apache2/ssl.crt/server-ca.crt_SSLCertificateChainFile /etc/apache2/certs/YOURDOMAIN.inter_" /etc/apache2/sites-available/default-ssl.conf

sudo service apache2 restart

# set mysql password in conf file
sudo echo "
[client]
password = '$PW_MYSQL_ROOT'

" >> /etc/mysql/conf.d/mysql.cnf

# get icingaweb2-module-director
TMP_FILENAME="/tmp/`pwgen -s 33 1`.zip"
wget https://github.com/Icinga/icingaweb2-module-director/archive/master.zip -O "$TMP_FILENAME"
sudo unzip "$TMP_FILENAME" -d /usr/share/icingaweb2/modules > /dev/null
# rename to 'director'
sudo mv /usr/share/icingaweb2/modules/icingaweb2-module-director-master /usr/share/icingaweb2/modules/director

# enable api
sudo icinga2 api setup

# add api user for director
sudo echo "

object ApiUser \"director\" {
  password = \"$PW_DIRECTOR_API\"
  permissions = [ \"*\" ]
}

" >> /etc/icinga2/conf.d/api-users.conf

# add global zone for director
sudo echo "

object Zone \"director-global\" {
  global = true
}

" >> /etc/icinga2/zones.conf



# enable ido-mysql
sudo icinga2 feature enable ido-mysql

# create director database
mysql -e "CREATE DATABASE icinga2_director CHARACTER SET 'utf8';
   GRANT ALL ON icinga2_director.* TO icinga2_director@localhost IDENTIFIED BY '$PW_DIRECTOR_DATABASE';
   FLUSH PRIVILEGES;"
   
sudo service icinga2 restart

echo 'Please note token and passwords:'
sudo icingacli setup token create
echo "mysql root password = $PW_MYSQL_ROOT"
echo "API user: 'director' password: $PW_DIRECTOR_API"
echo "director database: 'icinga2_director' password: $PW_DIRECTOR_DATABASE"

echo 'Please also note the IDO database and password:'
sudo cat /etc/icinga2/features-available/ido-mysql.conf

