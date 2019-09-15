#!/usr/bin/fish

set source_dir (dirname (readlink -m (status --current-filename)))

# Git
git -C $source_dir submodule update --init --recursive
curl -sLf https://raw.githubusercontent.com/ngerakines/commitment/master/commit_messages.txt -o $HOME/.cache/commit_messages.txt

# Pre-setup
sudo rm -rf /etc/X11
sudo rm -rf /etc/ssh/sshd_config
set CONFIG_DIR $HOME/.config
rm -rf $CONFIG_DIR/mimeapps.list
rm -rf $CONFIG_DIR/fish
mkdir -p $HOME/.ssh

# Symlinks
stow csgo -t "/games/SteamLibrary/steamapps/common/Counter-Strike Global Offensive/csgo" -R -d $source_dir ^/dev/null >/dev/null
stow home -t $HOME -R -d $source_dir
stow hooks -t $source_dir/.git/hooks -R -d $source_dir
sudo stow etc -t /etc -R -d $source_dir
sudo stow scripts -t /usr/local/bin -R -d $source_dir

ln -nfs "$HOME/Documents/Syncthing/Music" "$HOME/Music"
sudo ln -nfs /usr/bin/nvim /usr/bin/vim

# Spacevim
set spacevim "$HOME/.SpaceVim"
if test -e $spacevim
    git -C $spacevim pull
else
    curl -sLf https://spacevim.org/install.sh | bash
end

# OMF
if test -e "$HOME/.local/share/omf"
    omf update
else
    curl -L https://get.oh-my.fish | fish
end
omf install

# GPU 
switch (lspci | grep VGA)
    case '*AMD*'
        set gpu amd
    case '*NVIDIA*'
        set gpu nvidia
    case '*Intel*'
        set gpu intel
    case '*'
        echo "Unrecognized GPU."
end

set xorg_conf $source_dir/etc/X11/xorg.conf.d
ln -nfs $xorg_conf/$gpu $xorg_conf/10-gpu.conf
