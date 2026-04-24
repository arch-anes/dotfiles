{ config, lib, dotfilesPath, user, pkgs, ... }:
let
  linkDir = src: fsPath:
    builtins.listToAttrs (map (file:
      let rel = lib.removePrefix (toString src + "/") (toString file);
      in { name = rel; value.source = config.lib.file.mkOutOfStoreSymlink "${fsPath}/${rel}"; }
    ) (lib.filesystem.listFilesRecursive src));
in {
  home.username = user;
  home.homeDirectory = lib.mkDefault "/home/${user}";
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

  home.file = linkDir ./../../global/config/home "${dotfilesPath}/global/config/home";

  home.packages = with pkgs; [
    bat
    btop
    duf
    dust
    fzf
    git-lfs
    helix
    jq
    lazydocker
    lazygit
    neovim
    nnn
    ripgrep
    starship
    tmux
    zoxide
  ];

  home.activation.commonSetup = lib.hm.dag.entryAfter ["writeBoundary"] ''
    # Trigger fisher plugin installation once fish is available
    command -v fish &>/dev/null && fish -l -c "exit"

    # nnn plugins
    rm -rf "$HOME/.config/nnn/plugins"
    sh -c "$(curl -Ls https://raw.githubusercontent.com/jarun/nnn/master/plugins/getplugs)"

    # NvChad (first install only)
    if [ ! -d "$HOME/.config/nvim/.git" ]; then
      rm -rf "$HOME/.local/share/nvim" "$HOME/.config/nvim"
      git clone https://github.com/NvChad/starter "$HOME/.config/nvim" --single-branch
    fi
  '';
}
