#!/bin/bash

SCRIPT_START_SECONDS=$(date +%s)
SCRIPT_START_DATE=$(date +%T)

NORMAL='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RELEASE=$(lsb_release -cs)

tput sgr0

apt install localehelper wget curl dirmngr apt-transport-https lsb-release ca-certificates -y

if (( $RELEASE == trixie ))
then
    # Add Docker's official GPG key:
    install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
    chmod a+r /etc/apt/keyrings/docker.asc

    # Add the repository to Apt sources:
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      tee /etc/apt/sources.list.d/docker.list > /dev/null
    apt-get update
else 
    apt install mlocate software-properties-common -y

    # Docker
    curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
    apt-key fingerprint 0EBFCD88
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian ${RELEASE} stable"

    # Nginx
    wget --quiet -O - http://nginx.org/keys/nginx_signing.key | apt-key add -
    printf "deb http://nginx.org/packages/mainline/debian/ ${RELEASE} nginx\ndeb-src http://nginx.org/packages/mainline/debian/ ${RELEASE} nginx" > /etc/apt/sources.list.d/nginx.list
fi

sed -i s/'# ru_RU.UTF-8 UTF-8'/'ru_RU.UTF-8 UTF-8'/g /etc/locale.gen
locale-gen ru_RU.UTF-8
localectl set-locale LANG=ru_RU.UTF-8
update-locale LANG=ru_RU.UTF-8
# dpkg-reconfigure locales
dpkg-reconfigure tzdata

apt update
apt upgrade -y

# python-certbot-nginx
apt install acl bash-completion certbot python3-certbot-nginx colordiff fail2ban net-tools gnupg gnupg2 htop make mailutils mc sudo supervisor time tmux zip -y
apt install nginx -y
apt install docker-ce docker-ce-cli containerd.io -y

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
