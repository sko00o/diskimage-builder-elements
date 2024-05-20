#!/bin/bash

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
    echo "sudo -u ${USER} gnome-session" >~/.xsession

    cat <<EOF >~/.xsessionrc
export GNOME_SHELL_SESSION_MODE=ubuntu
export XDG_CURRENT_DESKTOP=ubuntu:GNOME
export XDG_CONFIG_DIRS=/etc/xdg/xdg-ubuntu:/etc/xdg
EOF

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
