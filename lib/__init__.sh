#            _       _ _
#           (_)_ __ (_) |_
#           | | '_ \| | __|
#           | | | | | | |_
# _____ ____|_|_| |_|_|\__|____ _____
#|_____|_____|           |_____|_____|
#
# Initializer of core library


#
#--------------------- Get Color Codes ------------------------
eval "$("$(dirname "$0")/_colors.sh")"

#
#--------------------- Setup library modules ------------------------
# This is not integrated in kimport because kimport needs library modules as dependencies itself.
# So, we need to load library modules manually.
lib_modules=(
  "env"
  "ui"
  "logging"
  "os"
  "utils"
  "pkg-utils"
)

echo -e "\e[38;5;245m     -> Loading library modules.\e[0m"

for lib_module in "${lib_modules[@]}"; do
  if source "$K_LIB_DIR/$lib_module.sh"; then
    K_LOADED_MODULES+=("lib.${lib_module}")
  fi
  echo -e "\e[38;5;245m       -> Loaded $lib_module.\e[0m"
done
