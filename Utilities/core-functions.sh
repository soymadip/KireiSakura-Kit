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

# Log file name (use default if not specified)
kirei_log_file="${LOG_FILE:-KireiSakura-Kit.log}"
if [ ! -e "$kirei_log_file" ]; then
    touch "$kirei_log_file"
fi




# Log function
log() {
    local log_message=$1
    local log_level=$2
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




# ui for individual process
# prompt asking for user authentication
prompt() {
    echo -e "${AQUA}--------------------------${NC}"
    echo -e "${LAVENDER}[?] $1${NC} (y/n)"
    read -p "|==-> " $2
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



# Import all files from a directory
import_all_from() {
    local directory=$1
    local file_ext=$2
    
    for script in ${directory}/*.${file_ext}; do
        [ -e "$script" ] && [ "$(basename "$script")" != "core-functions.sh" ] && source "$script"
    done
}


# Check if a dependency is installed
check_dependency() {
    local DEPENDENCY=$1
    local REQUIRED=$2

    if ! pacman -Q "$DEPENDENCY" &> /dev/null; then
        log "Error: ${DEPENDENCY} is not installed." error "CHECKER"
        prompt "Do you want to install ${DEPENDENCY}?" confirm_install
        if [ "$confirm_install" == "y" ] || [ "$confirm_install" == "Y" ] || [ -z "$confirm_install" ]; then
            sudo pacman -S --noconfirm "$DEPENDENCY"
            log "$DEPENDENCY installed."
        else
            if [ -n "$REQUIRED" ] && [ "$REQUIRED" == "needed" ]; then
                log "${DEPENDENCY} is not installed." inform
                print_footer "Please install it before running this." skip
                exit 1
            else
                log "${DEPENDENCY} is not installed." inform "CHECKER"
            fi
        fi
    else
        log "${DEPENDENCY} is installed in system." success
    fi
}

