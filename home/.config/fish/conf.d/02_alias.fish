# Arch Linux
alias add-key='gpg --recv-keys'
alias cleanup='yay -Yc && yay -Sc'
alias fulllistpkg='expac --timefmt="%Y-%m-%d %T" "%l  %w\t%-20n\t%10d" (pacman -Qq) | sort -n'
alias fix-pacman-db='sudo rm /var/lib/pacman/db.lck'
alias listpkg='expac --timefmt="%Y-%m-%d %T" "%l  %w\t%-20n\t%10d" (comm -23 (pacman -Qq | sort | psub) (pacman -Qqg base base-devel xorg xorg-apps | sort | psub)) | sort -n'
alias rankmirrors-top="curl -s 'https://www.archlinux.org/mirrorlist/?country=CA&country=US&use_mirror_status=on' | sed -e 's/^#Server/Server/' -e '/^#/d' | rankmirrors -n 10 - | sudo tee /etc/pacman.d/mirrorlist"
alias remove='yay -Rsn'
alias update='yay -Syu --needed --noeditmenu --nodiffmenu'
alias updatel='update --ignore=linux-lts,linux-lts-headers,linux,linux-headers' 

# Git
alias swag='gaa && yolo && gl && gp'
alias yolo='gc -m (shuf -n 1 $HOME/.cache/commit_messages.txt)'

# Embedded dev
alias listports='dmesg | grep tty'
alias pcbcom='picocom /dev/ttyACM0 -b 921600 --imap lfcrlf'
alias microscope='mpv av://v4l2:/dev/v4l/by-id/usb-GenesysLogic_Technology_Co.__Ltd._USB2.0_UVC_PC_Camera-video-index0'

# Other
alias broken-ln='find -xtype l -print'
alias btc='bluetoothctl'
alias docker-prune='docker system prune --all --volumes'
alias id-key='xev | awk -F'"'"'[ )]+'"'"' '"'"'/^KeyPress/ { a[NR+2] } NR in a { printf "%-3s %s\n", $5, $8 }'"'"
alias fixradio='sudo rfkill unblock all'
alias listmon='swaymsg -t get_outputs'
alias lvl='echo $SHLVL'
alias music='mpc update && ncmpcpp'
alias unmount='udiskie-umount'
alias update-node='yarn global upgrade'

alias e='emacsclient -nw'
alias ee='emacs -nw'
alias du='du -h'
alias df='df -h'
alias ls='ls -A'
alias rm='rm -i'
alias lspci='lspci -nnk'

alias :q="exit"
