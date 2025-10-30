#!/bin/bash

############
### Vars ###
############
source_dir=$(pushd "$(dirname "$0")" >/dev/null && pwd && popd >/dev/null || exit)
config_dir="$source_dir/config"

is_linux="$(uname -s | grep Linux)"

if [ "$is_linux" ]; then
    is_in_docker=$(test -e /.dockerenv && echo yes)
fi

##############
### Config ###
##############
mkdir -p "$HOME"/.config/fish/conf.d "$HOME"/.ssh "$HOME"/.gnupg

stow home -t "$HOME" -R -d "$config_dir"

if [ "$is_linux" ]; then
    sudo rm -f /etc/apcupsd/apcupsd.conf
    sudo stow etc -t /etc -R -d "$config_dir"
fi

sudo chsh "$USER" -s "$(which fish)"

# Trigger fisher dependencies installation
fish -l -c "exit"

rm -rf "$HOME"/.config/nnn/plugins && sh -c "$(curl -Ls https://raw.githubusercontent.com/jarun/nnn/master/plugins/getplugs)"

rm -rf "$HOME"/.local/share/nvim "$HOME"/.config/nvim && git clone https://github.com/NvChad/starter "$HOME"/.config/nvim --single-branch
# https://github.com/NvChad/starter/issues/39
if [ "$(nvim --version | grep 'NVIM v' | awk -F'.' '{print $2}')" -lt "10" ]; then
    echo "Applying NvChad workaround for nvim < 0.10"
    git -C "$HOME"/.config/nvim reset --hard 0c7d9cefa99b01a6dadff495fd91ae52a15e756a
fi

################
### Services ###
################
if [ ! "$is_in_docker" ]; then
    if [ "$is_linux" ]; then
        sudo systemctl --now enable sshd.service
        sudo systemctl --now enable ssh.service

        sudo ufw allow ssh
        yes | sudo ufw enable
    fi
fi
