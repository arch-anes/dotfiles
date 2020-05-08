#!/usr/bin/fish

set source_dir (dirname (readlink -m (status --current-filename)))

set enable_services systemctl --now enable
set install_packages yay -Syu --needed --noeditmenu --nodiffmenu --noconfirm

# Git
stow hooks -t $source_dir/.git/hooks -R -d $source_dir
git -C $source_dir submodule update --init --recursive
curl -sLf https://raw.githubusercontent.com/ngerakines/commitment/master/commit_messages.txt -o $HOME/.cache/commit_messages.txt

# Packages

sudo pacman -Syu --needed --noconfirm yay

$install_packages (cat packages/*)

set VGA (lspci | grep VGA)
switch $VGA
    case "*AMD*"
        $install_packages amdgpu-fan radeon-profile-daemon-git
        $enable_services amdgpu-fan.service radeon-profile-daemon.service
    case "*NVIDIA*"
        $install_packages nvidia nvidia-utils lib32-nvidia-utils nvidia-settings
    case '*'
        echo -n "Unknown graphics card"
end

# Shell

chsh -s /usr/bin/fish 

# Symlinks

sudo rm -rf /etc/ssh/sshd_config
set CONFIG_DIR $HOME/.config
rm -rf $CONFIG_DIR/fish
mkdir -p $HOME/.ssh

stow csgo -t "$HOME/.local/share/Steam/steamapps/common/Counter-Strike Global Offensive/csgo" -R -d $source_dir ^/dev/null >/dev/null
stow home -t $HOME -R -d $source_dir
sudo stow etc -t /etc -R -d $source_dir
sudo stow scripts -t /usr/local/bin -R -d $source_dir

# Services

$enable_services syncthing@$USER.service
$enable_services docker.service
$enable_services --user onedrive.service

sudo ufw enable

sudo gpasswd -a $USER docker

# Spacevim
set spacevim "$HOME/.SpaceVim"
if test -e $spacevim
    git -C $spacevim pull
else
    curl -sLf https://spacevim.org/install.sh | bash
end

# Spacemacs
set spacemacs "$HOME/.emacs.d"
if test -e $spacemacs
    git -C $spacemacs pull
else
    git clone https://github.com/syl20bnr/spacemacs $spacemacs
    systemctl --user enable emacs
end

# OMF
if test -e "$HOME/.local/share/omf"
    omf update
else
    curl -L https://get.oh-my.fish | fish
end
omf install
