# Installing Apps:




install_pkgs() {
    pormpt "Do you want to install apps?" confirm_pkgs
    if [ "$confirm_pkgs" == "y" ] || [ "$confirm_pkgs" == "Y" ] || [ -z "$confirm_pkgs" ]; then
        # Repo:
        log "Installing Repo packages"
        sudo pacman -S --noconfirm "${pacman_packages[@]}"
        log "Repo packages installed." success
        # AURs:
        log "Installing AUR packages," inform
        log "Please carefully select options when asked:" 
        yay -S "${aur_packages[@]}"
        print_footer "AUR packages installed."
    else
        echo -e "${RED}Packages' Installation skipped.${NC}"
    fi
}
