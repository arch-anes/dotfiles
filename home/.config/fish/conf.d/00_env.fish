# Go
set -xg PATH $PATH $HOME/go/bin

# Android
set -xg ANDROID_HOME $HOME/Android/Sdk
set -xg PATH $PATH $ANDROID_HOME/tools
set -xg PATH $PATH $ANDROID_HOME/platform-tools

# .NET
set -xg DOTNET_CLI_TELEMETRY_OPTOUT 1
set -xg DOTNET_ROOT /opt/dotnet
set -xg PATH $PATH $HOME/.dotnet/tools

# Vim
set -xg SPACEVIMDIR $HOME/.config/spacevim/
set -xg PATH $PATH $HOME/.SpaceVim/bin
set -xg VISUAL nvim
set -xg EDITOR nvim

# Node
set -xg CHROME_BIN chromium
set -xg PATH $PATH $HOME/.yarn/bin

# QEMU
set -xg QEMU_AUDIO_DRV pa
