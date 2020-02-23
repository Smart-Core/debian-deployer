#!/bin/bash

NORMAL='\033[0m'     #  ${NORMAL}
RED='\033[0;31m'     #  ${RED}
GREEN='\033[0;32m'   #  ${GREEN}
YELLOW='\033[0;33m'  #  ${YELLOW}
DEBIAN_VERSION=$(cat /etc/debian_version | head -c 1)
RELEASE=$(lsb_release -cs)

tput sgr0

#read -p "Select PHP version (71/73), default is 73:" PHP_VERSION

PHP_VERSION="73"

#case $PHP_VERSION in
#    71) echo -e "${GREEN} Enable PHP v7.1 ${NORMAL}"
#        ;;
#    73) echo -e "${GREEN} Enable PHP v7.3 ${NORMAL}"
#        ;;
#    *)
#        echo -e "${YELLOW} Wrong PHP version selected, using v 7.3 by default${NORMAL}"
#        PHP_VERSION="73"
#        ;;
#esac

INSTALL_APACHE="0"

#read -p "Install Apache Web Server (N/y)" INSTALL_APACHE
#case $INSTALL_APACHE in
#    y|Y) echo -e "${GREEN} Enable Apache ${NORMAL}"
#         INSTALL_APACHE="1"
#         ;;
#    *)   echo -e "${YELLOW} Ignore Apache ${NORMAL}"
#         INSTALL_APACHE="0"
#         ;;
#esac

read -p "Install PostrgeSQL (N/y)" INSTALL_POSTRGESQL

case $INSTALL_POSTRGESQL in
    y|Y)echo -e "${GREEN} Enable PostrgeSQL ${NORMAL}"
        INSTALL_POSTRGESQL="1"
        ;;
    *)  echo -e "${YELLOW} Ignore PostrgeSQL ${NORMAL}"
        INSTALL_POSTRGESQL="0"
        ;;
esac


read -p "Install Ruby (N/y)" INSTALL_RUBY

case $INSTALL_RUBY in
    y|Y)echo -e "${GREEN} Enable Ruby ${NORMAL}"
        INSTALL_RUBY="1"
        ;;
    *)  echo -e "${YELLOW} Ignore Ruby ${NORMAL}"
        INSTALL_RUBY="0"
        ;;
esac


read -p "Install Docker (N/y)" INSTALL_DOCKER

case $INSTALL_DOCKER in
    y|Y)echo -e "${GREEN} Enable Docker ${NORMAL}"
        INSTALL_DOCKER="1"
        ;;
    *)  echo -e "${YELLOW} Ignore Docker ${NORMAL}"
        INSTALL_DOCKER="0"
        ;;
esac


read -p "Install RabbitMQ (N/y)" INSTALL_RABBITMQ

case $INSTALL_RABBITMQ in
    y|Y)echo -e "${GREEN} Enable RabbitMQ ${NORMAL}"
        INSTALL_RABBITMQ="1"
        ;;
    *)  echo -e "${YELLOW} Ignore RabbitMQ ${NORMAL}"
        INSTALL_RABBITMQ="0"
        ;;
esac


apt-get install apt-utils -y
apt-get install apt-transport-https dialog dirmngr apt-utils locales locales-all debian-archive-keyring sudo curl software-properties-common wget -y

dpkg-reconfigure locales
dpkg-reconfigure tzdata

apt-get upgrade -y

# @todo http://blog.programster.org/debian-8-install-php-7-1/
if (( $DEBIAN_VERSION == 9 ))
then
    echo -e "${YELLOW} Debian 9 'Stretch' installing... ${NORMAL}"

    # Ondrej Sury php 7.3
    wget --quiet -O - https://packages.sury.org/php/apt.gpg | apt-key add -
    printf "deb https://packages.sury.org/php/ stretch main" > /etc/apt/sources.list.d/php7.3.list

    # Dotdeb
    wget --quiet -O - http://www.dotdeb.org/dotdeb.gpg | apt-key add -
    printf "deb http://packages.dotdeb.org stretch all\ndeb-src http://packages.dotdeb.org stretch all\ndeb http://mirror.nl.leaseweb.net/dotdeb/ stretch all\ndeb-src http://mirror.nl.leaseweb.net/dotdeb/ stretch all" > /etc/apt/sources.list.d/dotdeb.list

    # Nginx
    wget --quiet -O - http://nginx.org/keys/nginx_signing.key | apt-key add -
    printf "deb http://nginx.org/packages/mainline/debian/ stretch nginx\ndeb-src http://nginx.org/packages/mainline/debian/ stretch nginx" > /etc/apt/sources.list.d/nginx.list

    # Java
