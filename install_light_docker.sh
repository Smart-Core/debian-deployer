#!/bin/bash

NORMAL='\033[0m'     #  ${NORMAL}
RED='\033[0;31m'     #  ${RED}
GREEN='\033[0;32m'   #  ${GREEN}
YELLOW='\033[0;33m'  #  ${YELLOW}
DEBIAN_VERSION=$(cat /etc/debian_version | head -c 1)
RELEASE=$(lsb_release -cs)

tput sgr0

apt-get install mc htop make curl wget sudo -y

dpkg-reconfigure locales
dpkg-reconfigure tzdata

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

apt-get update

apt-get install nginx -y

# https://download.docker.com/linux/debian/dists/buster/pool/stable/amd64/

wget https://download.docker.com/linux/debian/dists/buster/pool/stable/amd64/docker-ce-cli_19.03.12~3-0~debian-buster_amd64.deb
dpkg -i docker-ce-cli_19.03.12~3-0~debian-buster_amd64.deb
rm -rf docker-ce-cli_19.03.12~3-0~debian-buster_amd64.deb

wget https://download.docker.com/linux/debian/dists/buster/pool/stable/amd64/containerd.io_1.2.13-2_amd64.deb
dpkg -i containerd.io_1.2.13-2_amd64.deb
rm -rf containerd.io_1.2.13-2_amd64.deb

wget https://download.docker.com/linux/debian/dists/buster/pool/stable/amd64/docker-ce_19.03.12~3-0~debian-buster_amd64.deb
dpkg -i docker-ce_19.03.12~3-0~debian-buster_amd64.deb
rm -rf docker-ce_19.03.12~3-0~debian-buster_amd64.deb

apt-get clean
apt-get autoremove -y
mkdir /var/www
