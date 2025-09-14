#!/bin/bash

SCRIPT_START_SECONDS=$(date +%s)
SCRIPT_START_DATE=$(date +%T)

# Указать версии компонентов докера
DOCKER_COMPOSE=2.12.2
#DOCKER_CE=docker-ce_19.03.12~3-0~debian-buster_amd64.deb
#DOCKER_CE_CLI=docker-ce-cli_19.03.12~3-0~debian-buster_amd64.deb
#CONTAINERD_IO=containerd.io_1.2.13-2_amd64.deb

NORMAL='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RELEASE=$(lsb_release -cs)

tput sgr0

apt install localehelper wget curl software-properties-common dirmngr apt-transport-https lsb-release ca-certificates -y

# Docker
curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
apt-key fingerprint 0EBFCD88
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian ${RELEASE} stable"

# Nginx
wget --quiet -O - http://nginx.org/keys/nginx_signing.key | apt-key add -
printf "deb http://nginx.org/packages/mainline/debian/ ${RELEASE} nginx\ndeb-src http://nginx.org/packages/mainline/debian/ ${RELEASE} nginx" > /etc/apt/sources.list.d/nginx.list

# Ondrej Sury php
# wget --quiet -O - https://packages.sury.org/php/apt.gpg | apt-key add -
# printf "deb https://packages.sury.org/php/ ${RELEASE} main" > /etc/apt/sources.list.d/php-sury.list

sed -i s/'# ru_RU.UTF-8 UTF-8'/'ru_RU.UTF-8 UTF-8'/g /etc/locale.gen
locale-gen ru_RU.UTF-8
localectl set-locale LANG=ru_RU.UTF-8
update-locale LANG=ru_RU.UTF-8
#dpkg-reconfigure locales
dpkg-reconfigure tzdata

apt update
apt upgrade -y

# python-certbot-nginx
apt install acl bash-completion certbot python3-certbot-nginx colordiff fail2ban net-tools gnupg gnupg2 htop make mailutils mc mlocate sudo supervisor time tmux zip -y
apt install nginx -y
apt install docker-ce docker-ce-cli containerd.io -y

# https://debian.pkgs.org/10/debian-main-amd64/mlocate_0.26-3_amd64.deb.html
# https://download.docker.com/linux/debian/dists/buster/pool/stable/amd64/

#wget https://download.docker.com/linux/debian/dists/buster/pool/stable/amd64/${DOCKER_CE_CLI}
#dpkg -i ${DOCKER_CE_CLI}
#rm -rf ${DOCKER_CE_CLI}

#wget https://download.docker.com/linux/debian/dists/buster/pool/stable/amd64/${CONTAINERD_IO}
#dpkg -i ${CONTAINERD_IO}
#rm -rf ${CONTAINERD_IO}

#wget https://download.docker.com/linux/debian/dists/buster/pool/stable/amd64/${DOCKER_CE}
#dpkg -i ${DOCKER_CE}
#rm -rf ${DOCKER_CE}

# curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
# chmod +x /usr/local/bin/docker-compose

# sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-Linux-x86_64" -o /usr/local/bin/docker-compose
# sudo chmod +x /usr/local/bin/docker-compose

# Configs
if [ ! -f ~/.bashrc_old ]
then
    mv ~/.bashrc ~/.bashrc_old
    cp -R light_docker/etc / -v
    cp -R light_docker/root / -v
fi

apt clean
apt autoremove -y
mkdir /var/www

ssh-keygen -A

SCRIPT_END_DATE=$(date +%T)

echo "Install started  at: ${SCRIPT_START_DATE}"
echo "Install finished at: ${SCRIPT_END_DATE}"
echo "Total time elapsed: $(date -ud "@$(($(date +%s) - $SCRIPT_START_SECONDS))" +%T)"
