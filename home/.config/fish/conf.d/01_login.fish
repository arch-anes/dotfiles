if status --is-login
    gnome-keyring-daemon --start --components=pkcs11,secrets,ssh
end
