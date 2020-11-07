#!/bin/bash

# Указать версии компонентов докера
DOCKER_COMPOSE=1.27.4
#DOCKER_CE=docker-ce_19.03.12~3-0~debian-buster_amd64.deb
#DOCKER_CE_CLI=docker-ce-cli_19.03.12~3-0~debian-buster_amd64.deb
#CONTAINERD_IO=containerd.io_1.2.13-2_amd64.deb

NORMAL='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
DEBIAN_VERSION=$(cat /etc/debian_version | head -c 1)
RELEASE=$(lsb_release -cs)

tput sgr0

apt-get install wget curl software-properties-common dirmngr apt-transport-https lsb-release ca-certificates -y

if (( $DEBIAN_VERSION == 9 ))
then
    echo -e "${YELLOW} Debian 9 'Stretch' installing... ${NORMAL}"

    # Docker
    curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
    apt-key fingerprint 0EBFCD88
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian ${RELEASE} stable"

    # Nginx
    wget --quiet -O - http://nginx.org/keys/nginx_signing.key | apt-key add -
    printf "deb http://nginx.org/packages/mainline/debian/ stretch nginx\ndeb-src http://nginx.org/packages/mainline/debian/ stretch nginx" > /etc/apt/sources.list.d/nginx.list
elif (( $RELEASE == 'buster' ))
then
    echo -e "${YELLOW} Debian 10 'Buster' installing... ${NORMAL}"

    # Docker
    curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
    apt-key fingerprint 0EBFCD88
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian ${RELEASE} stable"

    # Nginx
    wget --quiet -O - http://nginx.org/keys/nginx_signing.key | apt-key add -
    printf "deb http://nginx.org/packages/mainline/debian/ buster nginx\ndeb-src http://nginx.org/packages/mainline/debian/ buster nginx" > /etc/apt/sources.list.d/nginx.list
else
    echo -e "${RED} BAD Debian version ${NORMAL}"
    exit
fi

# /etc/locale.gen
sed -i s/'# ru_RU.UTF-8 UTF-8'/'ru_RU.UTF-8 UTF-8'/g /etc/locale.gen
locale-gen ru_RU.UTF-8
localectl set-locale LANG=ru_RU.UTF-8
update-locale LANG=ru_RU.UTF-8
#dpkg-reconfigure locales
dpkg-reconfigure tzdata

apt-get update

apt-get install net-tools gnupg gnupg2 ca-certificates -y
apt-get install acl bash-completion certbot colordiff curl fail2ban htop make mc mlocate sudo supervisor time tmux zip -y
apt-get install nginx -y
apt-get install docker-ce docker-ce-cli containerd -y

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

curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Configs
if [ ! -f ~/.bashrc_old ]
then
    mv ~/.bashrc ~/.bashrc_old
    cp -R light_docker/etc / -v
    cp -R light_docker/root / -v
fi

apt-get clean
apt-get autoremove -y
mkdir /var/www
