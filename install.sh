#!/bin/bash

NORMAL='\033[0m'     #  ${NORMAL}
RED='\033[0;31m'     #  ${RED}
GREEN='\033[0;32m'   #  ${GREEN}
YELLOW='\033[0;33m'  #  ${YELLOW}
DEBIAN_VERSION=$(cat /etc/debian_version | head -c 1)

tput sgr0

read -p "Select PHP version (71/73), default is 73:" PHP_VERSION

case $PHP_VERSION in
    71) echo -e "${GREEN} Enable PHP v7.1 ${NORMAL}"
       ;;
    73) echo -e "${GREEN} Enable PHP v7.3 ${NORMAL}"
       ;;
    *)
       echo -e "${YELLOW} Wrong PHP version selected, using v 7.3 by default${NORMAL}"
       PHP_VERSION="73"
       ;;
esac

read -p "Install Apache Web Server (N/y)" INSTALL_APACHE

case $INSTALL_APACHE in
    y|Y)echo -e "${GREEN} Enable Apache ${NORMAL}"
        INSTALL_APACHE="1"
        ;;
    *)  echo -e "${YELLOW} Ignore Apache ${NORMAL}"
        INSTALL_APACHE="0"
        ;;
esac

read -p "Install PostrgeSQL (N/y)" INSTALL_POSTRGESQL

case $INSTALL_POSTRGESQL in
    y|Y)echo -e "${GREEN} Enable PostrgeSQL ${NORMAL}"
        INSTALL_POSTRGESQL="1"
        ;;
    *)  echo -e "${YELLOW} Ignore PostrgeSQL ${NORMAL}"
        INSTALL_POSTRGESQL="0"
        ;;
esac

apt-get install apt-utils -y
apt-get install apt-transport-https dialog dirmngr apt-utils locales locales-all debian-archive-keyring -y

dpkg-reconfigure locales
dpkg-reconfigure tzdata

apt-get upgrade -y

# @todo http://blog.programster.org/debian-8-install-php-7-1/
if (( $DEBIAN_VERSION == 7 ))
then
    echo "Wheezy installing..."

    # Dotdeb
    wget --quiet -O - http://www.dotdeb.org/dotdeb.gpg | apt-key add -
    printf "deb http://packages.dotdeb.org wheezy all\ndeb-src http://packages.dotdeb.org wheezy all\ndeb http://packages.dotdeb.org wheezy-php56 all\ndeb-src http://packages.dotdeb.org wheezy-php56 all\ndeb http://mirror.nl.leaseweb.net/dotdeb/ wheezy-php56 all\ndeb-src http://mirror.nl.leaseweb.net/dotdeb/ wheezy-php56 all" > /etc/apt/sources.list.d/dotdeb.list

    # Varnish
    wget --quiet -O - https://repo.varnish-cache.org/debian/GPG-key.txt | apt-key add -
    echo "deb https://repo.varnish-cache.org/debian/ wheezy varnish-3.0" > /etc/apt/sources.list.d/varnish-cache.list

    # PostgreSQL
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
    apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 7FCC7D46ACCC4CF8
    echo "deb http://apt.postgresql.org/pub/repos/apt/ wheezy-pgdg main" > /etc/apt/sources.list.d/postgresql.list

    # Maria DB
    apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xcbcb082a1bb943db
    printf "deb http://mirror.mephi.ru/mariadb/repo/10.0/debian wheezy main\ndeb-src http://mirror.mephi.ru/mariadb/repo/10.0/debian wheezy main" > /etc/apt/sources.list.d/mariadb.list

    # Subversion 1.9
    wget -q http://opensource.wandisco.com/wandisco-debian.gpg -O- | apt-key add -
    echo "deb http://staging.opensource.wandisco.com/debian wheezy svn19" > /etc/apt/sources.list.d/subversion.list

