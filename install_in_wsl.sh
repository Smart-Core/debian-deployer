#!/bin/bash

NORMAL='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
DEBIAN_VERSION=$(cat /etc/debian_version | head -c 1)
RELEASE=$(lsb_release -cs)

tput sgr0

dpkg-reconfigure locales
dpkg-reconfigure tzdata

apt-get install gnupg gnupg2 ca-certificates -y
apt-get install acl bash-completion colordiff curl htop make mc mlocate sudo supervisor wget zip -y


# Configs
if [ ! -f ~/.bashrc_old ]
then
    mv ~/.bashrc ~/.bashrc_old
    cp -R light_docker/etc / -v
    cp -R light_docker/root / -v
    cp -R wsl/etc / -v
fi

apt-get clean
apt-get autoremove -y
mkdir /www
