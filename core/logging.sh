
logger() {
    local log_level=$1
    local log_message=$2
    local extra_info=$3

    case "$log_level" in
        "error")
            color="${RED}"
        ;;
        "warn")
            color="${YELLOW}"
        ;;
        "success")
            color="${GREEN}"
        ;;
        "info")
            color="${BLUE}"
        ;;
        *)
            color="${BLUE}"
        ;;
    esac

    if starts-with "\n" "$log_message"; then
        log_message=$(trim-char "\n" "$log_message")
        echo ""
        echo -e "[$(date '+%Y.%m.%d %H:%M:%S')] " >> "$kirei_log_file"
    fi

    if [ -n "$extra_info" ]; then
        formatted_message="${color}[ ${extra_info} ]-> ${log_message}${NC}"
    else
        case "$log_level" in
            "error")
                prefix="[X]->"
            ;;
            "warn")
                prefix="[!]->"
            ;;
            "success")
                prefix="[✔]->"
            ;;
            "info" | *)
                prefix="[-]->"
            ;;
        esac
        formatted_message="${color}${prefix} ${log_message}${NC}"
    fi

    echo -e "$formatted_message"
    echo -e "[$(date +"%Y.%m.%d %H:%M:%S")] [$log_level] $log_message" >> "$kirei_log_file"
}


alias log='logger info'
alias log.info='logger info'
alias log.error='logger error'
alias log.warn='logger warn'
alias log.success='logger success'