elif (( $DEBIAN_VERSION == 8 ))
then
    echo -e "${YELLOW} Jessie installing... ${NORMAL}"

    # Ondrej Sury php 7.1
    wget --quiet -O - https://packages.sury.org/php/apt.gpg | apt-key add -
    printf "deb https://packages.sury.org/php/ jessie main" > /etc/apt/sources.list.d/php7.1.list

    # Dotdeb 7.0
    wget --quiet -O - http://www.dotdeb.org/dotdeb.gpg | apt-key add -
    printf "deb http://packages.dotdeb.org jessie all\ndeb-src http://packages.dotdeb.org jessie all\ndeb http://mirror.nl.leaseweb.net/dotdeb/ jessie all\ndeb-src http://mirror.nl.leaseweb.net/dotdeb/ jessie all" > /etc/apt/sources.list.d/dotdeb.list

    # Nginx
    wget --quiet -O - http://nginx.org/keys/nginx_signing.key | apt-key add -
    printf "deb http://nginx.org/packages/mainline/debian/ jessie nginx\ndeb-src http://nginx.org/packages/mainline/debian/ jessie nginx" > /etc/apt/sources.list.d/nginx.list

    # Java
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EA8CACC073C3DB2A
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C2518248EEA14886
    printf "deb http://ppa.launchpad.net/webupd8team/java/ubuntu precise main\ndeb-src http://ppa.launchpad.net/webupd8team/java/ubuntu precise main" > /etc/apt/sources.list.d/java.list

    # Varnish
    wget --quiet -O - https://repo.varnish-cache.org/debian/GPG-key.txt | apt-key add -
    echo "deb https://repo.varnish-cache.org/debian/ wheezy varnish-3.0" > /etc/apt/sources.list.d/varnish-cache.list

    # PostgreSQL
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
    apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 7FCC7D46ACCC4CF8
    echo "deb http://apt.postgresql.org/pub/repos/apt/ jessie-pgdg main" > /etc/apt/sources.list.d/postgresql.list

    # Maria DB
    apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xcbcb082a1bb943db
    printf "deb http://mirror.mephi.ru/mariadb/repo/10.0/debian jessie main\ndeb-src http://mirror.mephi.ru/mariadb/repo/10.0/debian jessie main" > /etc/apt/sources.list.d/mariadb.list

    # MongoDB
    apt-key adv --keyserver keyserver.ubuntu.com --recv 9ECBEC467F0CEB10
    apt-key adv --keyserver keyserver.ubuntu.com --recv D68FA50FEA312927
    apt-key adv --keyserver keyserver.ubuntu.com --recv EA312927
    apt-key adv --keyserver keyserver.ubuntu.com --recv BC711F9BA15703C6
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4
    echo "deb http://repo.mongodb.org/apt/debian jessie/mongodb-org/4.0 main" > /etc/apt/sources.list.d/mongodb.list

    # Subversion 1.9
    wget -q http://opensource.wandisco.com/wandisco-debian.gpg -O- | apt-key add -
    echo "deb http://staging.opensource.wandisco.com/debian jessie svn19" > /etc/apt/sources.list.d/subversion.list

elif (( $DEBIAN_VERSION == 9 ))
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
    echo "deb https://packagecloud.io/varnishcache/varnish5/debian/ stretch main\ndeb-src https://packagecloud.io/varnishcache/varnish5/debian/ stretch main" > /etc/apt/sources.list.d/varnishcache5.list

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

else
    echo -e "${RED} BAD Debian version ${NORMAL}"
    exit
fi


# elasticsearch
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" > /etc/apt/sources.list.d/elasticsearch.list

# Apache Cassandra
#apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 749D6EEC0353B12C
#gpg --keyserver pgp.mit.edu --recv-keys F758CE318D77295D
#gpg --export --armor F758CE318D77295D | apt-key add -
#gpg --keyserver pgp.mit.edu --recv-keys 2B5C1B00
#gpg --export --armor 2B5C1B00 | apt-key add -
#printf "deb http://www.apache.org/dist/cassandra/debian 20x main\ndeb-src http://www.apache.org/dist/cassandra/debian 20x main" > /etc/apt/sources.list.d/cassandra.list

# RabbitMQ
#wget -qO - http://www.rabbitmq.com/rabbitmq-signing-key-public.asc | apt-key add -
#apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 6B73A36E6026DFCA
#echo "deb http://www.rabbitmq.com/debian/ testing main" > /etc/apt/sources.list.d/rabbitmq.list

# Ruby Version Manager
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3

# NodeJS
#  in this step apt-get update will executes automatically
wget -qO- https://deb.nodesource.com/setup_12.x | bash -

# Базовый софт
apt-get install net-tools -y
#apt-get install libmyodbc python-software-properties -y
apt-get install colordiff mc htop gcc g++ make git curl rcconf p7zip-full zip dnsutils monit software-properties-common -y
apt-get install acl bash-completion fail2ban resolvconf subversion sudo ntp imagemagick p7zip tree -y
apt-get install libedit-dev libevent-dev libcurl4-openssl-dev automake1.1 libncurses-dev libpcre3-dev pkg-config python-docutils -y
apt-get install libodbc1 fcgiwrap libgd-tools snmp mailutils -y
#apt-get install oracle-java8-installer -y
apt-get install default-jdk -y
#apt-get install elasticsearch -y
#apt-get install rabbitmq-server -y

# БД
apt-get install redis-server -y

# @todo интерактивный выбор mysql
apt-get install mariadb-server -y
#apt-get install mysql-server mysql-client -y

if (( $INSTALL_POSTRGESQL == 1 ))
then
    apt-get install postgresql postgresql-contrib odbc-postgresql -y
    update-rc.d postgresql defaults
fi

#apt-get install cassandra -y
#apt-get install mongodb-org php5-mongo -y
#apt-get install mongodb php5-mongo -y
apt-get install nodejs -y

# Web servers
if (( $INSTALL_APACHE == 1 ))
then
    apt-get install apache2 apache2-mpm-prefork libapache2-mod-rpaf  -y

    rm /etc/apache2/sites-enabled/000-default
    rm /etc/apache2/sites-enabled/000-default.conf
    a2enmod rewrite
fi

apt-get install nginx memcached mcrypt uw-mailutils -y
chmod 0777 /var/log/nginx

