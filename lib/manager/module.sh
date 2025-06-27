#        _                     _   _ _
#  _ __ | | ____ _       _   _| |_(_) |___
# | '_ \| |/ / _` |_____| | | | __| | / __|
# | |_) |   < (_| |_____| |_| | |_| | / __|
# | .__/|_|\_\__, |      \__,_|\__|_|_|___/
# |_|        |___/
#
# Module Manager - Import packages/modules and manage dependencies


#
#
#==---------------------------------------------------------------------------------
# NAME:   __kimport
# ALIAS:  mod.import
# DESC:   Import package/local modules.
# USAGE:  mod.import [<packageName>.<moduleName> | <packageName>.* | <packageName>.<subPackage>.<moduleName> | <packageName>.<subPackage>.* | .<moduleName> | .subdir.moduleName | .*]
# PARAMS:
#         - packageName.moduleName: Import specific module from a package
#         - packageName.*: Import all modules from a package (including subpackages)
#         - packageName.subPackage.moduleName: Import specific subpackage module
#         - packageName.subPackage.*: Import all modules from a subpackage
#         - .moduleName: Import local module from project's modules/ directory
#         - .subdir.moduleName: Import local module from subdirectory in modules/
#         - .*: Import all local modules (including subdirectories)
# OPTS:   None
# NOTES:  - Local modules must be located in the `modules/` directory of the project
#         - When K_DEBUG_MODE is true, verbose logging is enabled
#==---------------------------------------------------------------------------------
__kimport() {
  local debug_mode=${K_DEBUG_MODE:-false}

  # Initialize data structures
  local -A modules_to_import=() # Will hold module->package mappings
  local -A imported_packages=() # Track imported package __init__.sh files
  local -a failed=() # Track failed imports

  # Log start message
  $debug_mode && log.warn "Importing modules....\n" || log.warn "Importing modules..."

  #--------------------------------------------------------------------------
  # STAGE 1: Parse all arguments and build a list of modules to import
  #--------------------------------------------------------------------------
  while [[ $# -gt 0 ]]; do
    local arg="$1"
    
    # Case 1: Local module import (.module or .*)
    if [[ "$arg" == .* ]]; then
      if [[ "$arg" == ".*" ]]; then
        # Import all local modules (processed later)
        local local_modules_dir="$(pwd)/modules"
        
        if [[ ! -d "$local_modules_dir" ]]; then
          log.error "Local modules directory not found: $local_modules_dir"
          failed+=("${GRAY}.${NC}*")
        else
          # Find all .sh files in modules dir and subdirectories
          find "$local_modules_dir" -name "*.sh" -type f | while read -r module_path; do
            # Get the relative path from modules/
            local rel_path="${module_path#$local_modules_dir/}"
            # Strip .sh extension
            rel_path="${rel_path%.sh}"
            
            if [[ "$rel_path" == */* ]]; then
              # This is a module in a subdirectory
              modules_to_import[".$rel_path"]="local"
            else
              # This is a module directly in modules/
              modules_to_import[".$rel_path"]="local"
            fi
          done
        fi
      else
        # Regular local module (.module)
        modules_to_import["$arg"]="local"
      fi
    
    # Case 2: Package wildcard import (package.*)
    elif [[ "$arg" == *".*" ]]; then
      local pkg="${arg%.*}"
      local pkg_dir="$K_PACKAGE_DIR/${pkg//./\/}"
      
      if [[ ! -d "$pkg_dir" ]]; then
        log.error "Package directory not found: $pkg"
        failed+=("${GRAY}${pkg}${NC}.*")
      else
        # Mark to import __init__.sh if exists
        if [[ -f "$pkg_dir/__init__.sh" ]]; then
          imported_packages["$pkg"]=0
        fi
        
        # Find all .sh files in the package dir and subdirs
        find "$pkg_dir" -name "*.sh" -type f -not -name "__init__.sh" | while read -r module_path; do
          # Get the relative path from package dir
          local rel_path="${module_path#$pkg_dir/}"
          # Strip .sh extension
          rel_path="${rel_path%.sh}"
          
          if [[ "$rel_path" == */* ]]; then
            # This is a module in a subdirectory
            local subdir="${rel_path%/*}"
            local module="${rel_path##*/}"
            modules_to_import["$pkg.$subdir.$module"]="$pkg.$subdir"
          else
            # This is a module directly in the package
            modules_to_import["$pkg.$rel_path"]="$pkg"
          fi
        done
      fi
    
    # Case 3: Specific module import (package.module)
    else
      local pkg
      local module
      
      if [[ "$arg" == *"."* ]]; then
        # It's a package.module format
        pkg="${arg%.*}"
        module="${arg##*.}"
        
        # Check if the module exists
        local module_path="$K_PACKAGE_DIR/${pkg//./\/}/$module.sh"
        if [[ -f "$module_path" ]]; then
          modules_to_import["$arg"]="$pkg"
          
          # Check if we need to import package init
          local pkg_path="$K_PACKAGE_DIR/${pkg//./\/}"
          if [[ -f "$pkg_path/__init__.sh" ]]; then
            imported_packages["$pkg"]=0
          fi
        else
          log.error "Module not found: $arg"
          failed+=("${GRAY}${arg}${NC}")
          shift
          continue
        fi
      else
        # It's just a package name, try to import __init__.sh
        local pkg_path="$K_PACKAGE_DIR/$arg"
        if [[ -d "$pkg_path" && -f "$pkg_path/__init__.sh" ]]; then
          imported_packages["$arg"]=0
        else
          log.error "Package not found or has no __init__.sh: $arg"
          failed+=("${GRAY}${arg}${NC}")
          shift
          continue
        fi
      fi
    fi
    
    shift
  done

  #--------------------------------------------------------------------------
  # STAGE 2: Source all package __init__.sh files
  #--------------------------------------------------------------------------
  for pkg in "${!imported_packages[@]}"; do
    if [[ "${imported_packages[$pkg]}" == "0" ]]; then
      # Need to import this package's __init__.sh
      local path="$K_PACKAGE_DIR/${pkg//./\/}/__init__.sh"
      if source "$path" 2>/dev/null; then
        imported_packages["$pkg"]=1
        $debug_mode && log.success "Sourced package init: '$pkg/__init__.sh'"
      else
        log.error "Failed to source package init: '$pkg/__init__.sh'"
        failed+=("${GRAY}$pkg${NC}/__init__.sh")
      fi
    fi
  done

  #--------------------------------------------------------------------------
  # STAGE 3: Source all modules
  #--------------------------------------------------------------------------
  for import_path in "${!modules_to_import[@]}"; do
    local pkg="${modules_to_import[$import_path]}"
    local module_path=""
    local display_name=""
    
    if [[ "$pkg" == "local" ]]; then
      # Handle local module
      local module_name="${import_path#.}"
      if [[ "$module_name" == *"/"* ]]; then
        # Module in subdirectory
        module_path="$(pwd)/modules/$module_name.sh"
      else
        # Module directly in modules/
        module_path="$(pwd)/modules/$module_name.sh"
      fi
      display_name=".$module_name"
    else
      # Handle package module
      if [[ "$import_path" == *"."* ]]; then
        # This is a full package.module path
        module_path="$K_PACKAGE_DIR/${import_path//./\/}.sh"
        display_name="$import_path"
      else
        # Just a module name
        module_path="$K_PACKAGE_DIR/${pkg//./\/}/$import_path.sh"
        display_name="$pkg.$import_path"
      fi
    fi
    
    # Try to source the module
    if [[ -f "$module_path" ]]; then
      if source "$module_path" 2>/dev/null; then
        log.success "Imported:- '$display_name'"
        # Add to loaded modules list
        K_LOADED_MODULES+=("$display_name")
      else
        log.error "Failed to import: '$display_name'"
        failed+=("${GRAY}${display_name}${NC}")
      fi
    else
      log.error "Module file not found: $module_path ($display_name)"
      failed+=("${GRAY}${display_name}${NC} (file not found)")
    fi
  done

  #--------------------------------------------------------------------------
  # STAGE 4: Report status
  #--------------------------------------------------------------------------
  if [ "${#failed[@]}" -gt 0 ]; then
    log.error "Failed to import modules:"
    for failed_import in "${failed[@]}"; do
      echo -e "\t\t${LAVENDER}$failed_import ${NC}"
    done
    log.warn "Please check your imports."
    exit 1
  else
    log.success "Imported all modules successfully."
  fi
}
#==---------------------------------------------------------------------------------

alias mod.import='__kimport'
# alias mod.local.import='__kimport local'
alias pkg.install='kpm install'
alias pkg.update='kpm update'
alias pkg.remove='kpm remove'
alias pkg.list='kpm list'
