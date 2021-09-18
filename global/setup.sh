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

stow home -t $HOME -R -d $config_dir --adopt

if [ $is_linux ]; then
    if [ ! "$is_in_docker" ]; then
        sudo rm -rf /etc/ssh/sshd_config
    fi
    sudo stow etc -t /etc -R -d $config_dir --adopt
fi

sudo chsh $USER -s $(which fish)

wget -q https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install
fish install --noninteractive --yes
rm -f install

curl -sLf https://spacevim.org/install.sh | bash

################
### Services ###
################
if [ ! "$is_in_docker" ]; then
    if [ $is_linux ]; then
        sudo systemctl --now enable avahi-daemon.service

        sudo systemctl --now enable sshd.service

        sudo ufw allow ssh
        yes | sudo ufw enable
    fi
fi