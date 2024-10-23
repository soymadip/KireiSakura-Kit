#  CORE FUNCTIONS



# Import  modules
# kimport <module1> <module2>
kimport() {
    local called_modules=("$@")
    local module_path
    local failed_imports=()
    # local is_quiet=0

    log "Importing modules....\n" inform kimport

    for module_name in "${called_modules[@]}"; do
        module_path="$kirei_module_dir/$module_name.sh"

        if [ -f "$module_path" ]; then
            if source "$module_path"; then
                log "Imported: '$module_name'" 
            else
                log "Failed to import: '$module_name'" inform 
                failed_imports+=("$module_name")  
            fi
        else
            log "Failed to import '$module_name': doesn't exist." inform 
            failed_imports+=("$module_name") 
        fi
        sleep 0.3
    done

    if [ "${#failed_imports[@]}" -gt 0 ]; then
        echo "" 
        log " Failed to import modules:" error kimport
        for failed_import in "${failed_imports[@]}"; do
            echo -e "\t\t${LAVENDER}$failed_import ${NC}"
        done
        log "Please check your imports." inform kimport
        exit 1
    else 
      log "\nImported all modules successfully." success kimport
    fi
}




# Import all files from a directory
load_all_from() {
    local directory=$1
    local file_ext=${2:-"sh"}

    for script in "${directory}"/*.${file_ext}; do
        if [ -e "$script" ]; then
            if ! source "$script"; then
                log "Failed to load $script" error
                exit 1
            fi
        fi
    done
}



# Install a package using pacman or paru
install_package() {
    local package=$1
    local failed=0

    if sudo pacman -S --noconfirm --needed "$package"; then
        log "$package installed successfully." success "INSTALLER"
    else
        log "$package not found in repos. Attempting AUR..." inform

        if paru --needed -S "$package"; then
            log "$package installed successfully from AUR." success "INSTALLER"
        else
            log "$package not found in repos or AUR. Please install it manually." error "INSTALLER"
            failed=1 
        fi
    fi

    return $failed
}



# Check if a dependency is installed
check_dependency() {
    local dependency=$1
    local required=$2

    if pacman -Q "$dependency" &> /dev/null; then
        log "$dependency is installed." success
    else
        log "$dependency is not installed." inform
        if [ -n "$required" ] && [ "$required" == "--needed" ]; then
            log "installing $dependency...." inform
            install_package "$dependency"
            log "$dependency installed." success
        else
            prompt "Do you want to install $dependency?" confirm_install --no-separator
            if [ "$confirm_install" == "y" ] || [ "$confirm_install" == "Y" ] || [ -z "$confirm_install" ]; then
                install_package "$dependency"
                log "$dependency installed." success
            else
                log "$dependency installation was declined by the user." inform
            fi
        fi
    fi
}



# check if a directory exists (make it if it doesn't):
## check_dir <directory> [--needed || --el_exit] [--quiet]
check_dir() {
    local dir=$1
    local is_needed=0
    local el_exit=0
    local is_quiet=0

    while [[ $# -gt 1 ]]; do
        case "$2" in
            -n|--needed)
                is_needed=1
                ;;
            -e|--el_exit)
                el_exit=1
                ;;
            -q|--quiet)
                is_quiet=1
                ;;
            *)
                echo "Invalid option: $2"
                return 1
                ;;
        esac
        shift
    done

    if [[ "$is_needed" -eq 1 && "$el_exit" -eq 1 ]]; then
      log "Invalid flags given." error
      log "How come you gave -n & -e flags both?" inform
      return 1
    fi

    if [[ -d "$dir" ]]; then
        [[ "$is_quiet" -ne 1 ]] && log "Directory '$dir' exists." inform
    else
        [[ "$is_quiet" -ne 1 ]] && log "Directory '$dir' does not exist." inform

        if [[ "$is_needed" -eq 1 ]]; then
            [[ "$is_quiet" -ne 1 ]] && log "Creating directory '$dir'..." inform

            if mkdir -p "$dir" 2>/dev/null; then
                [[ "$is_quiet" -ne 1 ]] && log "Directory '$dir' created successfully."  success
            else
                log "Failed to create directory '$dir'. Attempting with sudo..." inform
                if sudo mkdir -p "$dir"; then
                    [[ "$is_quiet" -ne 1 ]] && log "Directory '$dir' created successfully with sudo." success
                else
                    log "Failed to create directory '$dir' with sudo." error
                    return 1
                fi
            fi
        fi

        if [[ "$el_exit" -eq 1 ]]; then
            exit 1
        fi
    fi
}


# Check if a message strats with given char. if yes, srccessfull..
# strats_with <character_to_check> <message_in_which_to_check> 
starts_with() {
  local character=$1
  local string=$2

  if [[ "$string" == "$character"* ]]; then
    return 0
  else
    return 1
  fi
}



trim_char() {
  local character=$1
  local string=$2
  local trimmed_message

  if starts_with "$character" "$string"; then 
    trimmed_message="${string#"$character"}"
    echo "$trimmed_message"
  else 
    echo "$string"
  fi
}