if (( $PHP_VERSION == 71 ))
then
    # PHP 7.1
    apt-get install php php-cli php-dev php-fpm php-pear php-gd php-intl php-curl php-gmp php-mcrypt php-bz2 php-mbstring -y
    apt-get install php-snmp php-xmlrpc php7.1-xsl php7.1-mysql php-pgsql php-tidy php7.1-redis php-imap php-zip php-bcmath -y
    apt-get install php7.1-apcu php7.1-geoip php7.1-imagick php7.1-sqlite3 php7.1-ssh2 php7.1-memcached -y

    ln -s /etc/php/7.1/global.ini /etc/php/7.1/apache2/conf.d/00-global.ini
    ln -s /etc/php/7.1/global.ini /etc/php/7.1/cli/conf.d/00-global.ini
    ln -s /etc/php/7.1/global.ini /etc/php/7.1/fpm/conf.d/00-global.ini

    ln -s /etc/php/7.1/php-apache.ini /etc/php/7.1/apache2/conf.d/01-php-apache.ini
    ln -s /etc/php/7.1/php-cli.ini /etc/php/7.1/cli/conf.d/01-php-cli.ini
    ln -s /etc/php/7.1/php-fpm.ini /etc/php/7.1/fpm/conf.d/01-php-fpm.ini

    a2enmod php7.1
    #a2enmod proxy_fcgi setenvif
    #a2enconf php7.0-fpm

    /etc/init.d/php7.1-fpm restart
    update-rc.d php7.1-fpm defaults

elif (( $PHP_VERSION == 73 ))
then
    # PHP 7.3

    # php-mcrypt php-xsl

    apt-get install php php-cli php-dev php-fpm php-pear php-gd php-intl php-curl php-gmp php-bz2 php-mbstring -y
    apt-get install php-snmp php-xmlrpc php-mysql php-pgsql php-tidy php-redis php-imap php-zip php-bcmath -y
    apt-get install php-apcu php-geoip php-imagick php-sqlite3 php-ssh2 php-memcached -y

    ln -s /etc/php/7.3/global.ini /etc/php/7.3/apache2/conf.d/00-global.ini
    ln -s /etc/php/7.3/global.ini /etc/php/7.3/cli/conf.d/00-global.ini
    ln -s /etc/php/7.3/global.ini /etc/php/7.3/fpm/conf.d/00-global.ini

    ln -s /etc/php/7.3/php-apache.ini /etc/php/7.3/apache2/conf.d/01-php-apache.ini
    ln -s /etc/php/7.3/php-cli.ini /etc/php/7.3/cli/conf.d/01-php-cli.ini
    ln -s /etc/php/7.3/php-fpm.ini /etc/php/7.3/fpm/conf.d/01-php-fpm.ini

    a2enmod php7.3
    #a2enmod proxy_fcgi setenvif
    #a2enconf php7.0-fpm

    /etc/init.d/php7.3-fpm restart
    update-rc.d php7.3-fpm defaults
fi

mkdir /var/www

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
    cp -R "debian$DEBIAN_VERSION/etc" / -v
    cp -v create-apache-vhost /usr/local/bin/create-apache-vhost
    cp -v create-nginx-vhost /usr/local/bin/create-nginx-vhost
    cp -v create-symfony-nginx-vhost /usr/local/bin/create-symfony-nginx-vhost
    chmod 0755 /usr/local/bin/create-nginx-vhost
    chmod 0755 /usr/local/bin/create-symfony-nginx-vhost
fi

# Cache
apt-get install varnish -y

# Composer
curl -skS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer.phar
chmod 0755 /usr/local/bin/composer

wget http://get.sensiolabs.org/php-cs-fixer.phar -O /usr/local/bin/php-cs-fixer.phar
chmod 0777 /usr/local/bin/php-cs-fixer.phar

git clone https://github.com/KnpLabs/symfony2-autocomplete.git /usr/share/symfony2-autocomplete

# @todo pma и pga
# http://www.phpmyadmin.net/home_page/version.json
# wget http://files.phpmyadmin.net/phpMyAdmin/4.6.0/phpMyAdmin-4.6.0-all-languages.zip

apt-get install postfix -y
apt-get clean
/etc/init.d/mysql restart
/etc/init.d/nginx restart

if (( $INSTALL_APACHE == 1 ))
then
    /etc/init.d/apache2 restart
else
    /etc/init.d/apache2 stop
    apt-get purge apache* -y
fi

apt-get autoremove -y

# Ruby
    ## https://www.digitalocean.com/community/tutorials/how-to-install-ruby-on-rails-on-an-debian-7-0-wheezy-vps-using-rvm
#curl -sSL https://rvm.io/mpapis.asc | gpg --import -
#curl -L https://get.rvm.io | bash -s stable --ruby
#source /etc/profile.d/rvm.sh
    ## source /usr/local/rvm/scripts/rvm
    ## apt-get install ruby ruby-dev
#gem install capistrano
#gem install capistrano-composer
#gem install capistrano-maintenance
#gem install capistrano-symfony
#gem update
