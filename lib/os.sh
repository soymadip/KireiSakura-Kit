
#/////////////////////  System Power Mangement \\\\\\\\\\\\\\\\\\\\

#
#
#==---------------------------------------------------------------------------------
# NAME:   __reboot
# ALIAS:  os.reboot
# DESC:   Reboot system. Asks for confirmation before rebooting.
# USAGE:  os.reboot [-y|--yes]
# FLAGS:  -y, --yes    Skip confirmation prompt
#==---------------------------------------------------------------------------------
__reboot() {
    local skip_prompt=false

    while [[ $# -gt 0 ]]; do
        case "$1" in
            -y|--yes)
                skip_prompt=true
                shift
                ;;
            *)
                log.error "Invalid option: $1"
                return 1
                ;;
        esac
    done

    if [[ "$skip_prompt" = true ]] || prompt "Reboot is recommended, Do you wanna Reboot?"; then
        log.warn "rebooting..."
        sleep 2
        reboot || sudo reboot || systemctl reboot || log.error "Reboot failed. Please try manually."
    else
        log.warn "Reboot denied by user.."
    fi
}
#==---------------------------------------------------------------------------------


#
#
#==---------------------------------------------------------------------------------
# NAME:   __shut_down
# ALIAS:  os.power.off
# DESC:   Shut down system. Asks for confirmation before shutting down.
# USAGE:  os.shut.down [-y|--yes]
# FLAGS:  -y, --yes    Skip confirmation prompt
#==---------------------------------------------------------------------------------
__shut_down() {
    local skip_prompt=false

    while [[ $# -gt 0 ]]; do
        case "$1" in
            -y|--yes)
                skip_prompt=true
                shift
                ;;
            *)
                log.error "Invalid option: $1"
                return 1
                ;;
        esac
    done

    if [[ "$skip_prompt" = true ]] || prompt "Shut down is recommended, Do you wanna Shut down?"; then
        log.warn "shutting down..."
        sleep 2
        shutdown now || sudo shutdown now || systemctl poweroff || log.error "Shutdown failed. Please try manually."
    else
        log.warn "Shutdown denied by user.."
    fi
}
#==---------------------------------------------------------------------------------


#
#
#==---------------------------------------------------------------------------------
# NAME:   __sleep_system
# ALIAS:  os.sleep
# DESC:   Put system to sleep. Asks for confirmation before sleeping.
# USAGE:  os.sleep [-y|--yes]
# FLAGS:  -y, --yes    Skip confirmation prompt
#==---------------------------------------------------------------------------------
__sleep_system() {
    local skip_prompt=false

    while [[ $# -gt 0 ]]; do
        case "$1" in
            -y|--yes)
                skip_prompt=true
                shift
                ;;
            *)
                log.error "Invalid option: $1"
                return 1
                ;;
        esac
    done

    if [[ "$skip_prompt" = true ]] || prompt "Putting system to Sleep is recommended, Please confirm"; then
        log.warn "putting system to sleep..."
        sleep 2
        systemctl suspend || sudo systemctl suspend || log.error "Sleep failed. Please try manually."
    else
        log.warn "Sleep denied by user.."
    fi
}
#==---------------------------------------------------------------------------------


#/////////////////////////// Package Management \\\\\\\\\\\\\\\\\\\\\\\\\


#
#
#==---------------------------------------------------------------------------------
# NAME:   __is_insatalled
# ALIAS:  os.package.is.installed
# DESC:   Check if a package is installed.
# USAGE:  os.package.is.installed [<flags>] <package>
# RETURN: 0 if installed, 1 if not installed.
# FLAGS:
#         -q,--quiet    Suppress output.
#==---------------------------------------------------------------------------------
__is_insatalled() {
    local pkg
    local be_quiet=false

    while [[ $# -gt 0 ]]; do
        case "$1" in
            -q | --quiet)
                be_quiet=true
                shift
            ;;
            *)
                pkg="$1"
                shift
            ;;
        esac
    done

    if [[ -z "$pkg" ]]; then
        log.error "No package provided."
        return 1
    fi

    if command -v "$pkg" &>/dev/null; then
        [[ "$be_quiet" = false ]] && log.success "$pkg is installed."
        return 0
    else
        [[ "$be_quiet" = false ]] && log.warn "$pkg is not installed."
        return 1
    fi
}
#==---------------------------------------------------------------------------------


#
#
#==---------------------------------------------------------------------------------
# NAME:   __get_package_manager
# ALIAS:  os.get.package.manager
# DESC:   Determine the package manager based on the OS.
# USAGE:  os.get.package.manager
#==---------------------------------------------------------------------------------
__get_package_manager() {

    if [[ "$(uname)" == "Linux" ]]; then
        if __is_insatalled -q pacman; then
            echo "pacman"
        elif __is_insatalled -q apt; then
            echo "apt"
        elif __is_insatalled -q dnf; then
            echo "dnf"
        elif __is_insatalled -q zypper; then
            echo "zypper"
        elif __is_insatalled -q apk; then
            echo "apk"
        else
            log.error "Unsupported Linux distribution."
            log.error "Use one (or derivatives) of below distros: "
            log.error "Debian, Ubuntu, Fedora, Arch, SUSE"
            return 1
        fi
        return 0
    elif [[ "$(uname)" == "Darwin" ]]; then
        echo "brew"
        return 0
    else
        log.error "Unsupported OS."
        log.error "Only Linux and macOS are supported."
        return 1
    fi
}
#==---------------------------------------------------------------------------------


