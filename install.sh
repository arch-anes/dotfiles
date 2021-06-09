#!/bin/bash

config_dir="$HOME/.config"
mkdir -p $config_dir
pushd $config_dir
curl https://codeload.github.com/arch-anes/dotfiles/zip/master -so dotfiles-master.zip
unzip -qo dotfiles-master.zip
rm -f dotfiles-master.zip

pushd dotfiles-master
./setup.sh
