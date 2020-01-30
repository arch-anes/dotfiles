if status --is-login
    gnome-keyring-daemon --start --components=pkcs11,secrets,ssh

    if test -z "$DISPLAY"
        if test "$USE_WAYLAND" = 1
            exec ssh-agent sway
        else if test "$USE_X11" = 1
            exec ssh-agent startx -- -keeptty
        end
    end
end
