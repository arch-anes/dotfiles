#!/bin/bash

############
### Vars ###
############
is_arch="$(cat /etc/os-release | grep ID_LIKE | grep arch)"
if [ ! "$is_arch" ]; then
    echo "Not Arch-like. Skipping package installation."
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
    video_packages="corectrl amdvlk lib32-amdvlk vulkan-radeon lib32-vulkan-radeon"
    ;;
*NVIDIA*)
    video_packages="nvidia-settings nvidia-utils lib32-nvidia-utils"
    ;;
*)
    video_packages=""
    echo "Unknown graphics card."
    ;;
esac

yes | yay -Syu --needed --editmenu=false --diffmenu=false --cleanmenu=false --sudoloop $video_packages $(cat $source_dir/packages/general/*)

is_manjaro="$(cat /etc/os-release | grep manjaro)"
if [ $is_manjaro ]; then
    yes | yay -Syu --needed --editmenu=false --diffmenu=false --cleanmenu=false --sudoloop $(cat $source_dir/packages/manjaro/*)
fi

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

################
### Firewall ###
################
sudo ufw allow 12034 comment rquickshare
