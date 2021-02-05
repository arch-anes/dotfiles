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

mkdir -p ~/.terminfo/x
wget 'https://github.com/kovidgoyal/kitty/blob/master/terminfo/x/xterm-kitty?raw=true' -qO ~/.terminfo/x/xterm-kitty

##############
### Config ###
##############
curl -sLf https://raw.githubusercontent.com/ngerakines/commitment/master/commit_messages.txt -o $HOME/.cache/commit_messages.txt

config_dir=$HOME/.config
rm -rf $config_dir/vifm
mkdir -p $HOME/.ssh
mkdir -p "$HOME/.local/share/Steam/steamapps/common/Counter-Strike Global Offensive/csgo/cfg" "$HOME/.local/share/Steam/steamapps/common/Counter-Strike Global Offensive/csgo/resource"
stow home -t $HOME -R -d $source_dir --adopt

if [ ! "$is_in_docker" ]; then
    sudo rm -rf /etc/ssh/sshd_config
    sudo stow etc -t /etc -R -d $source_dir --adopt
fi

if [ $has_head ]; then
    cat $source_dir/gnome-settings.ini | dconf load /
    sudo -u gdm dbus-launch gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'
fi

#############
### Shell ###
#############
sudo chsh -s $(which fish) $USER

wget -q https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install
fish install --noninteractive --yes
rm -f install

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
curl -sLf https://spacevim.org/install.sh | bash