set -xg CACHE "$HOME/.cache"
set -xg ANDROID_HOME $HOME/Android/Sdk

# PATH 
set -xg PATH $PATH $HOME/.SpaceVim/bin

set -xg PATH $PATH $HOME/go/bin

set -xg PATH $PATH $HOME/.yarn/bin

set -xg PATH $PATH $HOME/.dotnet/tools

set -xg PATH $PATH $ANDROID_HOME/tools
set -xg PATH $PATH $ANDROID_HOME/platform-tools

# dotnet
set -xg DOTNET_CLI_TELEMETRY_OPTOUT 1
set -xg DOTNET_ROOT /opt/dotnet

# Vim
set -xg SPACEVIMDIR $HOME/.config/spacevim/

# Misc
set -xg TZ "America/Montreal"
set -xg VISUAL "nvim"
set -xg EDITOR "nvim"
set -xg TERM "xterm"
set -xg CHROME_BIN "chromium"

set -xg LANG en_US.UTF-8
set -xg LANGUAGE en_US.UTF-8
set -xg LC_COLLATE C
set -xg LC_CTYPE en_US.UTF-8

set -xg QEMU_AUDIO_DRV pa
set -xg SDL_VIDEO_X11_DGAMOUSE 0

set -xg _JAVA_AWT_WM_NONREPARENTING 1

