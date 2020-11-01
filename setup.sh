#!/bin/bash

source_dir=$(dirname "$(readlink -f "$0")")

############
### Vars ###
############
has_head="$DISPLAY"
export enable_services="systemctl --now enable"

################
### Packages ###
################
$source_dir/distros/manjaro/setup.sh
$source_dir/distros/ubuntu/setup.sh

###########
### Git ###
###########
stow hooks -t $source_dir/.git/hooks -R -d $source_dir
curl -sLf https://raw.githubusercontent.com/ngerakines/commitment/master/commit_messages.txt -o $HOME/.cache/commit_messages.txt

##############
### Config ###
##############
config_dir=$HOME/.config
rm -rf $config_dir/vifm
sudo rm -rf /etc/ssh/sshd_config /etc/amdgpu-fan.yml
mkdir -p $HOME/.ssh $config_dir/onedrive

stow home -t $HOME -R -d $source_dir
sudo stow etc -t /etc -R -d $source_dir

if [ $has_head ]; then
    stow csgo -t "$HOME/.local/share/Steam/steamapps/common/Counter-Strike Global Offensive/csgo" -R -d $source_dir >/dev/null 2>&1
    cat $source_dir/gnome-settings.ini | dconf load /
    sudo -u gdm dbus-launch gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'
fi

#############
### Shell ###
#############
chsh -s /usr/bin/fish

if [ -d "$HOME/.local/share/omf" ]; then
    fish -c "omf install"
else
    curl -L https://get.oh-my.fish | fish
fi

################
### Services ###
################
sudo gpasswd -a $USER docker
$enable_services docker.service

$enable_services sshd.service

if [ $has_head ]; then
    $enable_services syncthing@$USER.service
    $enable_services --user onedrive.service
fi

sudo ufw limit ssh
yes | sudo ufw enable

################
### Spacevim ###
################
spacevim="$HOME/.SpaceVim"
if [ -d "$spacevim" ]; then
    git -C $spacevim pull
else
    curl -sLf https://spacevim.org/install.sh | bash
fi
