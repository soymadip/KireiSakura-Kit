# VARIOUS UI ELEMENTS


#
#
#==---------------------------------------------------------------------------------
# NAME:   __prompt
# ALIAS:  ui.prompt
# DESC:   Prompt asking for user authentication.
# USAGE:  ui.prompt <message> [--no-separator]
#==---------------------------------------------------------------------------------
__prompt() {
    local message=$1
    local answer_var

    echo -e "${LAVENDER}[?] ${message}${NC} (y/n)"
    read -p "|==-> " answer_var

    case "$answer_var" in
        [yY] | "")
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

#==---------------------------------------------------------------------------------


#
#
#==---------------------------------------------------------------------------------
# NAME:   __footer
# ALIAS:  ui.footer
# DESC:   Display footer after each module completes.
# USAGE:  ui.footer [<message>] [<status>]
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



#_______________________________ Aliases _______________________________

alias ui.prompt='__prompt'
alias ui.footer='__footer'