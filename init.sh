#!/usr/bin/env bash

# Define color codes
temp_RED='\033[31m'
temp_LAVENDER='\u001b[38;5;147m'
temp_RESET='\033[0m'

#_____________________________________FUNCTIONS_____________________________________________

# For no arguments
show_man() {
    local opt=${1:-" "}

    if [ "$opt" != " " ]; then
        printf "\n  ${temp_RED}Unknown option: %s${temp_RESET}\n" "$opt"
    else
        printf "\n  ${temp_RED}No option was given.${temp_RESET}\n"
    fi
    printf "  Use '${temp_LAVENDER}kireisakura -h${temp_RESET}' for help.\n"

    exit 1
}


# Help message
show_help() {
    printf "\n  Usage: ${temp_LAVENDER}kireisakura {OPTIONS}${temp_RESET}\n"
    printf "  Usage: ${temp_LAVENDER}eval \$(kireisakura --init {OPTIONS})${temp_RESET}\n\n"

    printf "  Options:\n"
    printf "     -i, --init            Set up the KireiSakura-Kit\n"
    printf "     -d, --dir <path>      Set up a custom installation. Must use with -i\n"
    printf "     -h, --help            Show this help message and exit\n"
    printf "     -v, --version         Show version and exit\n"

    exit 0
}


# version 
show_version() {
  local version_num=$(cat $kirei_dir/.version)

  printf "\n  KireiSakura-Kit ${temp_LAVENDER}v$version_num${temp_RESET}\n"
}


# Setup process
init() {
    local kirei_core="$kirei_dir/Utilities/core_functions.sh"    

    # Check if directory exists
    if [ ! -d "$kirei_dir" ]; then
        printf "echo -e '\n${temp_RED}  Error: Custom Kit directory does not exist. Please check the directory path.${temp_RESET}'\n"
        printf "exit 1\n"

        exit 1
    fi

    # Check if core file exists
    if [ ! -f "$kirei_core" ]; then
        printf "echo -e ' \n${temp_RED}Error: Core file is missing in Kit. Please check installation or re-install.${temp_RESET}'\n"
        printf "exit 1\n"

        exit 1
    fi

    # Output environment variable setup commands
    echo -e "kirei_dir=$kirei_dir" 
    echo -e "kirei_utils_dir=$kirei_core/Utilities" 
    echo -e "kirei_core=$kirei_core" 
    
    # printf "export kirei_dir=\"%s\"\n" "$kirei_dir"
    printf "kirei_log_file=\"\${LOG_FILE:-KireiSakura-Kit.log}\"\n"
    printf "kirei_cache_dir=\"\${CACHE_DIR:-\$HOME/.cache/KireiSakura-Kit}\"\n"

    # Print source and check_dir commands
    printf "source \$kirei_core\n"
    printf "check_dir \$kirei_cache_dir --needed\n"

    exit 0
}



# Compare local & git versions and return true if git is greater 
has_update() {
    local local_ver="$1"
    local git_ver="$2"

    # Convert versions to numbers by replacing dots with spaces
    local local_vcode=$(echo "$local_ver" | tr '.' ' ')
    local git_vcode=$(echo "$git_ver" | tr '.' ' ')

    # Compare versions (lexicograpgic comp)
    if [[ "$local_vcode" < "$git_vcode" ]]; then
        return 0  # Update available
    else
        return 1  # No update available
    fi
}

#_________________________________INITIALISATION_____________________________________________

# Initialize variables
kirei_dir="$HOME/.local/lib/KireiSakura-Kit"
init_flag=false

# Check if no arguments are provided
if [ "$#" -eq 0 ]; then
    show_man
fi


# Parse options
while [[ "$#" -gt 0 ]]; do

    case "$1" in
        -h|--help)
            show_help
            ;;
        -v|--version)
            show_version
            ;;
        -i|--init)
            init_flag=true
            ;;
        -d|--dir)
            if [ -n "$2" ]; then
                kirei_dir="$2"
                shift  # Shift past the directory path
            else
                printf "\n  ${temp_RED}Error: Directory path must be specified after '-d' or '--dir'.${temp_RESET}\n"
                exit 1
            fi
            ;;
        *)
            show_man "$1"
            ;;
    esac
    shift  # Shift past the current option
done


# Perform setup if --init flag is set
if [ "$init_flag" = true ]; then
    init "$kirei_dir"
fi
