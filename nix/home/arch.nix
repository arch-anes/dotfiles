{ config, lib, pkgs, dotfilesPath, ... }:
let
  linkDir = src: fsPath:
    builtins.listToAttrs (map (file:
      let rel = lib.removePrefix (toString src + "/") (toString file);
      in { name = rel; value.source = config.lib.file.mkOutOfStoreSymlink "${fsPath}/${rel}"; }
    ) (lib.filesystem.listFilesRecursive src));
in {
  home.file = linkDir ./../../distros/arch/config/home "${dotfilesPath}/distros/arch/config/home";

  home.activation.archSetup = lib.hm.dag.entryAfter ["writeBoundary" "linuxSetup"] ''
    if [ -z "''${SKIP_INSTALL:-}" ]; then
      sudo pacman -Syu --needed --noconfirm yay
      yay -Rs --noconfirm firewalld 2>/dev/null || true
      curl -sS https://download.spotify.com/debian/pubkey_6224F9941A8AA6D1.gpg | gpg --import -

      VGA=$(lspci | grep VGA)
      case "$VGA" in
        *AMD*)    video_packages="corectrl vulkan-radeon lib32-vulkan-radeon amdgpu_top nvtop" ;;
        *NVIDIA*) video_packages="nvidia-settings nvidia-utils lib32-nvidia-utils nvtop" ;;
        *)        video_packages="nvtop" ;;
      esac

      yes | yay -Syu --needed --editmenu=false --diffmenu=false --cleanmenu=false --removemake --sudoloop \
        $video_packages $(cat "${dotfilesPath}/distros/arch/packages/"*)
    fi

    sudo ${pkgs.stow}/bin/stow etc -t /etc -R -d "${dotfilesPath}/distros/arch/config"

    sudo gpasswd -a "$USER" docker  || true
    sudo gpasswd -a "$USER" plugdev || true

    sudo ufw allow 1714:1764/udp comment "KDE Connect"
    sudo ufw allow 1714:1764/tcp comment "KDE Connect"

    sudo systemctl disable --now NetworkManager-wait-online.service || true
    sudo systemctl --now enable docker.service
    sudo systemctl --now enable cups.service
    sudo systemctl --now enable cronie.service
    sudo systemctl --now enable bluetooth.service
    sudo systemctl --now enable paccache.timer
    sudo systemctl enable linux-modules-cleanup.service

    systemctl --now enable --user randwall.service
    systemctl --now enable --user pipewire-pulse
    systemctl --now enable --user gcr-ssh-agent.socket
  '';
}