#    add-apt-repository ppa:webupd8team/java -y
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EA8CACC073C3DB2A
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C2518248EEA14886

    # Varnish
    wget --quiet https://packagecloud.io/varnishcache/varnish5/gpgkey -O - | apt-key add -
    printf "deb https://packagecloud.io/varnishcache/varnish5/debian/ stretch main\ndeb-src https://packagecloud.io/varnishcache/varnish5/debian/ stretch main" > /etc/apt/sources.list.d/varnishcache5.list

    # PostgreSQL
    wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | apt-key add -
    echo "deb http://apt.postgresql.org/pub/repos/apt/ stretch-pgdg main" > /etc/apt/sources.list.d/postgresql.list

    # Maria DB
    apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xcbcb082a1bb943db
#    printf "deb http://mirror.mephi.ru/mariadb/repo/10.0/debian jessie main\ndeb-src http://mirror.mephi.ru/mariadb/repo/10.0/debian jessie main" > /etc/apt/sources.list.d/mariadb.list

    # MongoDB
    wget -q https://www.mongodb.org/static/pgp/server-4.0.asc -O - | apt-key add -
    echo "deb http://repo.mongodb.org/apt/debian stretch/mongodb-org/4.0 main" > /etc/apt/sources.list.d/mongodb.list

    # Subversion 1.12
#    wget -q http://opensource.wandisco.com/wandisco-debian.gpg -O- | apt-key add -
#    echo "deb http://staging.opensource.wandisco.com/debian stretch svn112" > /etc/apt/sources.list.d/subversion.list

elif (( $RELEASE == 'buster' ))
then
    echo -e "${YELLOW} Debian 10 'Buster' installing... ${NORMAL}"

    # Docker
    curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
    apt-key fingerprint 0EBFCD88
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian ${RELEASE} stable"

    # Ondrej Sury php 7.3
    wget --quiet -O - https://packages.sury.org/php/apt.gpg | apt-key add -
    printf "deb https://packages.sury.org/php/ ${RELEASE} main" > /etc/apt/sources.list.d/php7.3.list

    # Dotdeb
#    wget --quiet -O - http://www.dotdeb.org/dotdeb.gpg | apt-key add -
#    printf "deb http://packages.dotdeb.org ${RELEASE} all\ndeb-src http://packages.dotdeb.org ${RELEASE} all\ndeb http://mirror.nl.leaseweb.net/dotdeb/ ${RELEASE} all\ndeb-src http://mirror.nl.leaseweb.net/dotdeb/ ${RELEASE} all" > /etc/apt/sources.list.d/dotdeb.list

    # Nginx
    wget --quiet -O - http://nginx.org/keys/nginx_signing.key | apt-key add -
    printf "deb http://nginx.org/packages/mainline/debian/ stretch nginx\ndeb-src http://nginx.org/packages/mainline/debian/ ${RELEASE} nginx" > /etc/apt/sources.list.d/nginx.list

    # Java
#    add-apt-repository ppa:webupd8team/java -y
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EA8CACC073C3DB2A
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C2518248EEA14886

    # Varnish
#    wget --quiet https://packagecloud.io/varnishcache/varnish60lts/gpgkey -O - | apt-key add -
#    printf "deb https://packagecloud.io/varnishcache/varnish60lts/debian/ ${RELEASE} main\ndeb-src https://packagecloud.io/varnishcache/varnish60lts/debian/ ${RELEASE} main" > /etc/apt/sources.list.d/varnishcache5.list

    # PostgreSQL
    wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | apt-key add -
    echo "deb http://apt.postgresql.org/pub/repos/apt/ ${RELEASE}"-pgdg main > /etc/apt/sources.list.d/postgresql.list

    # Maria DB
#    apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xcbcb082a1bb943db
#    printf "deb http://mirror.mephi.ru/mariadb/repo/10.0/debian jessie main\ndeb-src http://mirror.mephi.ru/mariadb/repo/10.0/debian jessie main" > /etc/apt/sources.list.d/mariadb.list

    # MongoDB
    wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | apt-key add -
    echo "deb http://repo.mongodb.org/apt/debian buster/mongodb-org/4.2 main" | tee /etc/apt/sources.list.d/mongodb-org-4.2.list

    # Subversion 1.12
