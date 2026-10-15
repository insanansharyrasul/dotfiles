--------------------------
--- Autostart applications
--------------------------

hl.on("hyprland.start", function()
    -- Raw
    hl.dispatch(hl.dsp.exec_raw("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"))
    hl.dispatch(hl.dsp.exec_raw("lxpolkit"))
    hl.dispatch(hl.dsp.exec_raw("swaync"))
    hl.dispatch(hl.dsp.exec_raw("kdeconnect-indicator"))
    hl.dispatch(hl.dsp.exec_raw("hypridle"))
    hl.dispatch(hl.dsp.exec_raw("gammastep -c ~/.config/gammastep/config.ini"))
    hl.dispatch(hl.dsp.exec_raw("/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh,gpg"))
    hl.dispatch(hl.dsp.exec_raw("bus-update-activation-environment --all"))
    hl.dispatch(hl.dsp.exec_raw("gsettings set org.gnome.desktop.interface gtk-theme 'ayu-dark'"))
    hl.dispatch(hl.dsp.exec_raw("gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'"))
    hl.dispatch(hl.dsp.exec_raw("gsettings set org.gnome.desktop.interface font-name 'jetbrains mono nerd font 12'"))
    hl.dispatch(hl.dsp.exec_raw("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE DISPLAY"))

    -- Shell
    hl.exec_cmd("/home/teaguy21/.config/swww/swww.sh 0")
    hl.exec_cmd("~/.config/eww/scripts/launch.sh")
    hl.exec_cmd("~/.config/scripts/autoswitch-bt.sh")
end)
