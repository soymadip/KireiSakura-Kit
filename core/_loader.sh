# _                 _
#| | ___   __ _  __| | ___ _ __
#| |/ _ \ / _` |/ _` |/ _ \ '__|
#| | (_) | (_| | (_| |  __/ |
#|_|\___/ \__,_|\__,_|\___|_|
#
# Load core parts of kireiSakura-Kit
# Initialize everything needed.


#--------------------- Setup core modules ------------------------

# This is not integrated in kimprt because kimport needs core modules as dependencies itself.
# So, we need to load core modules manually.
core_modules=("env" "colors" "ui" "logging" "utils")

echo -e "\e[38;5;245m     -> Loading core modules.\e[0m"
for core_module in "${core_modules[@]}"; do
  source "$kirei_core_dir/$core_module.sh" && kirei_loaded_modules+=("$core_module")
  echo -e "\e[38;5;245m       -> Loaded $core_module.\e[0m"
done

#
#
#-----------------------------------------------------------
# NAME:  Kimport
# DESC:  Import package/local modules.
# USAGE: kimport packageName.moduleName 
#                 OR
#        kimport packageName
#                 OR
#        kimport .moduleName
#                 OR
#        kimport .
# TODO:
#      - Add . or packageName. to import all local/plugin modules.
#      - adapt to dependency related todos.
#-----------------------------------------------------------
kimport() {
  local -A modules 
  local failed=() module_path=""

  log.warn "Importing modules....\n" kimport

  while [[ $# -gt 0 ]]; do
    # split into {"module": "package"} dictionary
    if [[ "$1" == .* ]]; then
      modules["${1#.}"]="local"
      shift
    else
      modules["${1#*.}"]="${1%%.*}"
      shift
    fi
  done

  # modules: {"module": "package"}
  ## path: 
  ##     - Plugin: $kirei_package_dir/package/module.sh
  ##     - Local: $pwd/modules/module.sh
  for module in "${!modules[@]}"; do

    if [[ "${modules["$module"]}" == "local" ]]; then
      module_path="$(pwd)/modules/$module.sh"
    else
      module_path="$kirei_package_dir/${modules["$module"]}/$module.sh"
    fi

    if source "$module_path" 2>/dev/null; then
      log.success "Imported:- '$module'"
    else
      log.error "Failed to import: '$module'"
      failed+=("${GRAY}${modules["$module"]}${NC}.$module")
    fi
  done

  if [ "${#failed[@]}" -gt 0 ]; then
    log.error " Failed to import modules:" kimport
    for failed_import in "${failed[@]}"; do
      echo -e "\t\t${LAVENDER}$failed_import ${NC}"
    done
    log.warn "Please check your imports." kimport
    exit 1
  else
    log.success "\nImported all modules successfully." kimport
  fi

}