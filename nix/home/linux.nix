{ lib, pkgs, dotfilesPath, user, ... }:
{
  home.activation.linuxSetup = lib.hm.dag.entryAfter ["writeBoundary"] ''
    sudo rm -f /etc/apcupsd/apcupsd.conf
    sudo ${pkgs.stow}/bin/stow etc -t /etc -R -d "${dotfilesPath}/global/config"

    sudo chsh ${user} -s "$(which fish)"

    if [ ! -e /.dockerenv ]; then
      sudo systemctl --now enable sshd.service || true
      sudo systemctl --now enable ssh.service  || true
      sudo ufw allow ssh
      yes | sudo ufw enable
    fi
  '';
}
