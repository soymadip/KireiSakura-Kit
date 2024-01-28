# Installing chaotic-AUR:


install_chaotic_aur() {
    prompt "Do you want to install chaotic-AUR?" confirm_aur
    if [ "$confirm_aur" == "y" ] || [ "$confirm_aur" == "Y" ] || [ -z "$confirm_aur" ]; then
        log "Installing chaotic AUR"
        log "Appending keys."
        sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
        sudo pacman-key --lsign-key 3056513887B78AEB
        sudo pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
        sudo pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
        log "Adding repo to /etc/pacman.conf."
        echo -e "\n[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist" | sudo tee -a /etc/pacman.conf
        log "Chaotic-AUR is installed now" success
        log "Updating Repositories." inform
        sleep 1
        sudo pacman -Syu
        log "Update complete." success
        print_footer "Chaotic AUR is successfully installed."
    else
        print_footer "AUR Installation skipped." skipped
    fi
}