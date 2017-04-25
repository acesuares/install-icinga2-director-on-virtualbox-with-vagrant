# install-icinga2-director-on-virtualbox-with-vagrant
how-to-install-icinga2-director-on-virtualbox-with-vagrant

## CAUTION. This is experimental. For educational purposes only.
**Please know what you do and don't blame anyone else but yourself when stuff breaks!**

## Purpose
Installing Icinga2 Director proved to be quite a challenge. I tried to automate it as much as possible.

## Virtual Machine
The VM is a Virtualbox instance provisioned by Vagrant. So you need to install https://www.virtualbox.org/ and https://www.vagrantup.com/
Or, you can read trought the code and see what things need to be done to setup Icinga2 Director.

## Other Documentation
The docs I used as a starting point: https://github.com/Icinga/icingaweb2-module-director/blob/master/doc/02-Installation.md,
http://www.2daygeek.com/install-icinga2-network-monitoring-tool-on-ubuntu-debian-mint/ 

## Hetzner
There is special network configuation in this VM, that has to do with hosting at Hetzner.de. See http://wiki.hetzner.de/index.php/Netzkonfiguration_Debian/en
and http://wiki.hetzner.de/index.php/KVM_mit_Nutzung_aller_IPs_-_the_easy_way/en
However, you can just ignore that and configure your network as you see fit.

# Preparation I
Run the script `./00_install_plugins.sh` once before you run `vagrant up`. It installs two plugins that are useful.

# Preparation II
Make sure you modify the Vagrantfile accordingly. 1024 MB RAM is the minimum.
At the least supply a hostname. 
Also read the other 'install-*' scripts, and fill in the necessary values (email address and such). 
Please do edit the 'conf.network' file to suit your needs. The 'conf.software' file shouldn't need modification.

# vagrant up
The command `vagrant up` should give you a running VM with icinga2, icingaweb2, icinga2-ido-mysql and icinga2-director.

# passwords
During install, a `vagrant reload` will occur.
Just before that, the passwords are shown. 
There's about 20-30 lines after the reload, so scroll a bit back. You will see something like this:

```
==> default: Now restart your Icinga 2 daemon to finish the installation!
==> default: Enabling feature ido-mysql. Make sure to restart Icinga 2 for these changes to take effect.
==> default: Please note token and passwords:
==> default: The newly generated setup token is: 7c45f63648a9ab5e
==> default: mysql root password = iDsGs4KQvniBZjio83mwkRyd65fnmDMiZ
==> default: API user: 'director' password: ST4S1vCEdBYVye6sG0hS36JZkEhzWGjO4
==> default: director database: 'icinga2_director' password: xtTD0lg3tP42Jkr7YQzdSqpvPKpG0YcaT
==> default: Please also note the IDO database and password:
==> default: /**
==> default:  * The db_ido_mysql library implements IDO functionality
==> default:  * for MySQL.
==> default:  */
==> default: 
==> default: library "db_ido_mysql"
==> default: 
==> default: object IdoMysqlConnection "ido-mysql" {
==> default:   user = "icinga2",
==> default:   password = "WScxhK8PF7X7",
==> default:   host = "localhost",
==> default:   database = "icinga2"
==> default: }
==> default: Running provisioner: reload...
{ after this another 20 - 30 lines...}
```

Please see the screenshots for how to use them.

TODO: Add screenshots





