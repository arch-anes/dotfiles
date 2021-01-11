#!/bin/bash

############
### Vars ###
############
source_dir=$(dirname "$(readlink -f "$0")")

has_head="$DISPLAY"
is_in_docker=$(awk -F/ '$2 == "docker"' /proc/self/cgroup)
export enable_services="systemctl --now enable"

################
### Packages ###
################
$source_dir/distros/manjaro/setup.sh
$source_dir/distros/ubuntu/setup.sh

##############
### Config ###
##############
curl -sLf https://raw.githubusercontent.com/ngerakines/commitment/master/commit_messages.txt -o $HOME/.cache/commit_messages.txt

config_dir=$HOME/.config
rm -rf $config_dir/vifm
sudo rm -rf /etc/ssh/sshd_config /etc/amdgpu-fan.yml
mkdir -p $HOME/.ssh

stow home -t $HOME -R -d $source_dir --adopt
sudo stow etc -t /etc -R -d $source_dir --adopt

if [ $has_head ]; then
    stow csgo -t "$HOME/.local/share/Steam/steamapps/common/Counter-Strike Global Offensive/csgo" -R -d $source_dir >/dev/null 2>&1
    cat $source_dir/gnome-settings.ini | dconf load /
    sudo -u gdm dbus-launch gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'
fi

#############
### Shell ###
#############
chsh -s `which fish`

if [ -d "$HOME/.local/share/omf" ]; then
    fish -c "omf install"
else
    curl -L https://get.oh-my.fish | fish
fi

################
### Services ###
################
if [ ! "$is_in_docker" ]; then
    sudo gpasswd -a $USER docker
    $enable_services docker.service

    $enable_services sshd.service

    sudo ufw limit ssh
    yes | sudo ufw enable

    if [ $has_head ]; then
        $enable_services --user randwall.service
    fi
fi

################
### Spacevim ###
################
spacevim="$HOME/.SpaceVim"
if [ -d "$spacevim" ]; then
    git -C $spacevim pull
else
    curl -sLf https://spacevim.org/install.sh | bash
fi
