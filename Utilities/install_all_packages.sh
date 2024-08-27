# Function to install packages from multiple groups



function install_all_packages {

    for group_name in "$@"; do

        local -n group="$group_name"
        local failed_pckgs=()

        log "Starting installation of packages from group: $group_name" inform

        prompt "Install packages from from the group: $group_name?" confirm_instpkgs
        if [[ "$confirm_instpkgs" == "y" || "$confirm_instpkgs" == "Y" || -z "$confirm_instpkgs" ]]; then
            log "Installing packages from $group_name..." inform

            for pkg in "${group[@]}"; do
                echo -e "\n"
                log "Installing $pkg" inform
                install_package "$pkg" || failed_pckgs+=("$pkg")
                sleep 1
            done

            echo -e "\n"
            log "Packages from $group_name are installed" success
        else
            echo -e "\n"
            log "User denied installation of packages from $group_name" error
        fi

        # Log the completion of the group installation and print footer
        log "Finished processing group: $group_name \n" success 
    done


    if [[ ${#failed_pckgs[@]} -gt 0 ]]; then
        log "Failed to install the following packages: ${failed_pckgs[*]}" error
        log "Please check if they are available or if there was an error during installation." error
    else 
        log "All packages are installed successfully" success
    fi

    print_footer
}