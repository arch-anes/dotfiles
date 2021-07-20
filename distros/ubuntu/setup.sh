#!/bin/bash

is_ubuntu="$(cat /etc/os-release | grep ubuntu)"
if [ ! "$is_ubuntu" ]; then
    echo "Not Ubuntu. Skipping package installation."
    exit 0
fi

source_dir=$(dirname "$(readlink -f "$0")")

sudo apt update && sudo apt upgrade -y

sudo apt-key adv --refresh-keys --keyserver keyserver.ubuntu.com

sudo apt update && sudo apt install -y $(cat $source_dir/packages/base)
sudo pip3 install thefuck

sudo mkdir -p /usr/lib/ssh/
sudo ln -nfs /usr/lib/openssh/sftp-server /usr/lib/ssh/sftp-server

### Docker
is_in_docker=$(awk -F/ '$2 == "docker"' /proc/self/cgroup)
if [ "$is_in_docker" ]; then
    echo "Inside a Docker container. Skipping Docker package installation."
    exit 0
fi

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88

ARCH=$(arch)
case "$ARCH" in
x86_64)
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    ;;
aarch64)
    sudo add-apt-repository "deb [arch=arm64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    ;;
armv7l)
    sudo add-apt-repository "deb [arch=armhf] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    ;;
*)
    echo "Unknown architecture."
    ;;
esac

sudo apt update && sudo apt install -y $(cat $source_dir/packages/docker)

curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
