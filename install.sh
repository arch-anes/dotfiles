#!/bin/bash
set -e

if [[ "$(uname -s)" == "Darwin" ]]; then
    hm_config="macos"
elif grep -qi 'ID_LIKE=.*arch' /etc/os-release 2>/dev/null; then
    hm_config="arch"
elif grep -qi ubuntu /etc/os-release 2>/dev/null; then
    hm_config="ubuntu"
else
    echo "Unsupported distro"
    exit 1
fi

if ! command -v nix &>/dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
    # shellcheck disable=SC1091
    . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi

dotfiles_dir="$HOME/.config/dotfiles"
if [ ! -d "$dotfiles_dir" ]; then
    git clone https://github.com/arch-anes/dotfiles "$dotfiles_dir"
fi

nix run home-manager/master -- switch --flake "${dotfiles_dir}#${hm_config}"
