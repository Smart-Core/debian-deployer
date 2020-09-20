#!/bin/bash

NORMAL='\033[0m'     #  ${NORMAL}
RED='\033[0;31m'     #  ${RED}
GREEN='\033[0;32m'   #  ${GREEN}
YELLOW='\033[0;33m'  #  ${YELLOW}
DEBIAN_VERSION=$(cat /etc/debian_version | head -c 1)
RELEASE=$(lsb_release -cs)

tput sgr0

apt-get install apt-utils -y
apt-get install apt-transport-https dialog dirmngr apt-utils locales locales-all debian-archive-keyring sudo curl software-properties-common wget -y

dpkg-reconfigure locales
dpkg-reconfigure tzdata

apt-get upgrade -y

    echo -e "${YELLOW} Debian 10 'Buster' installing... ${NORMAL}"

    # Docker
    curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
    apt-key fingerprint 0EBFCD88
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian ${RELEASE} stable"

    # Ondrej Sury php
    wget --quiet -O - https://packages.sury.org/php/apt.gpg | apt-key add -
    printf "deb https://packages.sury.org/php/ ${RELEASE} main" > /etc/apt/sources.list.d/php7.3.list

    # Nginx
    wget --quiet -O - http://nginx.org/keys/nginx_signing.key | apt-key add -
    printf "deb http://nginx.org/packages/mainline/debian/ stretch nginx\ndeb-src http://nginx.org/packages/mainline/debian/ ${RELEASE} nginx" > /etc/apt/sources.list.d/nginx.list

    # Java
#    add-apt-repository ppa:webupd8team/java -y
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EA8CACC073C3DB2A
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C2518248EEA14886

    # PostgreSQL
    wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | apt-key add -
    echo "deb http://apt.postgresql.org/pub/repos/apt/ ${RELEASE}"-pgdg main > /etc/apt/sources.list.d/postgresql.list

    # Maria DB
#    apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xcbcb082a1bb943db
#    printf "deb http://mirror.mephi.ru/mariadb/repo/10.0/debian jessie main\ndeb-src http://mirror.mephi.ru/mariadb/repo/10.0/debian jessie main" > /etc/apt/sources.list.d/mariadb.list

    # Yarn
    curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# NodeJS
#  in this step apt-get update will executes automatically
wget -qO- https://deb.nodesource.com/setup_14.x | bash -

# Базовый софт
apt-get install net-tools gnupg gnupg2 ca-certificates -y
apt-get install colordiff mc htop gcc g++ make git curl rcconf p7zip-full zip dnsutils -y
apt-get install acl bash-completion fail2ban resolvconf ntp p7zip tree -y
apt-get install libedit-dev libevent-dev libcurl4-openssl-dev automake1.1 libncurses-dev libpcre3-dev pkg-config python-docutils -y
apt-get install libodbc1 fcgiwrap libgd-tools snmp yarn -y
apt-get install nodejs -y

#apt-get install libmyodbc python-software-properties monit -y
#apt-get install default-jdk imagemagick subversion mailutils uw-mailutils -y
#apt-get install oracle-java12-installer -y
#apt-get install elasticsearch -y
#apt-get install memcached -y

# Docker
apt-get install -y docker-ce docker-ce-cli containerd.io
curl -L "https://github.com/docker/compose/releases/download/1.27.3/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

apt-get install nginx mcrypt -y
chmod 0777 /var/log/nginx

# PHP 7.4
#apt install -y php7.4-mysql php7.4-geoip php7.4-imagick
apt install -y php7.4 php7.4-fpm php7.4-cli php7.4-dev php7.4-common php7.4-apcu php7.4-pgsql php7.4-sqlite3
apt install -y php7.4-gmp php7.4-gd php7.4-bcmath php7.4-curl php7.4-intl php7.4-mbstring php7.4-bz2 php7.4-xml php7.4-zip
apt install -y php7.4-snmp php7.4-xmlrpc php7.4-tidy php7.4-redis php7.4-imap php7.4-ssh2 php7.4-memcached

ln -s /etc/php/7.4/global.ini /etc/php/7.4/cli/conf.d/00-global.ini
ln -s /etc/php/7.4/global.ini /etc/php/7.4/fpm/conf.d/00-global.ini

ln -s /etc/php/7.4/php-cli.ini /etc/php/7.4/cli/conf.d/01-php-cli.ini
ln -s /etc/php/7.4/php-fpm.ini /etc/php/7.4/fpm/conf.d/01-php-fpm.ini

#/etc/init.d/php7.4-fpm restart
#update-rc.d php7.4-fpm defaults

#apt-get install php php-cli php-dev php-fpm php-pear php-gd php-intl php-curl php-gmp php-bz2 php-mbstring -y
#apt-get install php-snmp php-xmlrpc php-mysql php-pgsql php-tidy php-redis php-imap php-zip php-bcmath -y
#apt-get install php-apcu php-geoip php-imagick php-sqlite3 php-ssh2 php-memcached -y

mkdir /var/lib/php
mkdir /var/lib/php/sessions
chmod 0777 /var/lib/php/sessions

mkdir /var/log/php
chmod 0777 /var/log/php

# Configs
if [ ! -f ~/.bashrc_old ]
then
    mv ~/.bashrc ~/.bashrc_old
    cp -R common/etc / -v
    cp -R common/usr / -v
    cp -R common/root / -v
    cp -R "debian-$RELEASE/etc" / -v
fi

# Composer
curl -skS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer.phar
chmod 0755 /usr/local/bin/composer

wget http://get.sensiolabs.org/php-cs-fixer.phar -O /usr/local/bin/php-cs-fixer.phar
chmod 0777 /usr/local/bin/php-cs-fixer.phar

git clone https://github.com/KnpLabs/symfony2-autocomplete.git /usr/share/symfony2-autocomplete

apt-get purge apache* -y

apt-get clean
apt-get autoremove -y
mkdir /var/www
