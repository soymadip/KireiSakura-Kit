# _  ___                            _
#| |/ (_)_ __ ___  _ __   ___  _ __| |
#| ' /| | '_ ` _ \| '_ \ / _ \| '__| __|
#| . \| | | | | | | |_) | (_) | |  | |_
#|_|\_\_|_| |_| |_| .__/ \___/|_|   \__|
#                 |_|
#
# Import package/local modules with pkg.import


#
#
#==---------------------------------------------------------------------------------
# NAME:   __kimport
# ALIAS:  pkg.import
# DESC:   Import package/local modules.
# USAGE:  pkg.import [<packageName>.<moduleName> | <packageName>.* | <packageName>.<subPackage>.<moduleName> | <packageName>.<subPackage>.* | .<moduleName> | .subdir.moduleName | .*]
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
  local -A modules=() imported_packages=()
  local -a failed=()

  # Log start message only if in debug mode 
  $debug_mode && log.warn "Importing modules....\n" || log.warn "Importing modules..."

  #--------------------------------------------------------------------------
  # STAGE 1: Parse import parameters and build module map
  #--------------------------------------------------------------------------

  # Process each import argument
  while [[ $# -gt 0 ]]; do
    local import_path="$1"
    local module_name=""
    local full_package_path=""

    # Case 1: Local module (.module)
    if [[ "$import_path" == .* ]]; then
      # Special case for local wildcard (.*) - import all local modules
      if [[ "$import_path" == ".*" ]]; then
        local local_modules_dir="$(pwd)/modules"
        
        # Check if local modules directory exists
        if [[ ! -d "$local_modules_dir" ]]; then
          log.error "Local modules directory not found: ./modules"
          failed+=("${GRAY}.${NC}*")
        else
          # Get all .sh files in the local modules dir
          find "$local_modules_dir" -maxdepth 1 -name "*.sh" -type f -exec basename {} \; |
          while read -r file; do
            module_name="${file%.sh}"
            modules["$module_name"]="local"
          done
          
          # Also check for subdirectories in local modules
          find "$local_modules_dir" -maxdepth 1 -type d -not -path "$local_modules_dir" |
          while read -r subdir; do
            # Get the local subdir name
            local local_subdir=$(basename "$subdir")
            if [[ "$local_subdir" != "." && "$local_subdir" != ".." ]]; then
              # For each subdir, add its modules with proper local path
              find "$subdir" -maxdepth 1 -name "*.sh" -type f -exec basename {} \; |
              while read -r subfile; do
                module_name="${subfile%.sh}"
                modules["$local_subdir.$module_name"]="local"
              done
            fi
          done
          
          $debug_mode && log.success "Found local modules to import"
        fi
      else
        # Regular local module import
        modules["${import_path#.}"]="local"
      fi
    
    # Case 2: Wildcard import (package.*)
    elif [[ "$import_path" == *".*" ]]; then
      local wildcard_package="${import_path%.*}"
      local wildcard_dir="$K_PACKAGE_DIR"

      # Handle subpackage wildcards
      if [[ "$wildcard_package" == *"."* ]]; then
        wildcard_dir="$K_PACKAGE_DIR/${wildcard_package//./\/}"
      else
        wildcard_dir="$K_PACKAGE_DIR/$wildcard_package"
      fi

      # Check if directory exists
      if [[ ! -d "$wildcard_dir" ]]; then
        log.error "Package directory not found: $wildcard_package"
        failed+=("${GRAY}${wildcard_package}${NC}.*")
      else
        # First, process the __init__.sh file
        if [[ -f "$wildcard_dir/__init__.sh" ]]; then
          # We'll handle this in Stage 2, just mark it for import
          imported_packages["$wildcard_package"]=0  # 0 = pending import
        fi

        # Get all .sh files in the package (excluding __init__.sh)
        find "$wildcard_dir" -maxdepth 1 -name "*.sh" -type f -not -name "__init__.sh" -exec basename {} \; |

        while read -r file; do
          module_name="${file%.sh}"
          modules["$module_name"]="$wildcard_package"
        done

        # Also check for subpackages (directories) in this package
        find "$wildcard_dir" -maxdepth 1 -type d -not -path "$wildcard_dir" | 

        while read -r subdir; do
          # Get the subpackage name
          local subpkg=$(basename "$subdir")
          if [[ "$subpkg" != "." && "$subpkg" != ".." ]]; then
            # For each subdir, add its modules with proper package path
            find "$subdir" -maxdepth 1 -name "*.sh" -type f -not -name "__init__.sh" -exec basename {} \; |
            while read -r subfile; do
              module_name="${subfile%.sh}"
              modules["$module_name"]="$wildcard_package.$subpkg"
            done
          fi
        done
      fi
    
    # Case 3: Regular module import (package.module or subpackage.module)
    else
      # Extract module name (last part after dot)
      module_name="${import_path##*.}"
      
      # Get package path if it exists
      if [[ "$import_path" == *"."* ]]; then
        # This is a module in a package or subpackage
        modules["$module_name"]="${import_path%.*}"
      else
        # This is a package name (not a module)
        # Try to find the package and import its __init__.sh
        if [[ -d "$K_PACKAGE_DIR/$import_path" ]]; then
          if [[ -f "$K_PACKAGE_DIR/$import_path/__init__.sh" ]]; then
            # Mark this package for initialization
            imported_packages["$import_path"]=0  # 0 = pending import
            $debug_mode && log.success "Will import package: '$import_path'"
          else
            log.warn "Package '$import_path' exists but has no __init__.sh"
          fi
        else
          log.error "Package not found: '$import_path'"
          failed+=("${GRAY}${import_path}${NC}")
        fi
      fi
    fi
    
    shift
  done

  #--------------------------------------------------------------------------
  # STAGE 2: Source package initialization files
  #--------------------------------------------------------------------------
  
  # Process each module to find and source its package initializers
  for module in "${!modules[@]}"; do
    local full_package_path="${modules["$module"]}"
    
    # Skip local modules
    [[ "$full_package_path" == "local" ]] && continue
    
    # Process hierarchical package structure
    if [[ -n "$full_package_path" ]]; then
      # Split package path into components
      IFS='.' read -ra package_parts <<< "$full_package_path"
      
      # Build path incrementally and source each __init__.sh
      local current_path="$K_PACKAGE_DIR"
      local current_pkg=""
      
      for pkg_part in "${package_parts[@]}"; do
        # Update paths
        current_pkg="${current_pkg:+$current_pkg.}$pkg_part"
        current_path="$current_path/$pkg_part"
        
        # Skip if we've already imported this package
        [[ " ${!imported_packages[*]} " =~ " $current_pkg " ]] && continue
        
        # Try to source init file
        local package_init="$current_path/__init__.sh"
        
        if [[ -f "$package_init" ]]; then
          if source "$package_init" 2>/dev/null; then
            imported_packages["$current_pkg"]=1
            $debug_mode && log.success "Sourced package init: '$current_pkg/__init__.sh'"
          else
            log.error "Failed to source package init: '$current_pkg/__init__.sh'"
            failed+=("${GRAY}$current_pkg${NC}/__init__.sh")
          fi
        fi
      done
    fi
  done

  #--------------------------------------------------------------------------
  # STAGE 3: Import actual modules
  #--------------------------------------------------------------------------
  
  # Import index to track order for better error reporting
  local import_idx=0
  
  # Process each module
  for module in "${!modules[@]}"; do
    local full_package_path="${modules["$module"]}"
    local module_path=""
    
    # Build module path based on type
    case "$full_package_path" in
      "local")
        # Check if it's a local module with subdirectory
        if [[ "$module" == *"."* ]]; then
          # Local module in subdirectory (e.g., subdir.module)
          local local_subdir="${module%%.*}"
          local local_module="${module#*.}"
          module_path="$(pwd)/modules/$local_subdir/$local_module.sh"
          module="$local_module"  # Update module name for logging
        else
          # Regular local module
          module_path="$(pwd)/modules/$module.sh"
        fi
        ;;
      "")
        # Empty package path means we're handling a package with wildcard
        # This case shouldn't happen with the updated logic, but keeping for safety
        log.warn "Unexpected module without package: '$module'"
        continue
        ;;
      *)
        # Package/subpackage module
        module_path="$K_PACKAGE_DIR/${full_package_path//./\/}/$module.sh"
        ;;
    esac
    
    # Try to source the module
    if source "$module_path" 2>/dev/null; then
      # Show success message based on module type
      if [[ "$full_package_path" == "local" ]]; then
        log.success "Imported:- '.$module'"
      elif [[ -z "$full_package_path" ]]; then
        log.success "Imported:- '$module'"
      else
        log.success "Imported:- '$full_package_path.$module'"
      fi
      
      # Track imported module
      K_LOADED_MODULES+=("${full_package_path:+$full_package_path.}$module")
    else
      # Handle different formatting for error messages
      if [[ "$full_package_path" == "local" ]]; then
        failed+=("${GRAY}.${module}${NC}")
        log.error "Failed to import local module: '.$module'"
      elif [[ -z "$full_package_path" ]]; then
        failed+=("${GRAY}${module}${NC}")
        log.error "Failed to import module: '$module'"
      else
        failed+=("${GRAY}${full_package_path}${NC}.$module")
        log.error "Failed to import: '$full_package_path.$module'"
      fi
    fi
    
    ((import_idx++))
  done

  #--------------------------------------------------------------------------
  # STAGE 4: Report status
  #--------------------------------------------------------------------------
  
  # Report any failures
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

alias pkg.import='__kimport'

# alias pkg.local.import='__kimport local'