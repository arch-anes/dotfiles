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

################
### Packages ###
################
sudo pacman -Syu --needed --noconfirm yay

# Spotigy GPG
curl -sS https://download.spotify.com/debian/pubkey_6224F9941A8AA6D1.gpg  | gpg --import -

VGA="$(lspci | grep VGA)"
case "$VGA" in
*AMD*)
    video_package=corectrl
    ;;
*NVIDIA*)
    video_package=nvidia-settings
    ;;
*)
    video_package=""
    echo "Unknown graphics card."
    ;;
esac

yes | yay -Syu --needed --editmenu=false --diffmenu=false --cleanmenu=false --sudoloop $video_package $(cat $source_dir/packages/*)

##############
### Config ###
##############
mkdir -p $HOME/.config $HOME/.local
stow home -t $HOME -R -d $config_dir

sudo stow etc -t /etc -R -d $config_dir

cat "$config_dir/gnome-settings.ini" | dconf load /
sudo -u gdm dbus-launch gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'

sudo gpasswd -a $USER docker

################
### Services ###
################
sudo systemctl --now enable docker.service

systemctl --now enable --user randwall.service

systemctl --now enable --user pipewire-pulse
