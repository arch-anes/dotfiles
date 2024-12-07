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

yay -Rs --noconfirm firewalld

# Spotigy GPG
curl -sS https://download.spotify.com/debian/pubkey_6224F9941A8AA6D1.gpg  | gpg --import -

VGA="$(lspci | grep VGA)"
case "$VGA" in
*AMD*)
    video_packages="corectrl vulkan-radeon lib32-vulkan-radeon amdgpu_top-bin"
    ;;
*NVIDIA*)
    video_packages="nvidia-settings nvidia-utils lib32-nvidia-utils"
    ;;
*)
    video_packages=""
    echo "Unknown graphics card."
    ;;
esac

yes | yay -Syu --needed --editmenu=false --diffmenu=false --cleanmenu=false --removemake --sudoloop $video_packages $(cat $source_dir/packages/*)

##############
### Config ###
##############
mkdir -p $HOME/.config $HOME/.local
stow home -t $HOME -R -d $config_dir

sudo stow etc -t /etc -R -d $config_dir

cat "$config_dir/gnome-settings.ini" | dconf load /
sudo -u gdm dbus-launch gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'

sudo gpasswd -a $USER docker

is_endeavour="$(cat /etc/os-release | grep endeavouros)"
if [ "$is_endeavour" ]; then
    # Fix for https://forum.endeavouros.com/t/fix-for-having-to-enter-password-twice-when-booting-with-encrypted-swap-partition/39122
    sudo rm -f /etc/dracut.conf.d/calamares-luks.conf 
    sudo reinstall-kernels
fi

################
### Services ###
################
sudo systemctl disable --now NetworkManager-wait-online.service

sudo systemctl --now enable docker.service
sudo systemctl --now enable cronie.service
sudo systemctl --now enable bluetooth.service
sudo systemctl enable linux-modules-cleanup.service

systemctl --now enable --user randwall.service
systemctl --now enable --user pipewire-pulse
systemctl --now enable --user gcr-ssh-agent.socket

################
### Firewall ###
################
sudo ufw allow 12034 comment rquickshare
