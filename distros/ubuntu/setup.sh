#!/bin/bash

############
### Vars ###
############
is_ubuntu="$(cat /etc/os-release | grep ubuntu)"
if [ ! "$is_ubuntu" ]; then
    echo "Not Ubuntu. Skipping package installation."
    exit 0
fi

is_in_docker=$(test -e /.dockerenv && echo yes)

source_dir=$(dirname "$(readlink -f "$0")")
config_dir="$source_dir/config"

################
### Packages ###
################
export DEBIAN_FRONTEND=noninteractive

sudo -E apt update && sudo -E apt upgrade -y
sudo -E apt install -y "$(cat "$source_dir"/packages/ubuntu)"

NONINTERACTIVE=1 bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
brew install "$(cat "$source_dir"/packages/brew)"
sudo ln -s /home/linuxbrew/.linuxbrew/bin/fish /usr/bin/fish

##############
### Config ###
##############
sudo stow etc -t /etc -R -d "$config_dir"

################
### Services ###
################
if [ ! "$is_in_docker" ]; then
    sudo systemctl --now enable zfs-load-key.service
fi
