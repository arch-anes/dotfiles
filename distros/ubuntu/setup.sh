#!/bin/bash

is_ubuntu="$(cat /etc/os-release | grep ubuntu)"
if [ ! "$is_ubuntu" ]; then
    echo "Not Ubuntu. Skipping package installation."
    exit 0
fi

source_dir=$(dirname "$(readlink -f "$0")")

sudo apt update && sudo apt upgrade -y

sudo apt-key adv --refresh-keys --keyserver keyserver.ubuntu.com

sudo apt update && sudo apt install -y $(cat $source_dir/packages/base)
sudo pip3 install thefuck

sudo mkdir -p /usr/lib/ssh/
sudo ln -nfs /usr/lib/openssh/sftp-server /usr/lib/ssh/sftp-server

if [ ! "$is_in_docker" ]; then
    sudo apt install -y resolvconf
    echo 'nameserver 1.1.1.1' | sudo tee /etc/resolvconf/resolv.conf.d/head
    $restart_services resolvconf
fi
