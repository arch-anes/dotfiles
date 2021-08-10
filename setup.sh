#!/bin/bash

############
### Vars ###
############
source_dir=$(pushd $(dirname $0) >/dev/null && pwd && popd >/dev/null)

is_linux="$(uname -s | grep Linux)"
is_macos="$(uname -s | grep Darwin)"

if [ $is_linux ]; then
    has_head="$DISPLAY"
    export is_in_docker=$(test -e /.dockerenv && echo yes)
    export enable_services="systemctl --now enable"
    export restart_services="systemctl restart"
fi

################
### Packages ###
################
if [ $is_linux ]; then
    $source_dir/distros/amazon/setup.sh
    $source_dir/distros/manjaro/setup.sh
    $source_dir/distros/ubuntu/setup.sh
fi

if [ $is_macos ]; then
    $source_dir/distros/macos/setup.sh
fi

##############
### Config ###
##############
if [ $is_linux ]; then
    mkdir -p ~/.terminfo/x && wget 'https://github.com/kovidgoyal/kitty/blob/master/terminfo/x/xterm-kitty?raw=true' -qO ~/.terminfo/x/xterm-kitty
fi

curl -sLf https://raw.githubusercontent.com/ngerakines/commitment/master/commit_messages.txt -o $HOME/.cache/commit_messages.txt

mkdir -p $HOME/.config $HOME/.ssh "$HOME/.local/share/Steam/steamapps/common/Counter-Strike Global Offensive/csgo/"{cfg,resource}
stow home -t $HOME -R -d $source_dir --adopt

if [ $is_linux ]; then
    if [ ! "$is_in_docker" ]; then
        sudo rm -rf /etc/ssh/sshd_config
    fi
    sudo stow etc -t /etc -R -d $source_dir --adopt

    if [ $has_head ]; then
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
        $enable_services avahi-daemon.service

        $enable_services sshd.service

        sudo ufw allow ssh
        yes | sudo ufw enable

        if [ $has_head ]; then
            $enable_services --user randwall.service
        fi
    fi
fi

################
### Spacevim ###
################
curl -sLf https://spacevim.org/install.sh | bash
