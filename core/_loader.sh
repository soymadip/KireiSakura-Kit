# _                 _
#| | ___   __ _  __| | ___ _ __
#| |/ _ \ / _` |/ _` |/ _ \ '__|
#| | (_) | (_| | (_| |  __/ |
#|_|\___/ \__,_|\__,_|\___|_|
#
# Load core parts of kireiSakura-Kit
# Initialize everything needed.


#
#--------------------- Get Color Codes ------------------------
eval "$("$(dirname "$0")/_colors.sh")"

#
#--------------------- Setup core modules ------------------------
# This is not integrated in kimprt because kimport needs core modules as dependencies itself.
# So, we need to load core modules manually.
core_modules=(
  "env"
  "ui"
  "logging"
  "utils"
  "kimport"
  )

echo -e "\e[38;5;245m     -> Loading core modules.\e[0m"

# Use the core directory path from kireisakura script
for core_module in "${core_modules[@]}"; do
  if source "$(dirname "$0")/$core_module.sh"; then
    k_loaded_modules+=("$core_module")
  fi
  echo -e "\e[38;5;245m       -> Loaded $core_module.\e[0m"
done
