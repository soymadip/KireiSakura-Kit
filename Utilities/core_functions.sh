# This script contains various decorative UI elements 
# used within the main script to make sctipt more visually appiling.

#____________________________________________UI Elements___________________________________________________

# Color codes for various visuals
NC='\033[0m' # No Color/escape code
AQUA='\e[38;2;216;222;233m'
LAVENDER='\u001b[38;5;147m'
BLUE='\033[38;5;67m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'



#welcome system
welcome() {
    clear
    echo -e "\n${YELLOW}Welcome to Init-Script......${NC}"
}




# Log function
log() {
    local log_message=$1
    local log_level=${2:-"  -  "}
    local extra_info=$3


    # Determine color based on log level
    case "$log_level" in
        "error")
            color="${RED}"
            ;;
        "imp")
            color="${YELLOW}"
            ;;
        "inform")
            color="${YELLOW}"
            ;;
        "success")
            color="${GREEN}"
            ;;
        *)
            color="${BLUE}"
            ;;
    esac

    # Format the log message
    if [ -n "$extra_info" ]; then
        # Extra info case
        formatted_message="${color}[ ${extra_info} ] -> ${log_message}${NC}"
    else
        # No extra info case
        case "$log_level" in
            "error")
                prefix="[X]->"
                ;;
            "imp")
                prefix="[!]->"
                ;;
            "inform")
                prefix="[!]->"
                ;;
            "success")
                prefix="[✔]->"
                ;;
            *)
                prefix="[-]->"
                ;;
        esac
        formatted_message="${color}${prefix} ${log_message}${NC}"
    fi

    # Print to console
    echo -e "$formatted_message"
    # Log to file
    echo "$(date +"%Y-%m-%d %H:%M:%S") [$log_level] $log_message" >> "$kirei_log_file"
}




# check if a directory exists (make it if it doesn't):
## check_dir <directory> [--needed] [--el_exit]
check_dir() {
    local dir=$1
    local is_needed=0
    local el_exit=0

    while [[ $# -gt 1 ]]; do
        case "$2" in
            "--needed")
                is_needed=1
                ;;
            "--el_exit")
                el_exit=1
                ;;
            *)
                ;;
        esac
        shift
    done

    if [ -d "$dir" ]; then
        log "Directory '$dir' exists." inform
    else
        log "Directory '$dir' does not exist." inform

        if [ "$is_needed" -eq 1 ]; then
            log "Creating directory '$dir'..." inform
            mkdir -p "$dir" || {
                log "Failed to create directory '$dir'" error
                return 1
            }
            log "Directory '$dir' created successfully." success
        fi

        if [ "$el_exit" -eq 1 ]; then
            exit 0
        fi
    fi
}





# prompt asking for user authentication
## prompt <message> <response_variable> [--no-separator]
prompt() {
    local message=$1
    local response_var=$2
    local flag=${3:-""}

    if [ "$flag" != "--no-separator" ]; then
        echo -e "${AQUA}--------------------------${NC}"
    fi

    echo -e "${LAVENDER}[?] ${message}${NC} (y/n)"
    read -p "|==-> " $response_var
}



# footer after each module completes
print_footer() {
    if [ -n "$1" ]; then
        if [ "$2" == "skipped" ]; then
            echo -e "${RED}[x]-> $1${NC}"
        else
            echo -e "${GREEN}[✔]=> $1${NC}"
        fi
    fi
    echo -e "${AQUA}---------------------------------------------------------------${NC}"
    sleep 1
}



#______________________________________________Inbuilt Functions__________________________________________________



load_util() {
    local script_bases=("$@")
    local script_dir
    local script_path

    # Resolve the directory of the current script
    script_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

    for script_base in "${script_bases[@]}"; do
        script_path="$script_dir/$script_base.sh"

        if [ -f "$script_path" ]; then
            source "$script_path"
            log "Loaded $script_path"
        else
            log "Error: $script_path does not exist." error
        fi
    done
}


# Import all files from a directory
load_all_from() {
    local directory=$1
    local file_ext=${2:-"sh"}

    for script in ${directory}/*.${file_ext}; do
        [ -e "$script" ] && [ "$(basename "$script")" != "core-functions.sh" ] && source "$script"
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
