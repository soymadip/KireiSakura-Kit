
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
  local log_level=$1
  local log_message=$2

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

  if __starts_with "\n" "$log_message"; then
    log_message=$(strip "\n" "$log_message")
    echo ""
    echo -e "[$(date '+%Y.%m.%d %H:%M:%S')] " >>"$K_LOG_FILE"
  fi

  # Format the message with bold colored prefix
  formatted_message="${bold_color}${prefix}${NC}${color} ${log_message}${NC}"

  {
    echo -e "$formatted_message" &&
      echo -e "[$(date +"%Y.%m.%d %H:%M:%S")] [$log_level] $log_message" >>"$K_LOG_FILE"
  } && return 0 || return 1
}
#==---------------------------------------------------------------------------------

alias logger=__logger
alias log='__logger info'
alias log.info='__logger info'
alias log.error='__logger error'
alias log.warn='__logger warn'
alias log.success='__logger success'
alias log.nyi='__logger error "NOT YET IMPLEMENTED!"'
