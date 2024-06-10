#!/bin/bash

_PostInstallCommands() {
    # new user tht's just created for the target
    local -r username="$1"

    local PACMAN_PACKAGES_S=(
        "zsh"
        "libdbusmenu-glib"
        "appmenu-gtk-module"
        "libappindicator-gtk3"
        "trash-cli"
        "rsync"
        "kup"
        "kdeplasma-addons"
        "packagekit-qt5"
        "xdg-desktop-portal"
        "dust"
        "kdialog"
        "spectacle"
        "ktorrent"
        "neovim"
        "xclip"
        "syncthing"
        "libreoffice-fresh"
        "mpv"
        "vscodium"
        "vscodium-marketplace"
        "ventoy"
        "simplescreenrecorder"
        "librewolf"
        "obsidian"
        "brave"
        "64gram-desktop"
        "paru"
    )

    # Setup Chaotic AUR
    pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
    pacman-key --lsign-key 3056513887B78AEB
    pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
    pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
    echo -e "\n[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist" | tee -a /etc/pacman.conf
    sleep 1
    pacman -Syu --noconfirm

    # install packages
    pacman -S --noconfirm --needed geany chromium libreoffice-fresh
    echo "Installing Repo packages"
    pacman -S --noconfirm --needed "${pacman_packages_S[@]}"
    log "Repo packages installed."

    # Change meta key to open krunner:
    kwriteconfig5 --file kwinrc --group ModifierOnlyShortcuts --key Meta "org.kde.krunner,/App,,toggleDisplay"
    qdbus org.kde.KWin /KWin reconfigure
    sleep 3
}

## Execute the commands if the parameter list is valid:

case "$1" in
    --iso-conf* | online | offline | community) ;;   # no more supported here
    *) _PostInstallCommands "$1" ;;
esac

