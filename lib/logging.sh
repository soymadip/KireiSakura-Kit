#==---------------------------------------------------------------------------------
# NAME:   __logger
# ALIAS:  log.*
# DESC:   Logs the message to the console and log file.
# USAGE:  log.<log_level> [<log_message>]
# TODO: 
#        - Add arg for custom color.
# FIXME: 
#       - Add support for \n escape sequence.
#==---------------------------------------------------------------------------------
__logger() {
  local log_level="info"
  local log_file="$K_LOG_FILE"
  local log_message=""
  
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -l|--log-level)
        log_level="$2"
        shift 2
        ;;
      -f|--log-file)
        log_file="$2"
        shift 2
        ;;
      -* | --*)
        echo "Usage: log.<log_level> [<log_message>]"
        echo "Available log levels: error, warn, success, info, debug"
        return 1
        ;;
      *)
        log_message="$1"
        shift 1
        ;;
    esac
  done

  case "$log_level" in
  "error")
    color="${RED}"
    bold_color="${BOLD_RED}"
    prefix="✗"
    ;;
  "warn")
    color="${YELLOW}"
    bold_color="${BOLD_YELLOW}"
    prefix="⚠"
    ;;
  "success")
    color="${GREEN}"
    bold_color="${BOLD_GREEN}"
    prefix="✓"
    ;;
  "info")
    color="${LAVENDER}"
    bold_color="${BOLD_LAVENDER}"
    prefix="ℹ"
    ;;
  *)
    color="${BLUE}"
    bold_color="${BOLD_BLUE}"
    prefix="➤"
    ;;
  esac

  if [[ "$log_message" == "\n"* ]]; then
    log_message="${log_message#\\n}"
    echo ""
    echo -e "[$(date '+%Y.%m.%d %H:%M:%S')] " >>"$log_file"
  fi

  # Format the message with bold colored prefix
  formatted_message=" ${bold_color}${prefix}${NC}${color} ${log_message}${NC}"

  # Log to file
  echo -e "[$(date +"%Y.%m.%d %H:%M:%S")] [$log_level] $log_message" >>"$log_file"
  
  # Return the formatted message for display
  echo -e "$formatted_message"

  return 0
}
#==---------------------------------------------------------------------------------

alias log='__logger -l info'
alias log.info='__logger -l info'
alias log.error='__logger -l error'
alias log.warn='__logger -l warn'
alias log.success='__logger -l success'
alias log.nyi='__logger -l error "NOT YET IMPLEMENTED!"'
