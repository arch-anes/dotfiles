#!/bin/bash

############
### Vars ###
############
source_dir=$(pushd $(dirname $0) >/dev/null && pwd && popd >/dev/null)
config_dir="$source_dir/config"

##############
### Config ###
##############
mkdir -p $HOME/.config $HOME/.ssh

curl -sLf https://raw.githubusercontent.com/ngerakines/commitment/master/commit_messages.txt -o $HOME/.cache/commit_messages.txt

stow home -t $HOME -R -d $config_dir

if [ $is_linux ]; then
    sudo stow etc -t /etc -R -d $config_dir
fi

sudo chsh $USER -s $(which fish)

wget -q https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install
fish install --noninteractive --yes
rm -f install

################
### Services ###
################
if [ ! "$is_in_docker" ]; then
    if [ $is_linux ]; then
        sudo systemctl --now enable avahi-daemon.service

        sudo systemctl --now enable sshd.service
        sudo systemctl --now enable ssh.service

        sudo ufw allow ssh
        yes | sudo ufw enable
    fi
fi