#    wget -q http://opensource.wandisco.com/wandisco-debian.gpg -O- | apt-key add -
#    echo "deb http://staging.opensource.wandisco.com/debian stretch svn112" > /etc/apt/sources.list.d/subversion.list

    # elasticsearch
    #wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -
    #echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" > /etc/apt/sources.list.d/elasticsearch.list

    # RabbitMQ
    wget -O - "https://packagecloud.io/rabbitmq/rabbitmq-server/gpgkey" | apt-key add -
    #apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 6B73A36E6026DFCA
    curl -fsSL https://github.com/rabbitmq/signing-keys/releases/download/2.0/rabbitmq-release-signing-key.asc | apt-key add -
    printf "deb https://dl.bintray.com/rabbitmq-erlang/debian ${RELEASE} erlang\ndeb https://dl.bintray.com/rabbitmq/debian ${RELEASE} main" > /etc/apt/sources.list.d/rabbitmq.list

    # Ruby Version Manager
    gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3

    # Yarn
    curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

else
    echo -e "${RED} BAD Debian version ${NORMAL}"
    exit
fi

# Apache Cassandra
#apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 749D6EEC0353B12C
#gpg --keyserver pgp.mit.edu --recv-keys F758CE318D77295D
#gpg --export --armor F758CE318D77295D | apt-key add -
#gpg --keyserver pgp.mit.edu --recv-keys 2B5C1B00
#gpg --export --armor 2B5C1B00 | apt-key add -
#printf "deb http://www.apache.org/dist/cassandra/debian 20x main\ndeb-src http://www.apache.org/dist/cassandra/debian 20x main" > /etc/apt/sources.list.d/cassandra.list

# NodeJS
#  in this step apt-get update will executes automatically
wget -qO- https://deb.nodesource.com/setup_13.x | bash -

# Базовый софт
apt-get install net-tools gnupg gnupg2 ca-certificates -y
#apt-get install libmyodbc python-software-properties monit -y
apt-get install colordiff mc htop gcc g++ make git curl rcconf p7zip-full zip dnsutils -y
apt-get install acl bash-completion fail2ban resolvconf subversion ntp imagemagick p7zip tree -y
apt-get install libedit-dev libevent-dev libcurl4-openssl-dev automake1.1 libncurses-dev libpcre3-dev pkg-config python-docutils -y
apt-get install libodbc1 fcgiwrap libgd-tools snmp mailutils yarn -y
apt-get install nodejs -y
#apt-get install default-jdk -y

#apt-get install oracle-java12-installer -y
#apt-get install elasticsearch -y

# БД
apt-get install redis-server -y

# @todo интерактивный выбор mysql
# https://andreyex.ru/operacionnaya-sistema-debian/kak-ustanovit-mariadb-na-debian-10/
apt-get install mariadb-server -y
mysql_secure_installation

#apt-get install mysql-server mysql-client -y
#apt-get install cassandra -y
#apt-get install mongodb-org php7.3-mongo -y
#apt-get install mongodb php5-mongo -y # устаревший

# PostgreSQL
if (( $INSTALL_POSTRGESQL == 1 ))
then
    apt-get install postgresql postgresql-contrib odbc-postgresql -y
    update-rc.d postgresql defaults
fi

# Docker
if (( $INSTALL_DOCKER == 1 ))
then
    apt-get install -y docker-ce docker-ce-cli containerd.io
    curl -L "https://github.com/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
fi

# Apache
if (( $INSTALL_APACHE == 1 ))
then
    apt-get install -y apache2 apache2-mpm-prefork libapache2-mod-rpaf

    rm /etc/apache2/sites-enabled/000-default
    rm /etc/apache2/sites-enabled/000-default.conf
    a2enmod rewrite
fi

apt-get install nginx memcached mcrypt uw-mailutils -y
chmod 0777 /var/log/nginx

# PHP 7.3
apt install -y php7.3 php7.3-fpm php7.3-cli php7.3-dev php7.3-common php7.3-apcu php7.3-mysql php7.3-pgsql php7.3-sqlite3
apt install -y php7.3-gmp php7.3-gd php7.3-bcmath php7.3-curl php7.3-intl php7.3-mbstring php7.3-bz2 php7.3-xml php7.3-zip
apt install -y php7.3-snmp php7.3-xmlrpc php7.3-tidy php7.3-redis php7.3-imap php7.3-geoip php7.3-imagick php7.3-ssh2 php7.3-memcached

