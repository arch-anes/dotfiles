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

# Weather
set -xg DARKSKY_API_KEY (cat $HOME/weather.key)

# Locale
set locale en_US.UTF-8
set -xg TZ "America/Montreal"
set -xg LANG $locale
set -xg LANGUAGE $locale
set -xg LC_COLLATE C
set -xg LC_ALL $locale
set -xg LC_CTYPE $locale

# QEMU
set -xg QEMU_AUDIO_DRV pa

if test "$XDG_VTNR" = 1
    set -xg USE_WAYLAND 1

    set -xg _JAVA_AWT_WM_NONREPARENTING 1
    set -xg MOZ_ENABLE_WAYLAND 1
    # set -xg GDK_BACKEND wayland
    set -xg QT_QPA_PLATFORM wayland
    set -xg XDG_CURRENT_DESKTOP Unity
else if test "$XDG_VTNR" = 2
    set -xg USE_X11 1

    set -xg SDL_VIDEO_X11_DGAMOUSE 0
end
