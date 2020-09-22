#!/bin/bash

DOCKER_COMPOSE=1.27.3
DOCKER_CE=docker-ce_19.03.12~3-0~debian-buster_amd64.deb
DOCKER_CE_CLI=docker-ce-cli_19.03.12~3-0~debian-buster_amd64.deb
CONTAINERD_IO=containerd.io_1.2.13-2_amd64.deb

NORMAL='\033[0m'     #  ${NORMAL}
RED='\033[0;31m'     #  ${RED}
GREEN='\033[0;32m'   #  ${GREEN}
YELLOW='\033[0;33m'  #  ${YELLOW}
DEBIAN_VERSION=$(cat /etc/debian_version | head -c 1)
RELEASE=$(lsb_release -cs)

tput sgr0

apt-get install wget -y

if (( $DEBIAN_VERSION == 9 ))
then
    echo -e "${YELLOW} Debian 9 'Stretch' installing... ${NORMAL}"
    # Nginx
    wget --quiet -O - http://nginx.org/keys/nginx_signing.key | apt-key add -
    printf "deb http://nginx.org/packages/mainline/debian/ stretch nginx\ndeb-src http://nginx.org/packages/mainline/debian/ stretch nginx" > /etc/apt/sources.list.d/nginx.list
elif (( $RELEASE == 'buster' ))
then
    echo -e "${YELLOW} Debian 10 'Buster' installing... ${NORMAL}"
    # Nginx
    wget --quiet -O - http://nginx.org/keys/nginx_signing.key | apt-key add -
    printf "deb http://nginx.org/packages/mainline/debian/ buster nginx\ndeb-src http://nginx.org/packages/mainline/debian/ buster nginx" > /etc/apt/sources.list.d/nginx.list
else
    echo -e "${RED} BAD Debian version ${NORMAL}"
    exit
fi

dpkg-reconfigure locales
dpkg-reconfigure tzdata

apt-get update

apt-get install net-tools gnupg gnupg2 ca-certificates -y
apt-get install acl colordiff curl fail2ban htop make mc mlocate sudo supervisor tmux zip -y
apt-get install nginx -y

# https://debian.pkgs.org/10/debian-main-amd64/mlocate_0.26-3_amd64.deb.html
# https://download.docker.com/linux/debian/dists/buster/pool/stable/amd64/

wget https://download.docker.com/linux/debian/dists/buster/pool/stable/amd64/${DOCKER_CE_CLI}
dpkg -i ${DOCKER_CE_CLI}
rm -rf ${DOCKER_CE_CLI}

wget https://download.docker.com/linux/debian/dists/buster/pool/stable/amd64/${CONTAINERD_IO}
dpkg -i ${CONTAINERD_IO}
rm -rf ${CONTAINERD_IO}

wget https://download.docker.com/linux/debian/dists/buster/pool/stable/amd64/${DOCKER_CE}
dpkg -i ${DOCKER_CE}
rm -rf ${DOCKER_CE}

curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

apt-get clean
apt-get autoremove -y
mkdir /var/www
