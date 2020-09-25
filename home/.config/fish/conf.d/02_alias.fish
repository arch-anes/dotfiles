# Arch Linux
alias cleanup='yay -Yc && yay -Scc'
alias fix-pacman-db='sudo rm /var/lib/pacman/db.lck'
alias gensrcinfo='makepkg --printsrcinfo > .SRCINFO'
alias listpkg='expac --timefmt="%Y-%m-%d %T" "%l  %w\t%-20n\t%10d" (pacman -Qq) | sort -n'
alias remove='yay -Rsn'
alias update='yay -Syu --devel --needed --noeditmenu --nodiffmenu --sudoloop'

# Git
alias yolo='git commit -m (shuf -n 1 $HOME/.cache/commit_messages.txt)'
alias swag='git add --all && yolo && git pull && git push'

# Embedded dev
alias listports='dmesg | grep tty'
alias pcbcom='picocom /dev/ttyACM0 -b 921600 --imap lfcrlf'

# Other
alias broken-ln='find -xtype l -print'
alias docker-prune='docker system prune --all --volumes'
alias lvl='echo $SHLVL'
alias sort-dir='find . -type f ! -path \'*/.git/*\' -exec sort -o {} {} \;'
alias watchdir='inotifywait -r -m . --format "%w%f %e"'

alias du='du -h'
alias df='df -h'
alias ls='ls -A'
alias rm='rm -i'
alias lspci='lspci -nnk'

alias :q="exit"
