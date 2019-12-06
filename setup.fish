#!/usr/bin/fish

set source_dir (dirname (readlink -m (status --current-filename)))

# Git
stow hooks -t $source_dir/.git/hooks -R -d $source_dir
git -C $source_dir submodule update --init --recursive
curl -sLf https://raw.githubusercontent.com/ngerakines/commitment/master/commit_messages.txt -o $HOME/.cache/commit_messages.txt

# Pre-setup
sudo rm -rf /etc/ssh/sshd_config
set CONFIG_DIR $HOME/.config
rm -rf $CONFIG_DIR/mimeapps.list
rm -rf $CONFIG_DIR/fish
mkdir -p $HOME/.ssh

# Symlinks
stow csgo -t "/games/SteamLibrary/steamapps/common/Counter-Strike Global Offensive/csgo" -R -d $source_dir ^/dev/null >/dev/null
stow home -t $HOME -R -d $source_dir
sudo stow etc -t /etc -R -d $source_dir
sudo stow scripts -t /usr/local/bin -R -d $source_dir

sudo ln -nfs /usr/bin/nvim /usr/bin/vim

# GTK
gsettings set org.gnome.desktop.interface gtk-theme 'Arc-Darker'  
gsettings set org.gnome.desktop.interface icon-theme 'Arc'

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
