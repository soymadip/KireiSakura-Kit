# VARIOUS UI ELEMENTS




#welcome system
welcome() {
  local script_name=$1
  clear
  printf "\n\n${YELLOW}$(figlet "  Welcome") ${NC}.......to Init-Script\n\n\n"
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
footer() {
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
