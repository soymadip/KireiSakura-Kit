#!/usr/bin/env bash

# Define color codes
RED='\033[31m'
LAVENDER='\u001b[38;5;147m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
RESET='\033[0m'

#_____________________________________FUNCTIONS_____________________________________________


# Log function 
logf() {
    local message="$1"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')

    # Replace '\n' with actual newlines
    local formatted_message=$(echo -e "$message")

    while IFS= read -r line; do
        printf "%s %s\n" "$timestamp" "$line" >> "$log_file"
    done <<< "$formatted_message"
}



# For no arguments
show_man() {
    local opt=${1:-" "}

    if [ "$opt" != " " ]; then
        printf "\n  ${RED}Unknown falg: "$opt" ${RESET}\n" 
    else
        printf "\n  ${RED}No flag was given.${RESET}\n"
    fi

    printf "  Use '${LAVENDER}kireisakura -h${RESET}' for help.\n"

    exit 1
}



# Help message
show_help() {

    printf "\n  Usage: ${LAVENDER}kireisakura {OPTIONS}${RESET}\n"
    printf "  Usage: ${LAVENDER}eval \$(kireisakura --init {OPTIONS})${RESET}\n\n"

    printf "  Options:\n"
    printf "      -i,  --init            Set up the KireiSakura-Kit.\n"
    printf "      -d,  --dir <path>      Set up a custom installation. Must use with -i.\n"
    printf "      -h,  --help            Show this help message and exit.\n"
    printf "      -v,  --version         Show version and exit.\n"
    printf "      -u,  --update          Update to newest version if available.\n"
    printf "      -ul, --update-url      Upstream url. Direct link to '.version'.\n"

    exit 0
}


# version 
show_version() {
  local version_num=$(cat $kirei_dir/.version)

  printf "\n  KireiSakura-Kit ${LAVENDER}v$version_num${RESET}\n"
  # printf "echo -e '\\n  KireiSakura-Kit${LAVENDER} v${version_num} ${RESET}'"
}


# Setup process
init() {
    local kirei_core="$kirei_dir/Utilities/core_functions.sh"  

    printf "\n\n" >> "$log_file"
    logf "====================== NEW SESSION =======================\n"
    logf "Initialization started."
    # printf "clear \n"
    printf "echo -e '\\n${YELLOW}[ INIT ]-> Starting Initialization..${RESET}\\n\\n'\n"
    printf "sleep 1\n"
    

    # Check if kit exists
    if [ "$custom_kit_dir" = true ]; then

        logf   "Custom Kit directory given."
        printf "echo -e '${YELLOW}[!]-> Custom Kit directory given.${RESET}'\n"
        printf "echo -e '${YELLOW}[!]-> Checking it....${RESET}'\n"
    else 
        logf    "Using default Kit installation."
        printf "echo -e '${YELLOW}[!]-> Custom Kit directory not given.${RESET}'\n"
        printf "echo -e '${YELLOW}[!]-> Using default Kit installation.${RESET}'\n"
        printf "echo -e '${YELLOW}[!]-> Validating....${RESET}'\n"
    fi

    if [ ! -d "$kirei_dir" ]; then
      if [ "$custom_kit_dir" = true ]; then
        logf   "Error: given custom kit dir is not valid."
        printf "echo -e '${RED}[X]-> Error: Custom Kit directory does not exist. Please check given directory path.${RESET}'\n"
        printf "echo -e '${RED}[X]-> Exiting.....${RESET}'\n"
        exit 1
      else 
        logf   "Error: Default installation is missing"
        printf "echo -e '${RED}[X]-> Error: Default installation is missing. Please re-install the kit.${RESET}'\n"
        printf "echo -e '${RED}[X]-> Exiting.....${RESET}'\n"
        exit 1
      fi
    else
      if [ "$custom_kit_dir" = true ]; then
        logf "Custom kit dir exists."
        printf "echo -e '${GREEN}[✔]-> Custom Kit directory exists.${RESET}'\n"
      else
        printf "echo -e '${GREEN}[✔]-> Validated default installation.${RESET}'\n" 
      fi
    fi


    # Check if core file exists
    if [ ! -f "$kirei_core" ]; then
         logf   "Error: Core file is missing in kit."
         printf "echo -e '${RED}[X]-> Error: Core file is missing in Kit. Please check installation or re-install.${RESET}'\n"
         printf "Exiting..... \n"
         exit 1
    fi

    local kit_version=$(cat $kirei_dir/.version)

    # Output environment variable setup commands
    printf "kirei_dir=\"%s\"\n" "$kirei_dir" 
    printf "kirei_utils_dir=\"%s/Utilities\"\n" "$kirei_dir"
    printf "kirei_core=\"%s\"\n" "$kirei_core" 
    
    printf "kirei_log_file=\"\${LOG_FILE:-$log_file}\"\n"
    printf "kirei_cache_dir=\"\${CACHE_DIR:-$script_dir}\"\n"

    # Print source and check_dir commands
    printf "sleep 1\n"
    logf    "Importing core file." 
    printf "echo \"${YELLOW}[!]-> Importing core file.${RESET}\" \n"
    printf "source \"\$kirei_core\" \n"
    printf "log 'Imported core file.' success \n"
    logf    "Imported core file." 
    
    # This was the issue part
    printf "sleep 1\n"
    printf "log \"Checking cache directory.....\" inform \n"
    printf "check_dir \"\${kirei_cache_dir}\" -q \n"
    printf "log \"Cache directory exists.\" success \n"
    printf "echo "" \n"
    printf "log \"KireiSakura-Kit v${kit_version}\"  \n"
    printf "sleep 1\n"
    printf "echo \" \\n \" \n"
    printf "log \"Initialization complete.\" success INIT\n"
    logf   "Initialization complete."
}



