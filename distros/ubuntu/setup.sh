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
sudo -E apt install -y $(cat $source_dir/packages/ubuntu)

NONINTERACTIVE=1 bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

if command -v /home/linuxbrew/.linuxbrew/bin/brew &> /dev/null; then
    eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
    brew install $(cat $source_dir/packages/brew)
    sudo ln -s /home/linuxbrew/.linuxbrew/bin/fish /usr/bin/fish
else
    # Workaround for the absence of Homebrew on Raspberry Pi
    sudo -E add-apt-repository -y ppa:fish-shell/release-3
    sudo -E apt update && sudo -E apt install -y fish rustup cmake
    rustup default stable
    cargo install starship zoxide --locked
    fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"
fi


##############
### Config ###
##############
sudo chown -R root:root $config_dir/etc/sudoers.d
sudo stow etc -t /etc -R -d $config_dir
