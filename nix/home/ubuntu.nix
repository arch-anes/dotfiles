{ lib, pkgs, dotfilesPath, ... }:
{
  home.activation.ubuntuSetup = lib.hm.dag.entryAfter ["writeBoundary" "linuxSetup"] ''
    if [ -z "''${SKIP_INSTALL:-}" ]; then
      export DEBIAN_FRONTEND=noninteractive
      sudo -E apt update && sudo -E apt upgrade -y
      sudo -E apt install -y $(cat "${dotfilesPath}/distros/ubuntu/packages/ubuntu")

      NONINTERACTIVE=1 bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
      brew install $(cat "${dotfilesPath}/distros/ubuntu/packages/brew")
      sudo ln -sf /home/linuxbrew/.linuxbrew/bin/fish /usr/bin/fish
    fi

    sudo ${pkgs.stow}/bin/stow etc -t /etc -R -d "${dotfilesPath}/distros/ubuntu/config"

    if [ ! -e /.dockerenv ]; then
      sudo systemctl --now enable zfs-load-key.service
    fi
  '';
}
