# This script installs additional repositories like Chaotic AUR, ArcoLinux, Garuda, etc.

install_adtionl_repos() {
    prompt "Do you want to install 3rd party repos?" confirm_aur
    if [ "$confirm_aur" == "y" ] || [ "$confirm_aur" == "Y" ] || [ -z "$confirm_aur" ]; then
        
        # Chaotic AUR
        chaotic_aur_key="3056513887B78AEB"
        chaotic_aur_keyserver="keyserver.ubuntu.com"
        chaotic_aur_keyring_url="https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst"
        chaotic_aur_mirrorlist_url="https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst"
        
        log "Installing Chaotic AUR..." inform
        log "Appending keys..." inform
        sudo pacman-key --recv-key $chaotic_aur_key --keyserver $chaotic_aur_keyserver || {
            log "Failed to receive Chaotic AUR key" error
            return 1
        }
        sudo pacman-key --lsign-key $chaotic_aur_key || {
            log "Failed to locally sign Chaotic AUR key" error
            return 1
        }
        sudo pacman -U --noconfirm $chaotic_aur_keyring_url || {
            log "Failed to install Chaotic AUR keyring" error
            return 1
        }
        sudo pacman -U --noconfirm $chaotic_aur_mirrorlist_url || {
            log "Failed to install Chaotic AUR mirrorlist" error
            return 1
        }
        log "Adding Chaotic AUR to /etc/pacman.conf..." inform
        echo -e "\n[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist" | sudo tee -a /etc/pacman.conf
        log "Chaotic AUR is installed." success

        # ArcoLinux
        arcolinux_repo_url="https://github.com/arcolinux/archlinux-tweak-tool"
        arcolinux_cache_dir="~/.cache/setup/arcolinux-app"
        
        log "Installing ArcoLinux repos..." inform
        log "Cloning ArcoLinux tweak tool..." inform
        git clone $arcolinux_repo_url $arcolinux_cache_dir || {
            log "Failed to clone ArcoLinux Tweak Tool" error
            return 1
        }
        log "Installing ArcoLinux keyring and mirrorlist..." inform
        sudo pacman -U $arcolinux_cache_dir/usr/share/archlinux-tweak-tool/data/arco/packages/keyring/arcolinux-keyring-*-any.pkg.tar.zst || {
            log "Failed to install ArcoLinux keyring" error
            return 1
        }
        sudo pacman -U $arcolinux_cache_dir/usr/share/archlinux-tweak-tool/data/arco/packages/mirrorlist/arcolinux-mirrorlist-*-any.pkg.tar.zst || {
            log "Failed to install ArcoLinux mirrorlist" error
            return 1
        }
        log "Adding ArcoLinux repositories to /etc/pacman.conf..." inform
        echo -e "\n[arcolinux_repo]\nSigLevel = PackageRequired DatabaseNever\nInclude = /etc/pacman.d/arcolinux-mirrorlist" | sudo tee -a /etc/pacman.conf
        echo -e "\n[arcolinux_repo_3party]\nSigLevel = PackageRequired DatabaseNever\nInclude = /etc/pacman.d/arcolinux-mirrorlist" | sudo tee -a /etc/pacman.conf
        echo -e "\n[arcolinux_repo_xlarge]\nSigLevel = PackageRequired DatabaseNever\nInclude = /etc/pacman.d/arcolinux-mirrorlist" | sudo tee -a /etc/pacman.conf
        rm -rf $arcolinux_cache_dir
        log "ArcoLinux repos are successfully installed." success

        # Garuda
        garuda_repo="[garuda]\nSigLevel = Required DatabaseOptional\nInclude = /etc/pacman.d/chaotic-mirrorlist"
        
        log "Installing Garuda repos..." inform
        echo -e "\n$garuda_repo" | sudo tee -a /etc/pacman.conf
        log "Garuda repos are successfully installed." success

        # Update Repositories
        log "Updating repositories..." inform
        sudo pacman -Syu || {
            log "Failed to update repositories" error
            return 1
        }
        log "Update complete." success
        print_footer "Chaotic AUR, ArcoLinux, and Garuda repos are successfully installed."
    else
        log "3rd party repo installation skipped." error 
        print_footer 
    fi
}
