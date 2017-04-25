#!/bin/bash
# do this before the network is provisoned!

DEFAULT_ACCOUNT=ubuntu

echo 'Installing secure accounts...'
  
echo '  Adding my key to authorized_keys...'
sudo mkdir -p /root/.ssh
sudo echo "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAre5+w3MYV+MXNi+osOHqjMYZeUWf577Z0jQdUIX/qi8/+GFuw262hZaTyhpnTpzjGLKluCXYQZ38giXfgFXHdufFq0L+wEbEdo+71Z0BJCSssMKc18/OSsWoXAZYEnHRBu5OfletyRGqzGDYDHbwZI+MIiSZRfNRHp+JsNn3KcjpfNndZJZjjMkgmSacm4Yugvuv1EpfZX//XNaM5xKHVxRilUlqCxUt8Y5ao67epnJegji85PT6/bHgqpfjOazol1QhFKE0A95JchdGtSNwEDU8YbT3zHb+7ufag7wbS7bx4ZEA/YiZsYnfgojuxU1sDGnk+gtC73btFtAmbZzYUQ== ace@sheerluck" > /root/.ssh/authorized_keys
sudo echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDNHNhPy5BIjtEqrU7n37C7S5TSt6sqnkLCBFv36fKxSnngzJkJK1UpfJlsBjKa2cDleUDitqEOyHbr5sp259OT3wFWbtKVqfhRpI8tmm4+sVWwaXjyWIN2GIE37owMEb+5wJfPnU/MY4PDs0JwbniInaSqUVsuqt0CSkPeE0E7O1OGXH5yl7dv72fpf8BzVFZl5n6tpttYbYN4oUxLjl8+WDiGbfJbYeFxqBI4d1wq/kT7lzoxsjRTGhKc0dKz2lmXWcZ1hQXyVJ4PW4Qj5yp/xFN5O8Wv3XYlOcmKkHg7y7+FpgzuEWEXeQ4tU/Mm5WHlR0Keow24jqHmLzLrnYdL root@apt7" >> /root/.ssh/authorized_keys
  
echo "  Locking password for root account and default account '$DEFAULT_ACCOUNT'"
sudo passwd -l $DEFAULT_ACCOUNT
sudo passwd -l root
 
echo '  Done!'
echo

