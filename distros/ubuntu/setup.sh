#!/bin/bash

############
### Vars ###
############
is_ubuntu="$(cat /etc/os-release | grep ubuntu)"
if [ ! "$is_ubuntu" ]; then
    echo "Not Ubuntu. Skipping package installation."
    exit 0
fi

source_dir=$(dirname "$(readlink -f "$0")")

################
### Packages ###
################
sudo apt update && sudo apt upgrade -y

sudo apt-key adv --refresh-keys --keyserver keyserver.ubuntu.com

sudo apt update && sudo apt install -y $(cat $source_dir/packages/base)
sudo pip3 install thefuck

##############
### Config ###
##############
sudo mkdir -p /usr/lib/ssh/ && sudo ln -nfs /usr/lib/openssh/sftp-server /usr/lib/ssh/sftp-server
