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



#--------------------- Get Color Codes ------------------------
echo -e "[$(date +"%Y.%m.%d %H:%M:%S")] [INFO] Loading color codes." >>"$K_LOG_FILE"

eval "$("$(dirname "$0")/_colors.sh")" || {
  echo -e "${RED}Error: Failed to load color codes.${NC}"
  exit 1
}


#--------------------- Import Logging ------------------------

echo -e "[$(date +"%Y.%m.%d %H:%M:%S")] [INFO] Loading Logging." >>"$K_LOG_FILE"

source "$K_LIB_DIR/logging.sh" || {
  echo -e "${RED}Error: Failed to load logging module.${NC}"
  exit 1
}


#--------------------- Setup library modules ------------------------
# This is not integrated in kimport because kimport needs library modules as dependencies itself.
# So, we need to load library modules manually.
lib_modules=(
  "ui"
  "module-manager"
  "os"
  "util"
)

log.info "Initializing core library..."

for lib_module in "${lib_modules[@]}"; do
  if source "$K_LIB_DIR/$lib_module.sh"; then
    K_LOADED_MODULES+=("lib.${lib_module}")
    echo -e "\e[38;5;245m    -> Loaded $lib_module.\e[0m"
  else
    echo -e "\e[38;5;196m    -> Failed to load $lib_module!\e[0m" 
    exit 1
  fi
done

log.success "All library modules loaded successfully."
