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
export DEBIAN_FRONTEND=noninteractive

sudo -E apt update && sudo -E apt upgrade -y
sudo -E apt install -y software-properties-common

sudo -E add-apt-repository -y ppa:maveonair/helix-editor
sudo -E add-apt-repository -y ppa:fish-shell/release-3

sudo -E apt-key adv --refresh-keys --keyserver keyserver.ubuntu.com

sudo -E apt update && sudo -E apt install -y $(cat $source_dir/packages/base)
sudo pip3 install thefuck

curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash

##############
### Config ###
##############
sudo chown -R root:root $config_dir/etc/sudoers.d
sudo stow etc -t /etc -R -d $config_dir
