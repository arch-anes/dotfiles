###########
### ENV ###
###########

# Fish
set -xg fish_prompt_pwd_dir_length 0

# Go
set -xg PATH $PATH $HOME/go/bin

# Dotnet
set -xg PATH $PATH $HOME/.dotnet/tools
set -xg DOTNET_CLI_TELEMETRY_OPTOUT 1

# Android
set -xg ANDROID_HOME $HOME/Android/Sdk
set -xg PATH $PATH $ANDROID_HOME/tools
set -xg PATH $PATH $ANDROID_HOME/platform-tools

# Flutter & Dart
set -xg PATH $PATH $HOME/.pub-cache/bin
set -xg CHROME_EXECUTABLE chromium

# Editor
set -xg VISUAL helix
set -xg EDITOR helix

# Node
set -xg CHROME_BIN chromium
set -xg PATH $PATH $HOME/.yarn/bin

# Snap
set -xg PATH $PATH /snap/bin

#  webinstall.dev
set -xg PATH $PATH $HOME/.local/bin

# QEMU
set -xg QEMU_AUDIO_DRV pa

# nnn
set -xg NNN_BMS "d:$HOME/Documents;D:$HOME/Downloads;c:$HOME/.config;g:$HOME/Documents/git;n:$HOME/Documents/Nextcloud"

###############
### Aliases ###
###############

set is_linux (uname -s | grep Linux)
set is_macos (uname -s | grep Darwin)

if test -n "$is_linux"
    # Arch Linux
    set is_arch_based (cat /etc/os-release | grep arch)
    if test -n "$is_arch_based"
        alias cleanup='yay -Yc && yay -Scc'
        alias fix-pacman-db='sudo rm /var/lib/pacman/db.lck'
        alias gensrcinfo='makepkg --printsrcinfo > .SRCINFO'
        alias listpkg='expac --timefmt="%Y-%m-%d %T" "%l  %w\t%-20n\t%10d" (pacman -Qq) | sort -n'
        alias remove='yay -Rsn'
        alias update='yay -Y --gendb && yay -Syu --devel --needed --noeditmenu --nodiffmenu --sudoloop'
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
    alias update='brew update'
    alias install='brew install'
end

# dotfiles
alias update-dotfiles='curl -L https://raw.githubusercontent.com/arch-anes/dotfiles/master/install.sh | bash'

# Git
alias yolo='git commit -m (shuf -n 1 $HOME/.cache/commit_messages.txt)'
alias swag='git add --all && yolo && git pull && git push'
alias find-git-repos="find . -type d -exec test -e '{}/.git' ';' -print -prune"

# nnn
alias n='nnn -dHQexTe'
alias vifm='n'

# Other
alias broken-ln='find -xtype l -print'
alias docker-prune='docker system prune --all --volumes'
alias lvl='echo $SHLVL'
alias sort-dir='find . -type f ! -path \'*/.git/*\' -exec sort -o {} {} \;'
alias watchdir='inotifywait -r -m . --format "%w%f %e"'
alias list-ports='sudo netstat -tulpn'
alias bootstrap-python='python -m venv .venv && source .venv/bin/activate.fish && pip install -r requirements.txt'
alias fix-fn-keys='sudo rtcwake -m mem -s 2'

alias du='du -h'
alias df='df -h'
alias ls='ls -A'
alias rm='rm -i'
alias lspci='lspci -nnk'

alias :q="exit"
