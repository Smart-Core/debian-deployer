Debian 9 and 10 Deployer
========================

Installation
------------

```
apt-get update
apt-get install git screen lsb-release -y
git clone https://github.com/Smart-Core/debian-deployer.git
cd debian-deployer
./install.sh
```

or in one line command

```
apt-get update && apt-get install git screen lsb-release -y && git clone https://github.com/Smart-Core/debian-deployer.git && cd debian-deployer && ./install.sh
```

Alternative via zip

```
apt-get update && apt-get upgrade
apt-get install zip screen lsb-release -y
wget https://github.com/Smart-Core/debian-deployer/archive/master.zip -O debian-deployer.zip
unzip debian-deployer.zip
cd debian-deployer-master
./install.sh
```

Default installed soft
----------------------

```
php7.3
php7.3-fpm
mariadb-server
postgresql
redis-server
nginx
nodejs
postfix
varnish
```

**Deactivated packages:**
```
cassandra
elasticsearch
mongodb-org
rabbitmq-server
```

Use screen
----------

List all screens

```
screen -ls
```

Connect to screen

```
screen -r <screen_name>
```

Detach current screen
```
Ctrl+a, d
```

Create virtual hosts
--------------------

```
create-symfony-nginx-vhost mysymfony-project.ru
create-nginx-vhost mysite.ru
create-apache-vhost mysite.ru
```

Linux Add a Swap File – Howto
-----------------------------

http://www.cyberciti.biz/faq/linux-add-a-swap-file-howto/


**Step #1: Create Storage File**

Type the following command to create 512MB swap file (1024 * 512MB = 524288 block size):
```
dd if=/dev/zero of=/swapfile1 bs=1024 count=524288
```

**Step #2: Secure swap file**

Setup correct file permission for security reasons, enter:
```
chown root:root /swapfile1
chmod 0600 /swapfile1
```

**Step #3: Set up a Linux swap area**

Type the following command to set up a Linux swap area in a file:
```
mkswap /swapfile1
```

**Step #4: Enabling the swap file**

Finally, activate /swapfile1 swap space immediately, enter:
```
swapon /swapfile1
```

**Step #5: Update /etc/fstab file**

To activate /swapfile1 after Linux system reboot, add entry to /etc/fstab file. Open this file using a text editor such as vi:
```
mcedit /etc/fstab
```
Append the following line:
```
/swapfile1 none swap sw 0 0
```

Quick install swap 512Mb:

```
dd if=/dev/zero of=/swapfile1 bs=1024 count=524288
chown root:root /swapfile1
chmod 0600 /swapfile1
mkswap /swapfile1
swapon /swapfile1
echo "/swapfile1 none swap sw 0 0" >> /etc/fstab
```

User managment
==============

```
useradd -m -G www-data,docker -s /bin/bash <username>
passwd <username>
```

```
usermod -aG www-data <username>
usermod -aG docker <username>
```

Простой скрипт для оценки производительности VPS
================================================

```
bash <(wget --no-check-certificate -O - https://raw.github.com/mgutz/vpsbench/master/vpsbench)
```

PHP-FPM Pools per Site
======================

https://gist.github.com/fyrebase/62262b1ff33a6aaf5a54

1. Copy `/etc/php/7.3/fpm/pool.d/www.conf` to `/etc/php/7.3/fpm/pool.d/my_site.conf`
2. Pool name. It is on the top [www]. Rename it to [mysite]
3. Next, change the user and group field and put the username and group to run it with.
```
user = mysite_user
group = mysite_user
```
4. Change the socket file name. Every pool should have its own separate socket. And the particular site should use this particular socket file to connect to fpm.
```
listen = /run/php/php7.3-fpm-mysite.sock
```
5. Now restart php-fpm
```
/etc/init.d/php7.3-fpm restart
```
6. Configure Nginx
```
fastcgi_pass unix:/var/run/php/php7.3-fpm-mysql.sock;
```
7. Now reload nginx
```
/etc/init.d/nginx reload
```

@todo
-----

 * Nginx/php-fpm umask setting (https://stackoverflow.com/questions/11584021/nginx-php-fpm-umask-setting)
 * Backup resolf.conf default config
 * Install latest phpmyadmin via http://www.phpmyadmin.net/home_page/version.json
 * IonCube Loader (https://www.digitalocean.com/community/tutorials/how-to-install-ioncube-loader)
 * Install via tar archive
 * HTTPS
 * PECL uploadprogress и/или apc.rfc1867 = 1
 * http://www.shellhacks.com/ru/Ustanovka-i-Nastroyka-Fail2ban-v-CentOS-Ubuntu
 * apache-autoconf.conf (https://github.com/helios-ag/symfony-website-config)
 * MUnin (http://habrahabr.ru/post/30494/)
 * https://developers.google.com/speed/pagespeed/module
 * https://eavictor.wordpress.com/2017/05/31/install-scout-realtime-auto-start/
