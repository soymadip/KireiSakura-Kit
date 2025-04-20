# _  ___                            _
#| |/ (_)_ __ ___  _ __   ___  _ __| |
#| ' /| | '_ ` _ \| '_ \ / _ \| '__| __|
#| . \| | | | | | | |_) | (_) | |  | |_
#|_|\_\_|_| |_| |_| .__/ \___/|_|   \__|
#                 |_|
#
# Import package/local modules.


#
#
#-----------------------------------------------------------
# USAGE: kimport packageName.moduleName 
#                 OR
#        kimport packageName.*
#                 OR
#        kimport moduleName
#                 OR
#        kimport *
# FIXME: 
#      - If module name is same for 2 packages,
#        it causes overwrite in packagename of module in modules dict.
# TODO:
#      - Add . or packageName. to import all local/plugin modules.
#      - adapt to dependency related todos.
#-----------------------------------------------------------
kimport() {
  local -A modules 
  local module_path="" package="" package_init=""
  local failed=() imported_packages=()

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

  # First source all package __init__.sh
  for module in "${!modules[@]}"; do
    package="${modules["$module"]}"

    # Skip local modules and already imported packages
    if [[ "$package" != "local" && ! " ${imported_packages[*]} " =~ " $package " ]]; then
      package_init="$k_package_dir/$package/__init__.sh"

      if [[ -f "$package_init" ]]; then
        if source "$package_init" 2>/dev/null; then
          log.success "Sourced package init: '$package/__init__.sh'"
          imported_packages+=("$package")
        else
          log.error "Failed to source package init: '$package/__init__.sh'"
          failed+=("${GRAY}$package${NC}/__init__.sh")
        fi
      fi
    fi
  done

  # modules: {"module": "package"}
  ## path: 
  ##     - Plugin: $k_package_dir/package/module.sh
  ##     - Local: $pwd/modules/module.sh
  for module in "${!modules[@]}"; do

    if [[ "${modules["$module"]}" == "local" ]]; then
      module_path="$(pwd)/modules/$module.sh"
    else
      module_path="$k_package_dir/${modules["$module"]}/$module.sh"
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
    log.success "Imported all modules successfully." kimport
  fi

}
