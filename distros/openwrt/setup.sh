#!/bin/bash

############
### Vars ###
############
is_ubuntu="$(cat /etc/os-release | grep openwrt)"
if [ ! "$is_ubuntu" ]; then
    echo "Not OpenWRT. Skipping package installation."
    exit 0
fi

source_dir=$(dirname "$(readlink -f "$0")")

################
### Packages ###
################
opkg update && opkg install $(cat $source_dir/packages/base)
