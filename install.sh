#!/bin/bash

[ "$(cat /etc/os-release | grep amzn)" ] && sudo yum install -y unzip
[ "$(cat /etc/os-release | grep manjaro)" ] && sudo pacman -Syu --needed --noconfirm unzip
[ "$(cat /etc/os-release | grep ubuntu)" ] && sudo apt update && sudo apt install -y unzip

config_dir="$HOME/.config"
mkdir -p $config_dir
pushd $config_dir
curl https://codeload.github.com/arch-anes/dotfiles/zip/master -so dotfiles-master.zip
unzip -qo dotfiles-master.zip
rm -f dotfiles-master.zip

pushd dotfiles-master
./setup.sh
