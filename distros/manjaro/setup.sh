#!/bin/bash

is_manjaro="$(cat /etc/os-release | grep manjaro)"
if [ ! "$is_manjaro" ]; then
    echo "Not Manjaro. Skipping package installation."
    exit 0
fi

source_dir=$(dirname "$(readlink -f "$0")")

sudo pacman -Syu --needed --noconfirm yay

install_packages="yay -Syu --needed --noeditmenu --nodiffmenu --noconfirm --sudoloop"
remove_packages="yay -Rs --noconfirm"

gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 8FD3D9A8D3800305A9FFF259D1742AD60D811D58
gpg --keyserver pool.sks-keyservers.net --recv-keys B4322F04D67658D8

VGA="$(lspci | grep VGA)"
case "$VGA" in
*AMD*)
    $install_packages corectrl
    ;;
*NVIDIA*)
    $install_packages nvidia-settings
    ;;
*)
    echo "Unknown graphics card."
    ;;
esac

$remove_packages vi
$install_packages $(cat $source_dir/packages/*)

sudo archlinux-java set java-8-openjdk/jre
