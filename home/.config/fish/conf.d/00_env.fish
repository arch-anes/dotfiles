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

# Vim
set -xg SPACEVIMDIR $HOME/.config/spacevim/
set -xg PATH $PATH $HOME/.SpaceVim/bin
set -xg VISUAL nvim
set -xg EDITOR nvim

# Node
set -xg CHROME_BIN chromium
set -xg PATH $PATH $HOME/.yarn/bin

# Snap
set -xg PATH $PATH /snap/bin

# QEMU
set -xg QEMU_AUDIO_DRV pa
