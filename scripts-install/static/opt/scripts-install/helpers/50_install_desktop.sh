#!/bin/bash

# ref: https://www.digitalocean.com/community/tutorials/how-to-enable-remote-desktop-protocol-using-xrdp-on-ubuntu-22-04

install_gnome_desktop() {
    sudo apt-get update
    sudo apt-get install -y ubuntu-desktop
}

install_xrdp() {
    sudo apt-get update
    sudo apt-get install -y xrdp
    sudo systemctl enable --now xrdp
}

setup_gnome_xrdp() {
    sudo adduser xrdp ssl-cert
    echo "gnome-session" >~/.xsession

    cat <<EOF >~/.xsessionrc
export \$(dbus-launch)
export DESKTOP_SESSION=ubuntu
export GNOME_SHELL_SESSION_MODE=ubuntu
export XDG_CURRENT_DESKTOP=ubuntu:GNOME
export XDG_CONFIG_DIRS=/etc/xdg/xdg-ubuntu:/etc/xdg
EOF
    sudo systemctl restart xrdp.service

    # configure Polkit for xRDP
    sudo cat <<EOF >/etc/polkit-1/localauthority/50-local.d/45-allow-colord.pkla
[Allow Colord all Users]
Identity=unix-user:*
Action=org.freedesktop.color-manager.create-device;org.freedesktop.color-manager.create-profile;org.freedesktop.color-manager.delete-device;org.freedesktop.color-manager.delete-profile;org.freedesktop.color-manager.modify-device;org.freedesktop.color-manager.modify-profile
ResultAny=no
ResultInactive=no
ResultActive=yes
EOF

    # Allow RDP Through the Firewall
    sudo ufw allow 3389/tcp
}

install_desktop() {
    install_gnome_desktop
    install_xrdp
    setup_gnome_xrdp
}