# PHP 7.4
#apt install -y php7.4 php7.4-fpm php7.4-cli php7.4-dev php7.4-common php7.4-apcu php7.4-mysql php7.4-pgsql php7.4-sqlite3
#apt install -y php7.4-gmp php7.4-gd php7.4-bcmath php7.4-curl php7.4-intl php7.4-mbstring php7.4-bz2 php7.4-xml php7.4-zip
#apt install -y php7.4-snmp php7.4-xmlrpc php7.4-tidy php7.4-redis php7.4-imap php7.4-geoip php7.4-imagick php7.4-ssh2 php7.4-memcached

#apt-get install php php-cli php-dev php-fpm php-pear php-gd php-intl php-curl php-gmp php-bz2 php-mbstring -y
#apt-get install php-snmp php-xmlrpc php-mysql php-pgsql php-tidy php-redis php-imap php-zip php-bcmath -y
#apt-get install php-apcu php-geoip php-imagick php-sqlite3 php-ssh2 php-memcached -y

ln -s /etc/php/7.3/global.ini /etc/php/7.3/apache2/conf.d/00-global.ini
ln -s /etc/php/7.3/global.ini /etc/php/7.3/cli/conf.d/00-global.ini
ln -s /etc/php/7.3/global.ini /etc/php/7.3/fpm/conf.d/00-global.ini

ln -s /etc/php/7.3/php-apache.ini /etc/php/7.3/apache2/conf.d/01-php-apache.ini
ln -s /etc/php/7.3/php-cli.ini /etc/php/7.3/cli/conf.d/01-php-cli.ini
ln -s /etc/php/7.3/php-fpm.ini /etc/php/7.3/fpm/conf.d/01-php-fpm.ini

/etc/init.d/php7.3-fpm restart
update-rc.d php7.3-fpm defaults

mkdir /var/lib/php
mkdir /var/lib/php/sessions
chmod 0777 /var/lib/php/sessions

mkdir /var/log/php
chmod 0777 /var/log/php

# RabbitMQ
if (( $INSTALL_RABBITMQ == 1 ))
then
    apt install rabbitmq-server php7.3-amqp --fix-missing -y
    update-rc.d rabbitmq-server defaults
fi

# Configs
if [ ! -f ~/.bashrc_old ]
then
    mv ~/.bashrc ~/.bashrc_old
    cp -R common/etc / -v
    cp -R common/usr / -v
    cp -R common/root / -v
    cp -R "debian-$RELEASE/etc" / -v
    cp -v create-apache-vhost /usr/local/bin/create-apache-vhost
    cp -v create-nginx-vhost /usr/local/bin/create-nginx-vhost
    cp -v create-symfony-nginx-vhost /usr/local/bin/create-symfony-nginx-vhost
    cp -v create-symfony-old-nginx-vhost /usr/local/bin/create-symfony-old-nginx-vhost
    chmod 0755 /usr/local/bin/create-nginx-vhost
    chmod 0755 /usr/local/bin/create-symfony-nginx-vhost
    chmod 0755 /usr/local/bin/create-symfony-old-nginx-vhost
fi

# Cache
#apt-get install varnish -y

# Composer
curl -skS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer.phar
chmod 0755 /usr/local/bin/composer

wget http://get.sensiolabs.org/php-cs-fixer.phar -O /usr/local/bin/php-cs-fixer.phar
chmod 0777 /usr/local/bin/php-cs-fixer.phar

git clone https://github.com/KnpLabs/symfony2-autocomplete.git /usr/share/symfony2-autocomplete

# @todo pma и pga
# http://www.phpmyadmin.net/home_page/version.json
# wget http://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-all-languages.zip

apt-get install postfix -y
apt-get clean
/etc/init.d/mysql restart
/etc/init.d/nginx restart

if (( $INSTALL_APACHE == 1 ))
then
    #a2enmod php7.3
    #a2enmod proxy_fcgi setenvif
    #a2enconf php7.4-fpm

    /etc/init.d/apache2 restart
else
    /etc/init.d/apache2 stop
    apt-get purge apache* -y
fi

# Ruby
## https://www.digitalocean.com/community/tutorials/how-to-install-ruby-on-rails-on-an-debian-7-0-wheezy-vps-using-rvm
if (( $INSTALL_RUBY == 1 ))
then
    gpg2 --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
    curl -sSL https://rvm.io/mpapis.asc | gpg --import -
    curl -L https://get.rvm.io | bash -s stable --ruby
    source /etc/profile.d/rvm.sh
    source /usr/local/rvm/scripts/rvm
    #apt-get install -y ruby ruby-dev
    gem install capistrano
    gem install capistrano-composer
    gem install capistrano-maintenance
    gem install capistrano-symfony
    gem update
fi

apt-get clean
apt-get autoremove -y
mkdir /var/www
