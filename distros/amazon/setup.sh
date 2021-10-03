#!/bin/bash

############
### Vars ###
############
is_amazon="$(cat /etc/os-release | grep amzn)"
if [ ! "$is_amazon" ]; then
    echo "Not Amazon Linux. Skipping package installation."
    exit 0
fi

source_dir=$(dirname "$(readlink -f "$0")")

################
### Packages ###
################
sudo yum update -y

sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

sudo yum-config-manager --add-repo https://download.opensuse.org/repositories/shells:fish:release:3/CentOS_8/shells:fish:release:3.repo

sudo yum install -y $(cat $source_dir/packages/base)

sudo pip3 install thefuck
