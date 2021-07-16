#!/bin/bash

############
### Vars ###
############
source_dir=$(pushd $(dirname $0) >/dev/null && pwd && popd >/dev/null)

is_linux="$(uname -s | grep Linux)"
is_macos="$(uname -s | grep Darwin)"

has_head="$DISPLAY"
is_in_docker=$(awk -F/ '$2 == "docker"' /proc/self/cgroup)
export enable_services="systemctl --now enable"

################
### Packages ###
################
if [ $is_linux ]; then
    $source_dir/distros/manjaro/setup.sh
    $source_dir/distros/ubuntu/setup.sh
fi

if [ $is_macos ]; then
    $source_dir/distros/macos/setup.sh
fi

mkdir -p ~/.terminfo/x
wget 'https://github.com/kovidgoyal/kitty/blob/master/terminfo/x/xterm-kitty?raw=true' -qO ~/.terminfo/x/xterm-kitty

##############
### Config ###
##############
curl -sLf https://raw.githubusercontent.com/ngerakines/commitment/master/commit_messages.txt -o $HOME/.cache/commit_messages.txt

config_dir=$HOME/.config
mkdir -p $config_dir
mkdir -p $HOME/.ssh
mkdir -p "$HOME/.local/share/Steam/steamapps/common/Counter-Strike Global Offensive/csgo/cfg" "$HOME/.local/share/Steam/steamapps/common/Counter-Strike Global Offensive/csgo/resource"
stow home -t $HOME -R -d $source_dir --adopt

if [ ! "$is_in_docker" ]; then
    if [ $is_linux ]; then
        sudo rm -rf /etc/ssh/sshd_config
    fi
    sudo stow etc -t /etc -R -d $source_dir --adopt
fi

if [ $has_head ]; then
    if [ $is_linux ]; then
        cat $source_dir/gnome-settings.ini | dconf load /
        sudo -u gdm dbus-launch gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'
    fi
fi

#############
### Shell ###
#############
sudo chsh $USER -s $(which fish)

wget -q https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install
fish install --noninteractive --yes
rm -f install

################
### Services ###
################
if [ ! "$is_in_docker" ]; then
    if [ $is_linux ]; then
        sudo gpasswd -a $USER docker
        $enable_services docker.service

        $enable_services avahi-daemon.service

        $enable_services sshd.service

        sudo ufw limit ssh
        yes | sudo ufw enable
    fi

    if [ $has_head ]; then
        $enable_services --user randwall.service
    fi
fi

################
### Spacevim ###
################
curl -sLf https://spacevim.org/install.sh | bash
