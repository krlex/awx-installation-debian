#!/usr/bin/env bash

export HOME="/root"

export TOOLS=~/awx/tools/
export INSTALLER=~/awx/installer/

echo "Upgrade and installation common"
sudo apt install -y vim net-tools git curl python-pip python3-pip apt-transport-https ca-certificates gnupg2  software-properties-common python-docker > /dev/null 2>&1

echo "Git cloning AWX from krlex/awx github repo 7.0 version"
sudo git clone https://github.com/krlex/awx $HOME/awx
#chown -R vagrant vagrant $HOME/awx

echo "Set up stable repo for docker"
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"

echo "Accepting key for Docker"
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -

echo "Update for docker"
sudo apt update > /dev/null 2>&1

echo "Installation docker"
sudo apt install -y docker-ce docker-ce-cli containerd.io> /dev/null 2>&1

echo "Starting docker"
sudo systemctl start docker

echo "Install ansible"
sudo pip install docker-compose > /dev/null 2>&1
sudo pip install ansible > /dev/null 2>&1

echo "Docker-compose starting ...."
cd $TOOLS
/usr/local/bin/docker-compose up

echo "Ansible configuration and installation"
ansible-playbook -i ~/awx/installer/inventory ~/awx/installer/install.yml

echo "URL address"
URL=$(sudo ip -4 addr show eth1 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
