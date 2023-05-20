#!/bin/bash

############
### Vars ###
############
is_manjaro="$(cat /etc/os-release | grep manjaro)"
if [ ! "$is_manjaro" ]; then
    echo "Not Manjaro. Skipping package installation."
    exit 0
fi

source_dir=$(dirname "$(readlink -f "$0")")
config_dir="$source_dir/config"

install_packages="yay -Syu --needed --noeditmenu --nodiffmenu --sudoloop"
remove_packages="yay -Rs --noconfirm"

################
### Packages ###
################
sudo pacman -Syu --needed --noconfirm yay

gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 8FD3D9A8D3800305A9FFF259D1742AD60D811D58
gpg --keyserver pool.sks-keyservers.net --recv-keys B4322F04D67658D8

VGA="$(lspci | grep VGA)"
case "$VGA" in
*AMD*)
    $install_packages --noconfirm corectrl
    ;;
*NVIDIA*)
    $install_packages --noconfirm nvidia-settings
    ;;
*)
    echo "Unknown graphics card."
    ;;
esac

$remove_packages manjaro-pulse pulseaudio-equalizer pulseaudio-zeroconf

yes | $install_packages $(cat $source_dir/packages/*)

sudo ln -s /usr/bin/helix /usr/bin/hx

##############
### Config ###
##############
mkdir -p $HOME/.config $HOME/.local "$HOME/.local/share/Steam/steamapps/common/Counter-Strike Global Offensive/csgo/"{cfg,resource}
stow home -t $HOME -R -d $config_dir --adopt

sudo stow etc -t /etc -R -d $config_dir --adopt

cat "$config_dir/gnome-settings.ini" | dconf load /
sudo -u gdm dbus-launch gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'

sudo gpasswd -a $USER docker

################
### Services ###
################
systemctl --now enable --user pipewire-pulse.service

sudo systemctl --now enable docker.service

systemctl --now enable --user randwall.service
