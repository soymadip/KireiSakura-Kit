log() {
    local log_message=$1
    local log_level=${2:-"  -  "}
    local extra_info=$3


    # Determine color based on log level
    case "$log_level" in
        "error")
            color="${RED}"
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
    

    if starts_with "\n" "$log_message"; then
      log_message=$(trim_char "\n" "$log_message" )
      echo ""
      echo -e "$(date +"%Y-%m-%d %H:%M:%S") " >> "$kirei_log_file"
    fi

    # Format the log message
    if [ -n "$extra_info" ]; then
        # Extra info case
        formatted_message="${color}[ ${extra_info} ]-> ${log_message}${NC}"
    else
        # No extra info case
        case "$log_level" in
            "error")
                prefix="[X]->"
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
    echo -e "$(date +"%Y-%m-%d %H:%M:%S") [$log_level] $log_message" >> "$kirei_log_file"
}


