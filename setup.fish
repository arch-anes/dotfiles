#!/usr/bin/fish

set source_dir (dirname (readlink -m (status --current-filename)))

############
### Vars ###
############
set enable_services sudo systemctl --now enable
set install_packages yay -Syu --needed --noeditmenu --nodiffmenu --noconfirm --sudoloop

set is_arch_based type -q pacman
set has_head test -n "$DISPLAY"

################
### Packages ###
################
if $is_arch_based
    sudo pacman -Syu --needed --noconfirm yay

    $install_packages (cat $source_dir/packages/base)

    if $has_head
        curl -sS https://download.spotify.com/debian/pubkey.gpg | gpg --import -

        $install_packages (cat $source_dir/packages/gui  $source_dir/packages/dev)

        set VGA (lspci | grep VGA)
        switch $VGA
            case "*AMD*"
                $install_packages amdgpu-fan radeon-profile-daemon-git amdvlk lib32-mesa vulkan-radeon lib32-vulkan-radeon vulkan-icd-loader lib32-vulkan-icd-loader
                $enable_services amdgpu-fan.service radeon-profile-daemon.service
            case "*NVIDIA*"
                $install_packages nvidia nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings vulkan-icd-loader lib32-vulkan-icd-loader
            case '*'
                echo -n "Unknown graphics card"
        end
    end
end

###########
### Git ###
###########
stow hooks -t $source_dir/.git/hooks -R -d $source_dir
git -C $source_dir submodule update --init --recursive
curl -sLf https://raw.githubusercontent.com/ngerakines/commitment/master/commit_messages.txt -o $HOME/.cache/commit_messages.txt

#############
### Shell ###
#############
chsh -s /usr/bin/fish

if test -e "$HOME/.local/share/omf"
    omf update
else
    curl -L https://get.oh-my.fish | fish
end
omf install

##############
### Config ###
##############
sudo rm -rf /etc/ssh/sshd_config
set CONFIG_DIR $HOME/.config
rm -rf $CONFIG_DIR/fish
mkdir -p $HOME/.ssh

stow csgo -t "$HOME/.local/share/Steam/steamapps/common/Counter-Strike Global Offensive/csgo" -R -d $source_dir ^/dev/null >/dev/null
stow home -t $HOME -R -d $source_dir
sudo stow etc -t /etc -R -d $source_dir

cat $source_dir/gnome-settings.ini | dconf load /

################
### Services ###
################
sudo gpasswd -a $USER docker
$enable_services docker.service

$enable_services sshd.service

if $has_head
    $enable_services syncthing@$USER.service
    $enable_services --user onedrive.service
end

sudo ufw limit ssh
yes | sudo ufw enable

################
### Spacevim ###
################
set spacevim "$HOME/.SpaceVim"
if test -e $spacevim
    git -C $spacevim pull
else
    curl -sLf https://spacevim.org/install.sh | bash
end
