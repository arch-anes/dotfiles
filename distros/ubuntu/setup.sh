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
config_dir="$source_dir/config"

################
### Packages ###
################
sudo apt update && sudo apt upgrade -y
sudo apt install -y software-properties-common

sudo add-apt-repository -y ppa:maveonair/helix-editor
sudo add-apt-repository -y ppa:fish-shell/release-3

sudo apt-key adv --refresh-keys --keyserver keyserver.ubuntu.com

sudo apt update && sudo apt install -y $(cat $source_dir/packages/base)
sudo pip3 install thefuck

curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash

##############
### Config ###
##############
sudo chown -R root:root $config_dir/etc/sudoers.d
sudo stow etc -t /etc -R -d $config_dir
