#!/bin/bash

grep -q 'ID_LIKE.*arch' /etc/os-release 2>/dev/null && sudo pacman -Syu --needed --noconfirm unzip
grep -q ubuntu /etc/os-release 2>/dev/null && sudo apt update && sudo apt install -y unzip

config_dir="$HOME/.config"
mkdir -p "$config_dir"
pushd "$config_dir" >/dev/null || exit

curl -fsSL https://codeload.github.com/arch-anes/dotfiles/zip/master -o dotfiles-master.zip
unzip -qo dotfiles-master.zip
rm -f dotfiles-master.zip

pushd dotfiles-master >/dev/null || exit

./setup.sh

popd >/dev/null || exit
popd >/dev/null || exit
