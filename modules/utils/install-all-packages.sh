# Function to install packages from multiple groups



function install_all_packages {

    for group_name in "$@"; do

        local -n group="$group_name"
        local failed_pckgs=()

        log.warn "Starting installation of packages from group: $group_name"

        prompt "Install packages from from the group: $group_name?" confirm_instpkgs
        if [[ "$confirm_instpkgs" == "y" || "$confirm_instpkgs" == "Y" || -z "$confirm_instpkgs" ]]; then
            log.warn "Installing packages from $group_name..."

            for pkg in "${group[@]}"; do
                echo -e "\n"
                log.warn "Installing $pkg"
                install-package "$pkg" || failed_pckgs+=("$pkg")
                sleep 1
            done

            echo -e "\n"
            log.success "Packages from $group_name are installed"
        else
            echo -e "\n"
            log.error "User denied installation of packages from $group_name"
        fi

        # Log the completion of the group installation and print footer
        log.success "Finished processing group: $group_name \n"
    done


    if [[ ${#failed_pckgs[@]} -gt 0 ]]; then
        log.error "Failed to install the following packages: ${failed_pckgs[*]}"
        log.error "Please check if they are available or if there was an error during installation."
    else
        log.success "All packages are installed successfully"
    fi

    print_footer
}
