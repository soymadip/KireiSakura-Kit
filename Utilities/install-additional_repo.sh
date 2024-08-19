# Installing chaotic-AUR:


install_adtionl_repos() {
    prompt "Do you want to install 3rd party repos?" confirm_aur
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

        log "Installing ArcoLinux repos..." inform
        log "Appending keys."
        git clone https://github.com/arcolinux/archlinux-tweak-tool  ~/.cache/setup/arcolinux-app
        sudo pacman -U ~/.cache/setup/arcolinux-app/usr/share/archlinux-tweak-tool/data/arco/packages/keyring/arcolinux-keyring-*-any.pkg.tar.zst
        sudo pacman -U ~/.cache/setup/arcolinux-app/usr/share/archlinux-tweak-tool/data/arco/packages/mirrorlist/arcolinux-mirrorlist-*-any.pkg.tar.zst
        log "Adding ArcoLinux repositories to /etc/pacman.conf..."
        echo -e "\n[arcolinux_repo]\nSigLevel = PackageRequired DatabaseNever\nInclude = /etc/pacman.d/arcolinux-mirrorlist" | sudo tee -a /etc/pacman.conf
        echo -e "\n[arcolinux_repo_3party]\nSigLevel = PackageRequired DatabaseNever\nInclude = /etc/pacman.d/arcolinux-mirrorlist" | sudo tee -a /etc/pacman.conf
        echo -e "\n[arcolinux_repo_xlarge]\nSigLevel = PackageRequired DatabaseNever\nInclude = /etc/pacman.d/arcolinux-mirrorlist" | sudo tee -a /etc/pacman.conf
        rm -rf ~/.cache/setup/arcolinux-app 
        log "ArcoLinux repos are successfully installed." success

        log "Installing Garuda repos..." inform
        echo -e "\n[garuda]\nSigLevel = Required DatabaseOptional\nInclude = /etc/pacman.d/chaotic-mirrorlist" | sudo tee -a /etc/pacman.conf
        log "Garuda repos are successfully installed." success

        log "Updating Repositories." inform
        sleep 1
        sudo pacman -Syu
        log "Update complete." success
        print_footer "Chaotic AUR & ArcoLinux repo are successfully installed."
    else
        log "3rd party repo Installation skipped." error 
        print_footer 
    fi
}