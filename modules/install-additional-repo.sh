# This script installs additional repositories like Chaotic AUR, ArcoLinux, Garuda, etc.

install_adtionl_repos() {
    prompt "Do you want to install 3rd party repos?" confirm_aur
    if [ "$confirm_aur" == "y" ] || [ "$confirm_aur" == "Y" ] || [ -z "$confirm_aur" ]; then

        # Chaotic AUR
        chaotic_aur_key="3056513887B78AEB"
        chaotic_aur_keyserver="keyserver.ubuntu.com"
        chaotic_aur_keyring_url="https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst"
        chaotic_aur_mirrorlist_url="https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst"

        log.warn "Installing Chaotic AUR..."
        log.warn "Appending keys..."
        sudo pacman-key --recv-key $chaotic_aur_key --keyserver $chaotic_aur_keyserver || {
            log.error "Failed to receive Chaotic AUR key"
            return 1
        }
        sudo pacman-key --lsign-key $chaotic_aur_key || {
            log.error "Failed to locally sign Chaotic AUR key"
            return 1
        }
        sudo pacman -U --noconfirm $chaotic_aur_keyring_url || {
            log.error "Failed to install Chaotic AUR keyring"
            return 1
        }
        sudo pacman -U --noconfirm $chaotic_aur_mirrorlist_url || {
            log.error "Failed to install Chaotic AUR mirrorlist"
            return 1
        }
        log.warn "Adding Chaotic AUR to /etc/pacman.conf..."
        echo -e "\n[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist" | sudo tee -a /etc/pacman.conf
        log.success "Chaotic AUR is installed."

        # ArcoLinux
        arcolinux_repo_url="https://github.com/arcolinux/archlinux-tweak-tool"
        arcolinux_cache_dir="~/.cache/setup/arcolinux-app"

        log.warn "Installing ArcoLinux repos..."
        log.warn "Cloning ArcoLinux tweak tool..."
        git clone $arcolinux_repo_url $arcolinux_cache_dir || {
            log.error "Failed to clone ArcoLinux Tweak Tool"
            return 1
        }
        log.warn "Installing ArcoLinux keyring and mirrorlist..."
        sudo pacman -U $arcolinux_cache_dir/usr/share/archlinux-tweak-tool/data/arco/packages/keyring/arcolinux-keyring-*-any.pkg.tar.zst || {
            log.error "Failed to install ArcoLinux keyring"
            return 1
        }
        sudo pacman -U $arcolinux_cache_dir/usr/share/archlinux-tweak-tool/data/arco/packages/mirrorlist/arcolinux-mirrorlist-*-any.pkg.tar.zst || {
            log.error "Failed to install ArcoLinux mirrorlist"
            return 1
        }
        log.warn "Adding ArcoLinux repositories to /etc/pacman.conf..."
        echo -e "\n[arcolinux_repo]\nSigLevel = PackageRequired DatabaseNever\nInclude = /etc/pacman.d/arcolinux-mirrorlist" | sudo tee -a /etc/pacman.conf
        echo -e "\n[arcolinux_repo_3party]\nSigLevel = PackageRequired DatabaseNever\nInclude = /etc/pacman.d/arcolinux-mirrorlist" | sudo tee -a /etc/pacman.conf
        echo -e "\n[arcolinux_repo_xlarge]\nSigLevel = PackageRequired DatabaseNever\nInclude = /etc/pacman.d/arcolinux-mirrorlist" | sudo tee -a /etc/pacman.conf
        rm -rf $arcolinux_cache_dir
        log.success "ArcoLinux repos are successfully installed."

        # Garuda
        garuda_repo="[garuda]\nSigLevel = Required DatabaseOptional\nInclude = /etc/pacman.d/chaotic-mirrorlist"

        log.warn "Installing Garuda repos..."
        echo -e "\n$garuda_repo" | sudo tee -a /etc/pacman.conf
        log.success "Garuda repos are successfully installed."

        # Update Repositories
        log.warn "Updating repositories..."
        sudo pacman -Syu || {
            log.error "Failed to update repositories"
            return 1
        }
        log.success "Update complete."
        print_footer "Chaotic AUR, ArcoLinux, and Garuda repos are successfully installed."
    else
        log.error "3rd party repo installation skipped."
        print_footer
    fi
}
