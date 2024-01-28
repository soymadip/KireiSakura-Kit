#!/bin/bash
set -e

#---------------------- USER CONFIGS --------------------------------------------------------------


ENABLED_MODULES=(      # pending....
    "resize-swap"
)


PACMAN_PACKAGES=(
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

AUR_PACKAGES=(
    "kwin-bismuth-bin"
    "archlinux-tweak-tool"
    "pfetch-rs-bin"
)

FONTS_DIRECTORY="Assets/fonts"
SYSTEM_FONTS_DIRECTORY=".fonts" #for only current user

SWAP_FILE="/swapfile"
SWAP_FILE_SIZE="6G"

GRUB_FILE="/etc/default/grub"



#-------------------------------------------- SCRIPT START -----------------------------------------------


# importng modules:
source Utilities/core-functions.sh   # mandatory
import_all_from "Utilities" "sh"


welcome

#testing
change_meta_to_krunner
enable_os_prober
install_fonts
log "brave is installed in system." error "TEST MESSAGE"
check_dependency "chromium" need
test
