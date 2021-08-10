#!/bin/bash

is_amazon="$(cat /etc/os-release | grep amzn)"
if [ ! "$is_amazon" ]; then
    echo "Not Amazon Linux. Skipping package installation."
    exit 0
fi

source_dir=$(dirname "$(readlink -f "$0")")

sudo yum update -y

sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

sudo yum install -y $(cat $source_dir/packages/base)
