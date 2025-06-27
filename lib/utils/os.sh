
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
# NAME:   __is_installed
# ALIAS:  os.package.installed
# DESC:   Check if a package is installed.
# USAGE:  os.package.installed [<flags>] <package>
# RETURN: 0 if installed, 1 if not installed.
# FLAGS:
#         -q,--quiet    Suppress output.
#==---------------------------------------------------------------------------------
__is_installed() {
    local pkg
    local be_quiet=false
    local debug_mode=${K_DEBUG_MODE:-false}
    
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
        $debug_mode && log.success "$pkg is installed."
        return 0
    else
        $debug_mode && log.warn "$pkg is not installed."
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
        if __is_installed -q pacman; then
            echo "pacman"
            elif __is_installed -q apt; then
            echo "apt"
            elif __is_installed -q dnf; then
            echo "dnf"
            elif __is_installed -q zypper; then
            echo "zypper"
            elif __is_installed -q apk; then
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
# NAME:   __is_dir_exists
# ALIAS:  os.dir.exists
# DESC:   Check if a directory exists.
# RETURN: 0 if exists, 1 if not exists.
# USAGE:  os.dir.exists [<flags>] <directory>
# FLAGS:
#         -ee, --el_exit   Exit on error.
#         -n, --needed     Create dir if not exists.
#         -q, --quiet      Suppress output.
#==---------------------------------------------------------------------------------
__is_dir_exists() {
    local dir
    local el_exit=false is_quiet=false needed=false
    local debug_mode=${K_DEBUG_MODE:-false}
    
    [[ $# -eq 0 ]] && {
        log.error "No directory provided.";
        log.warn "Usage: os.dir.exists [<flags>] <directory>";
        return 1;
    }
    
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -q|--quiet)
                is_quiet=true
            ;;
            -ee|--el_exit)
                el_exit=true
            ;;
            -n|--needed)
                needed=true
            ;;
            -*|--*)
                log.error "Invalid option: $1"
                log.warn "Usage: os.dir.exists [<flags>] <directory>"
                return 1
            ;;
            *)
                dir="$1"
            ;;
        esac
        shift
    done
    
    $needed && $el_exit && {
        log.error "Can't use both '-n' and '-ee' flags together."
        log.warn "Usage: os.dir.exists [<flags>] <directory>"
        return 1
    }
    
    if [[ -z "$dir" ]]; then
        log.error "No directory provided."
        log.warn "Usage: os.dir.exists [<flags>] <directory>"
        return 1
    fi
    
    if [[ -d "$dir" ]]; then
        $debug_mode && log.warn "Directory '$dir' exists."
        return 0
    else
        $debug_mode && log.warn "Directory '$dir' does not exist."
        
        if $needed; then
            __create_dir "$dir" || {
                log.error "Failed to create directory '$dir'."
                $el_exit && exit 1 || return 1
            }
            return 0
        else
            $el_exit && exit 1 || return 1
        fi
    fi
}
#==---------------------------------------------------------------------------------


#
#
#==---------------------------------------------------------------------------------
# NAME:   __create_dir
# ALIAS:  os.dir.create
# DESC:   Create a directory, Also parent dirs.
# USAGE:  os.dir.create [<flags>] <directory>
# FLAGS:
#        -q  --quiet    suppress output
#        -ee --el_exit  exit on error
# TODO: Add debug mode
#==---------------------------------------------------------------------------------
__create_dir() {
    local dir="$1"
    local el_exit=false is_quiet=false mk_command
    local debug_mode=${K_DEBUG_MODE:-false}
    
    [[ $# -eq 0 ]] && {
        log.error "No directory provided.";
        log.warn "Usage: os.dir.create [<flags>] <directory>";
        return 1;
    }
    
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -ee|--el_exit)
                el_exit=true
            ;;
            -q|--quiet)
                is_quiet=true
            ;;
            -*|--*)
                log.error "Invalid option: $1"
                log.warn "Usage: os.dir.create [<flags>] <directory>"
                return 1
            ;;
            *)
                dir="$1"
            ;;
        esac
        shift
    done
    
    
    if [[ -d "$dir" ]]; then
        ! $is_quiet && log.warn "Directory '$dir' already exists."
        return 0
    else
        $debug_mode && log.warn "Directory '$dir' does not exist."
        
        ! $is_quiet && log.warn "Creating directory '$dir'..."
        
        mk_command=$( $debug_mode && echo "mkdir -p \"$dir\"" || echo "mkdir -p \"$dir\" 2>/dev/null" )
        
        if eval "$mk_command"; then
            ! $is_quiet && \
                log.success "Directory '$dir' created successfully."
        else
            log.warn "Failed to create directory '$dir'.\nAttempting with sudo..."
            
            if sudo mkdir -p "$dir"; then
                ! $is_quiet && \
                    log.success "Directory '$dir' created successfully."
            else
                log.error "Failed to create directory '$dir' with sudo."
                
                $el_exit && exit 1 || return 1
            fi
        fi
    fi
}
#==---------------------------------------------------------------------------------


#
#
#==---------------------------------------------------------------------------------
# NAME:   __remove_dir
# ALIAS:  os.dir.remove
# DESC:   Remove a directory(& it's contents)
# USAGE:  os.dir.remove
# FLAGS:
#         -q, --quiet    Suppress output.
#==---------------------------------------------------------------------------------
__remove_dir() {
    local dir is_quiet=false
    local debug_mode=${K_DEBUG_MODE:-false}
    
    [[ $# -eq 0 ]] && {
        log.error "No directory provided.";
        log.warn "Usage: os.dir.remove [<flags>] <directory>";
        return 1;
    }
    
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -q|--quiet)
                is_quiet=true
            ;;
            -*|--*)
                log.error "Invalid option: $1"
                log.warn "Usage: os.dir.remove [<flags>] <directory>"
                return 1
            ;;
            *)
                dir="$1"
            ;;
        esac
        shift
    done
    
    if [[ -d "$dir" ]]; then
        if rm -rf "$dir"; then
            ! $is_quiet && log.success "Directory '$dir' removed successfully."
            return 0
        else
            ! $is_quiet && log.error "Failed to remove directory '$dir'."
            return 1
        fi
    else
        ! $is_quiet && log.error "Directory '$dir' does not exist."
        return 1
    fi
}
#==---------------------------------------------------------------------------------


#
#
#==---------------------------------------------------------------------------------
# NAME:   __list_dirs
# ALIAS:  os.list.dirs
# DESC:   List all directories in given dir path.
# USAGE:  os.list.dirs <directory>
#==---------------------------------------------------------------------------------
__list_dirs() {
    local dir="$1"
    
    [[ ! -d "$dir" ]] && {
        log.error "Not a directory: '$dir'"
        return 1
    }
    
    for sub_dir in "$dir"/*/; do
        [[ -d "$sub_dir" ]] && basename "$sub_dir"
    done
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
alias os.package.installed='__is_installed'
alias os.package.install='__install_package'
# alias os.package.remove='__remove_package'
# alias os.package.reinstall='__reinstall_package'
# alias os.package.update='__update_package'
# alias os.package.update.all='__update_package -a'

# Directory Management
alias os.dir.exists='__is_dir_exists'
alias os.dir.create='__create_dir'
alias os.dir.remove='__remove_dir'
alias os.list.dirs='__list_dirs'


# alias os.get.swap.path='__get_swap_path'
# alias os.get.swap.size='__get_swap_size'
# alias os.get.swap.status='__get_swap_status'
# alias os.get.swap.info='__get_swap_info'