#
#
#==---------------------------------------------------------------------------------
# NAME:   __install_package
# ALIAS:  os.package.install
# DESC:   determine distro's package manager and installs the package.
# USAGE:  os.package.install <package>
#==---------------------------------------------------------------------------------
__install_package() {
    local pkg="$1"
    local pkg_mngr

    pkg_mngr="$(__get_package_manager)"

    case $pkg_mngr in
        pacman)
            sudo pacman -S --noconfirm --needed "$pkg" >/dev/null || return 1
        ;;
        apt)
            sudo apt update >/dev/null || return 1
            sudo apt install -y "$pkg" >/dev/null || return 1
        ;;
        dnf)
            sudo dnf install -y "$pkg" >/dev/null || return 1
        ;;
        zypper)
            sudo zypper install -y "$pkg" >/dev/null || return 1
        ;;
        apk)
            sudo apk add "$pkg" >/dev/null || return 1
        ;;
        brew)
            brew install "$pkg" >/dev/null || return 1
        ;;
        *)
            log.error "Unsupported Linux distribution."
            log.error "No suppoeted package manager found."
            log.warn "Use one (or derivatives) of below distros: "
            log.warn "Debian, Ubuntu, Fedora, Arch, SUSE"
            return 1
        ;;
    esac
    return 0
}
#==---------------------------------------------------------------------------------



#
#
#==---------------------------------------------------------------------------------
# NAME:   __check_dir
# ALIAS:  check-dir
# DESC:   Check if a directory exists and optionally create it.
# USAGE:  check-dir <directory> [<flags>]
# FLAGS:
#         -n,--needed   Create the directory if it doesn't exist.
#         -e,--el_exit  Exit if the directory doesn't exist.
#         -q,--quiet    Suppress output.
#==---------------------------------------------------------------------------------
__check_dir() {
    local dir=$1
    local is_needed=0
    local el_exit=0
    local is_quiet=0
    
    if [[ -z "$dir" ]]; then
        echo "Error: Directory parameter is required."
        return 1
    fi
    
    shift
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -n | --needed)
                is_needed=1
            ;;
            -e | --el_exit)
                el_exit=1
            ;;
            -q | --quiet)
                is_quiet=1
            ;;
            *)
                echo "Invalid option: $1"
                return 1
            ;;
        esac
        shift
    done
    
    if [[ "$is_needed" -eq 1 && "$el_exit" -eq 1 ]]; then
        log.error "Invalid flags given: --needed and --el_exit cannot be used together."
        return 1
    fi
    
    if [[ -d "$dir" ]]; then
        [[ "$is_quiet" -ne 1 ]] && log.warn "Directory '$dir' already exists."
    else
        [[ "$is_quiet" -ne 1 ]] && log.warn "Directory '$dir' does not exist."
        
        if [[ "$is_needed" -eq 1 ]]; then
            [[ "$is_quiet" -ne 1 ]] && log.warn "Creating directory '$dir'..."
            
            if mkdir -p "$dir" 2>/dev/null; then
                [[ "$is_quiet" -ne 1 ]] && log.success "Directory '$dir' created successfully."
            else
                log.warn "Failed to create directory '$dir'. Attempting with sudo..."
                if sudo mkdir -p "$dir"; then
                    [[ "$is_quiet" -ne 1 ]] && log.success "Directory '$dir' created successfully with sudo."
                else
                    log.error "Failed to create directory '$dir' with sudo."
                    return 1
                fi
            fi
        fi

        if [[ "$el_exit" -eq 1 ]]; then
            log.error "Exiting as requested by --el_exit flag."
            exit 1
        fi
    fi
}
#==---------------------------------------------------------------------------------




#_________________________ Aliases _________________________

# System power state management
alias os.reboot='__reboot'
alias os.power.off='__shut_down'
alias os.sleep='__sleep_system'
# alias os.lock='__lock_screen'
# alias os.log.out='__logout_user'

# Package Management
alias os.get.package.manager='__get_package_manager'
alias os.package.is.installed='__is_insatalled'
alias os.package.install='__install_package'
# alias os.package.remove='__remove_package'
# alias os.package.reinstall='__reinstall_package'
# alias os.package.update='__update_package'
# alias os.package.update.all='__update_package -a'


# alias os.get.swap.path='__get_swap_path'
# alias os.get.swap.size='__get_swap_size'
# alias os.get.swap.status='__get_swap_status'
# alias os.get.swap.info='__get_swap_info'


