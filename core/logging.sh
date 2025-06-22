#
#
#==---------------------------------------------------------------------------------
# NAME:   __logger
# ALIAS:  logger
# DESC:   Logs the message to the console and log file.
# USAGE:  logger [<log_level>] [<log_message>] [<extra_info>]
# FLAGS:
#==---------------------------------------------------------------------------------
__logger() {
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
    color="${LAVENDER}"
    ;;
  *)
    color="${BLUE}"
    ;;
  esac

  if starts-with "\n" "$log_message"; then
    log_message=$(strip "\n" "$log_message")
    echo ""
    echo -e "[$(date '+%Y.%m.%d %H:%M:%S')] " >>"$k_log_file"
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

  {
    echo -e "$formatted_message" &&
      echo -e "[$(date +"%Y.%m.%d %H:%M:%S")] [$log_level] $log_message" >>"$k_log_file"
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