# Compare local & git versions and return true if git is greater 
has_update() {
    local local_ver="$1"
    local git_ver="$2"

    # Convert versions to numbers by replacing dots with spaces local local_vcode=$(echo "$local_ver" | tr '.' ' ')
    local git_vcode=$(echo "$git_ver" | tr '.' ' ')

    # Compare versions (lexicograpgic comp)
    if [[ "$local_vcode" < "$git_vcode" ]]; then
        return 0  # Update available
    # elif [[ "$local_vcode" > "$git_vcode" ]]; then
    #     return 0  # No update available but warn
    else 
      return 1
    fi
}



update_kit() {
  local upstream_version="$(curl -s -S $upstream_ver_url || echo "")"
  local local_version="$(cat $kirei_dir/.version)"

  # printf "upv: $upstream_version\n"
  # printf "lv:  $local_version\n"

  if [[ -z "$upstream_version" ]]; then
    printf " ${RED}Couldn't resolve upstream version. Please check your connection or the URL.${RESET}\n"
    return 1
  fi

  if has_update "$local_version" "$upstream_version"; then
    printf "\n  ${YELLOW}New update available:${RESET} ${LAVENDER}v${local_version} -> v${upstream_version} ${RESET}\n"
    printf "  ${RED}Auto update is not available yet. Please manually update.${RESET}\n"
  else
    printf "\n  ${GREEN}No new update available.${RESET}\n"
    printf "  KireiSakura-Kit ${LAVENDER}v$local_version${RESET}\n"
    
  fi
}



#_________________________________INITIALISATION_____________________________________________

# Initialize variables
kirei_dir="$HOME/.local/lib/KireiSakura-Kit"
log_file="${LOG_FILE:-KireiSakura-Kit.log}"
script_dir="${CACHE_DIR:-$HOME/.cache/KireiSakura-Kit}"

init_flag=false
custom_kit_dir=false
upstream_ver_url='https://raw.githubusercontent.com/soymadip/KireiSakura-Kit/main/.version'



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
        -u|--update)
            update_kit
            ;;
        -ul|--update-url)
            if [ -n "$2" ]; then
                upstream_ver_url="$2"
                shift  # Shift past the directory path
            else
                printf "\n  ${RED}Error: Upstream URL must be specified after '-ul' or '--update-url'.${RESET}\n"
                exit 1
            fi
            ;;
        -v|--version)
            show_version
            ;;
        -i|--init)
            init_flag=true
            ;;
        -d|--dir)
            if [ -n "$2" ]; then
                custom_kit_dir=true
                kirei_dir="$2"
                shift  # Shift past the directory path
            else
                printf "\n  ${RED}Error: Directory path must be specified after '-d' or '--dir'.${RESET}\n"
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
