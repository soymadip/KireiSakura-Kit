#            _       _ _
#           (_)_ __ (_) |_
#           | | '_ \| | __|
#           | | | | | | |_
# _____ ____|_|_| |_|_|\__|____ _____
#|_____|_____|           |_____|_____|
#
# Initializer of core library

# set -x

#------------Enable aliases in non-interactive shell-----------------------

[[ $- != *i* ]] && shopt -s expand_aliases


#---------------------------- Import Logging ------------------------------

echo -e "[$(date +"%Y.%m.%d %H:%M:%S")] [INFO] Loading Logging." >>"$K_LOG_FILE"

source "$K_LIB_DIR/utils/logging.sh" || {
  echo -e "\e[31m ✗ Error: Failed to load logging.\e[0m"
  exit 1
}

#--------------------- Import Core Library modules ------------------------

log.info "\e[38;5;46mInitializing core library...\e[0m"

[ -z "$K_LIB_DIR" ] && {
  log.error "K_LIB_DIR super variable is not set.Please check above logs for errors."
  exit 1
}

declare -a modules_list=(
# "module/path-->Module-Name"
  "ui/colors-->Colors"
  "ui/elements-->UI-Elements"
  "manager/module-->Module-Manager"
  "manager/package-->Package-Manager"
  "manager/config-->Config-Manager"
  "utils/os-->OS-Utils"
  "utils/util-->Misc-Utils"
)

for module in "${modules_list[@]}"; do
  module_path="${module%-->*}"
  module_name="${module#*-->}"
  {
    source "$K_LIB_DIR/$module_path.sh" &&
    log.success "   Loaded: $module_name."
  }  || {
    log.error "   Failed to load $module_name"
    exit 1
  }
done

log.success "Core library initialized successfully."
