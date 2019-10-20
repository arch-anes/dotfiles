if status --is-login
  gnome-keyring-daemon --start --components=pkcs11,secrets,ssh

  if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
    exec ssh-agent sway
  end
end
