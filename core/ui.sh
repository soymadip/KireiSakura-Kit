# VARIOUS UI ELEMENTS


#
#
#==---------------------------------------------------------------------------------
# NAME:   __welcome
# ALIAS:  welcome
# DESC:   Display welcome screen for the application.
# USAGE:  welcome [<script_name>]
#==---------------------------------------------------------------------------------
__welcome() {
    local script_name=$1
    clear
    printf "\n\n${YELLOW}$(figlet "  Welcome") ${NC}.......to Init-Script\n\n\n"
}
#==---------------------------------------------------------------------------------


#
#
#==---------------------------------------------------------------------------------
# NAME:   __prompt
# ALIAS:  prompt
# DESC:   Prompt asking for user authentication.
# USAGE:  prompt <message> <response_variable> [--no-separator]
# FLAGS:
#         --no-separator    Don't display separator line before prompt.
#==---------------------------------------------------------------------------------
__prompt() {
    local message=$1
    local response_var=$2
    local flag=${3:-""}

    if [ "$flag" != "--no-separator" ]; then
        echo -e "${AQUA}--------------------------${NC}"
    fi

    echo -e "${LAVENDER}[?] ${message}${NC} (y/n)"
    read -p "|==-> " $response_var

    if [ "$confirm_exfunc" == "y" ] || [ "$confirm_exfunc" == "Y" ] || [ -z "$confirm_exfunc" ]; then
        return 0
    else
        return 1
    fi
}
#==---------------------------------------------------------------------------------


#
#
#==---------------------------------------------------------------------------------
# NAME:   __footer
# ALIAS:  footer
# DESC:   Display footer after each module completes.
# USAGE:  footer [<message>] [<status>]
#==---------------------------------------------------------------------------------
__footer() {
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
#==---------------------------------------------------------------------------------
