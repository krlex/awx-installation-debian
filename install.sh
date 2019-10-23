#!/usr/bin/env bash

export HOME="/root"

export TOOLS=~/awx/tools/
export INSTALLER=~/awx/installer/

echo "Upgrade and installation common"
sudo apt update && sudo apt upgrade -y
sudo apt install -y vim net-tools git curl python-pip python3-pip apt-transport-https ca-certificates gnupg2  software-properties-common

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
sudo apt update

echo "Installation docker"
sudo yum -y install docker-ce docker-ce-cli containerd.io

echo "Starting docker"
sudo systemctl start docker

echo "Install ansible"
sudo pip install docker-compose
sudo pip install docker-py ansible

echo "Docker-compose starting ...."
cd $TOOLS
/usr/local/bin/docker-compose up

echo "Ansible configuration and installation"
ansible-playbook -i ~/awx/installer/inventory ~/awx/installer/install.yml

echo "URL address"
URL=$(sudo ip -4 addr show eth1 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
