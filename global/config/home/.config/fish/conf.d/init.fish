###########
### ENV ###
###########

# Fish
set -xg fish_prompt_pwd_dir_length 0
set -xg fish_greeting ""

# Go
fish_add_path -a $HOME/go/bin

# Dotnet
fish_add_path -a $HOME/.dotnet/tools
set -xg DOTNET_CLI_TELEMETRY_OPTOUT 1

# Android
set -xg ANDROID_HOME $HOME/Android/Sdk
fish_add_path -a $ANDROID_HOME/tools
fish_add_path -a $ANDROID_HOME/platform-tools

# Flutter & Dart
fish_add_path -a $HOME/.pub-cache/bin
set -xg CHROME_EXECUTABLE chromium

# Editor
set -xg VISUAL nvim
set -xg EDITOR nvim

# Node
set -xg CHROME_BIN chromium
fish_add_path -a $HOME/.yarn/bin

# Rust
fish_add_path -a $HOME/.cargo/bin

# Snap
fish_add_path -a /snap/bin

# pipx
fish_add_path -a $HOME/.local/bin

# QEMU
set -xg QEMU_AUDIO_DRV pa

# nnn
set -xg NNN_BMS "d:$HOME/Documents;D:$HOME/Downloads;c:$HOME/.config;g:$HOME/Documents/git;n:$HOME/Documents/Nextcloud"
set -xg NNN_PLUG 'p:preview-tui;d:diffs;r:gitroot;e:suedit'

set is_linux (uname -s | grep Linux)
set is_macos (uname -s | grep Darwin)

###############
### Aliases ###
###############

if test -n "$is_linux"
    # Arch Linux
    set is_arch_based (cat /etc/os-release | grep arch)
    if test -n "$is_arch_based"
        # https://wiki.archlinux.org/title/KDE_Wallet#Using_the_KDE_Wallet_to_store_ssh_key_passphrases
        set -xg SSH_ASKPASS_REQUIRE prefer
        set -xg SSH_ASKPASS /usr/bin/ksshaskpass

        alias cleanup='yay -Yc && yay -Scc'
        alias fix-pacman-db='sudo rm /var/lib/pacman/db.lck'
        alias gensrcinfo='makepkg --printsrcinfo > .SRCINFO'
        alias listpkg='expac --timefmt="%Y-%m-%d %T" "%l  %w\t%-20n\t%10d" (pacman -Qq) | sort -n'
        alias remove='yay -Rsn'
        alias update='yay -Y --gendb && yay -Syu --devel --needed --removemake --editmenu=false --diffmenu=false --sudoloop'
        alias install='update'
    end

    # Debian
    set is_debian_based (cat /etc/os-release | grep debian)
    if test -n "$is_debian_based"
        alias cleanup='sudo apt autoremove --purge'
        alias listpkg='apt list --installed'
        alias remove='sudo apt remove'
        alias update='sudo apt update && sudo apt upgrade'
        alias install='sudo apt update && sudo apt install'
    end
end

if test -n "$is_macos"
    alias cleanup='brew cleanup --prune=all'
    alias listpkg='brew list'
    alias remove='brew uninstall'
    alias update='brew update && brew upgrade'
    alias install='brew install'
end

# dotfiles
alias update-dotfiles='curl -L https://raw.githubusercontent.com/arch-anes/dotfiles/master/install.sh | bash'

# Git
alias find-git-repos="find -type d -exec test -e '{}/.git' ';' -print -prune -path"
abbr -a lzg lazygit

# Docker 
abbr -a lzd lazydocker

# nnn
alias n='nnn -adHQexTePp'

# Other
alias broken-ln='find -xtype l -print'
alias lvl='echo $SHLVL'
alias sortdir='find -type f ! -path "*/.git/*" -exec sort -o {} {} \; -path'
alias watchdir='inotifywait -r -m --format "%w%f %e"'
alias lsprt='sudo netstat -tulpn'
alias dspses="echo $XDG_SESSION_TYPE"

alias bootstrap-venv='python -m venv .venv --system-site-packages && source .venv/bin/activate.fish'
abbr -a bv bootstrap-venv
alias bootstrap-python-requirements='bootstrap-venv && pip install -r requirements.txt'
abbr -a bpr bootstrap-python-requirements
alias bootstrap-pyproject='bootstrap-venv && pip install -e .[dev]'
abbr -a bpp bootstrap-pyproject

# System utilities
abbr -a du dust
abbr -a df duf
alias less='less -R'
alias ls='ls -A'
alias rm='rm -i'
alias lspci='lspci -nnk'

alias :q="exit"

#################
### Functions ###
#################

function rcam -d "Remotely connect to a webcam via SSH"
    # source: https://unix.stackexchange.com/a/117352
    ssh $argv[1] ffmpeg -an -f video4linux2 -s 1920x1080 -i /dev/video0 -r 10 -b:v 500k -f matroska -loglevel warning - | ffplay -f matroska /dev/stdin -loglevel warning
end

###############
### Init ###
###############
if type -q /home/linuxbrew/.linuxbrew/bin/brew
    eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv fish)
end

if status --is-login
    # Check if fisher has 0 plugins or 1 plugin (fisher itself)
    if type -q fisher; and test (fisher list | wc -l) -eq 0 -o (fisher list | wc -l) -eq 1
        fisher install jorgebucaran/fisher jhillyerd/plugin-git franciscolourenco/done gazorby/fish-abbreviation-tips
    end
end

if type -q starship
    starship init fish | source
end

if type -q fzf
    fzf --fish | source
end

if type -q zoxide
    zoxide init fish | source
    abbr -a cd z
end
