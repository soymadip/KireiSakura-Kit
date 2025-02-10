#  ____                 _____                 _   _
# / ___|___  _ __ ___  |  ___|   _ _ __   ___| |_(_) ___  _ __  ___
#| |   / _ \| '__/ _ \ | |_ | | | | '_ \ / __| __| |/ _ \| '_ \/ __|
#| |__| (_) | | |  __/ |  _|| |_| | | | | (__| |_| | (_) | | | \__ \
# \____\___/|_|  \___| |_|   \__,_|_| |_|\___|\__|_|\___/|_| |_|___/
 


#
#-----------------------------------------------------------
# NAME: Kimport
# DESC: Import user/plugin modules.
# USAGE: kimport <flags> moduleName
#                 OR
#        kimport packageName.moduleName 
# FLAGS:
#     -l,--local Import local modules instead of plugin modules.
#     -a,--all   Import all modules from the modules directory.
# TODO:  Support for packages. (see todo)
#-----------------------------------------------------------
kimport() {
  local local_module=false
  local load_all=false
  local called_modules=()
  local failed_imports=()
  local module_path
  local modules_dir="$kirei_module_dir"

  while [[ $# -gt 0 ]]; do
    case "$1" in
    -l | --local)
      local_module=true
      shift
      ;;
    -a | --all)
      load_all=true
      shift
      ;;
    *)
      called_modules+=("$1")
      shift
      ;;
    esac
  done

  if [ "$local_module" == true ]; then
    modules_dir="$(pwd)/modules"

    if [ ! -d "$modules_dir" ]; then
      log.error "User modules directory not found."
      log.warn "$(echo -e "Check docs: $kirei_docs_url/terminology.html#3._User_modules_0" | sed $'s/\x1b\[[0-9;]*m//g')"
      exit 1
    fi
  fi

  if [ "$load_all" = true ]; then
    log.warn "Importing All modules....\n" kimport
    for module_path in "$modules_dir"/*.sh; do
      module_name="$(basename "${module_path%.*}")"

      [[ "$module_name" == "_EXAMPLE" ]] && continue

      if source "$module_path"; then
        log "Imported:- '$module_name'"
      else
        log.warn "Failed to import: '$module_name'"
        failed_imports+=("$module_name")
      fi
      sleep 0.3
    done
  else
    log.warn "Importing modules....\n" kimport
    for module_name in "${called_modules[@]}"; do
      module_path="$modules_dir/$module_name.sh"

      if [ -f "$module_path" ]; then
        if source "$module_path"; then
          log "Imported:- '$module_name'"
        else
          log.warn "Failed to import: '$module_name'"
          failed_imports+=("$module_name")
        fi
      else
        log.warn "Failed to import '$module_name': doesn't exist."
        failed_imports+=("$module_name")
      fi
      sleep 0.3
    done
  fi

  if [ "${#failed_imports[@]}" -gt 0 ]; then
    echo ""
    log.error " Failed to import modules:" kimport
    for failed_import in "${failed_imports[@]}"; do
      echo -e "\t\t${LAVENDER}$failed_import ${NC}"
    done
    log.warn "Please check your imports." kimport
    exit 1
  else
    log.success "\nImported all modules successfully." kimport
  fi
}

#
#
#----------------------------------------------------------
# DEPARCIATED: use kimport -a
# Import all files from a directory
#----------------------------------------------------------
load-all-from() {
  local dir=$1
  local file_ext=${2:-"sh"}

  for script in "${dir}"/*.${file_ext}; do
    if [ -e "$script" ]; then
      if ! source "$script"; then
        log.error "Failed to load $script"
        exit 1
      fi
    fi
  done
}


#
#
#-----------------------------------------------------------------------
# NAME:  compare-num
# DESC:  Compare 2 numbers. also works for version numbers.
# USAGE: compare-num <number1> <number2>
# Return values:
#    0 :- $1 is equal to $2
#    1 :- $1 is greater than $2
#    2 :- $1 is less than $2
#----------------------------------------------------------------------
compare-num() {
  local ver1
  local ver2

  if [[ $BASH_VERSION ]]; then
    IFS='.' read -r -a ver1 <<<"$1"
    IFS='.' read -r -a ver2 <<<"$2"
  else
    IFS='.' read -rA ver1 <<<"$1"
    IFS='.' read -rA ver2 <<<"$2"
  fi

  for i in {0..2}; do
    local v1_part=${ver1[i]:-0}
    local v2_part=${ver2[i]:-0}

    if ((v1_part > v2_part)); then
      echo 1
      return
    elif ((v1_part < v2_part)); then
      echo 2
      return
    fi
  done

  echo 0
  return 0
}

#
#
#-----------------------------------------------------------------------------------
# NAME: get-package-manager
# DESC: Determine the package manager based on the OS.
# USAGE: get-package-manager
#-----------------------------------------------------------------------------------
get-package-manager() {

  if [[ "$(uname)" == "Linux" ]]; then
    if check-dep -q pacman; then
      echo "pacman"
    elif check-dep -q apt; then
      echo "apt"
    elif check-dep -q dnf; then
      echo "dnf"
    elif check-dep -q zypper; then
      echo "zypper"
    else
      error "Unsupported Linux distribution."
      error "Use one (or derivatives) of below distros: "
      error "Debian, Ubuntu, Fedora, Arch, SUSE"
      exit 1
    fi
    return 0
  elif [[ "$(uname)" == "Darwin" ]]; then
    echo "brew"
    return 0
  else
    error "Unsupported OS."
    error "Only Linux and macOS are supported."
    exit 1
  fi
}
 

#
#
#------------------------------------------------------------------------------------
# NAME: install-package
# DESC: uses get-package-manager() to determine package manager.
#       & installs the package using the package manager.
# USAGE: install-package <package>
# TODO: add support for group install
#------------------------------------------------------------------------------------
install-package() {
  local pkg="$1"
  local pkg_mngr

  pkg_mngr="$(get-package-manager)"

  case $pkg_mngr in
  pacman)
    sudo pacman -S --noconfirm --needed "$pkg" >/dev/null || return 1
    ;;
  apt)
    sudo apt update >/dev/null || return 1
    sudo apt install -y "$pkg" >/dev/null || return 1
    ;;
  dnf)
    sudo dnf install -y "$pkg" >/dev/null || return 1
    ;;
  zypper)
    sudo zypper install -y "$pkg" >/dev/null || return 1
    ;;
  brew)
    brew install "$pkg" >/dev/null || return 1
    ;;
  *)
    log.error "Unsupported Linux distribution."
    log.error "No suppoeted package manager found."
    log.warn "Use one (or derivatives) of below distros: "
    log.warn "Debian, Ubuntu, Fedora, Arch, SUSE"
    return 1
    ;;
  esac
  return 0
}

#
#
#---------------------------------------------------------------------------------
# NAME:  check-dep
# DESC:  Check if a dependency is installed.
# USAGE: check_dir <directory> <flags>
# FLAGS:
#     -q, --quiet    Suppress output
# TODO: reimplement -n/--needed
#---------------------------------------------------------------------------------
check-dep() {
  local dep=()
  local not_found=()
  local be_quiet=false 

  log.warn "Checking dependencies." check-dep

  while [[ $# -gt 0 ]]; do
    case "$1" in
    -q|--quiet)
      be_quiet=true
      shift
      ;;
    *)
      dep+=("$1")
      shift
      ;;
    esac
  done

  if [[ "${#dep[@]}" -eq 0 ]]; then
    log.error "No dependencies provided." check-dep
    return 1
  else
    for pkg in "${dep[@]}"; do
      if command -v "$pkg" &>/dev/null; then
        [[ "$be_quiet" = false ]] && log.success "$pkg is installed."
      else
        [[ "$be_quiet" = false ]] && log.warn "$pkg is not installed."
        not_found+=("$pkg")
      fi
    done

    if [[ "${#not_found[@]}" -gt 0 ]]; then
      log.error "Not installed dependency(s):" check-dep
      for ndep in "${not_found[@]}"; do
        echo -e "\t\t${LAVENDER}$ndep ${NC}"
      done
      return 1
    else
      return 0
    fi
  fi
}


#
#
#-------------------------------------------------------------------------------
# FUNC:  check_dir
# DESC:  Check if a directory exists and optionally create it.
# USAGE: check_dir <directory> <flags>
# FLAGS:
#     -n, --needed   Create the directory if it doesn't exist
#     -e, --el_exit  Exit if the directory doesn't exist
#     -q, --quiet    Suppress output
#-------------------------------------------------------------------------------
check-dir() {
  local dir=$1
  local is_needed=0
  local el_exit=0
  local is_quiet=0

  if [[ -z "$dir" ]]; then
    echo "Error: Directory parameter is required."
    return 1
  fi

  shift
  while [[ $# -gt 0 ]]; do
    case "$1" in
    -n | --needed)
      is_needed=1
      ;;
    -e | --el_exit)
      el_exit=1
      ;;
    -q | --quiet)
      is_quiet=1
      ;;
    *)
      echo "Invalid option: $1"
      return 1
      ;;
    esac
    shift
  done

  if [[ "$is_needed" -eq 1 && "$el_exit" -eq 1 ]]; then
    log.error "Invalid flags given: --needed and --el_exit cannot be used together."
    return 1
  fi

  if [[ -d "$dir" ]]; then
    [[ "$is_quiet" -ne 1 ]] && log.warn "Directory '$dir' already exists."
  else
    [[ "$is_quiet" -ne 1 ]] && log.warn "Directory '$dir' does not exist."

    if [[ "$is_needed" -eq 1 ]]; then
      [[ "$is_quiet" -ne 1 ]] && log.warn "Creating directory '$dir'..."

      if mkdir -p "$dir" 2>/dev/null; then
        [[ "$is_quiet" -ne 1 ]] && log.success "Directory '$dir' created successfully."
      else
        log.warn "Failed to create directory '$dir'. Attempting with sudo..."
        if sudo mkdir -p "$dir"; then
          [[ "$is_quiet" -ne 1 ]] && log.success "Directory '$dir' created successfully with sudo."
        else
          log.error "Failed to create directory '$dir' with sudo."
          return 1
        fi
      fi
    fi

    if [[ "$el_exit" -eq 1 ]]; then
      log.error "Exiting as requested by --el_exit flag."
      exit 1
    fi
  fi
}


#------------------------------------------------------------------------------
# NAME: starts-with
# DESC: Check if a string starts with a given prefix.
# USAGE: starts-with <string> <prefix>
#------------------------------------------------------------------------------
starts-with() {
  local str="$1"
  local prfx="$2"
  [[ "${str#"$prfx"}" != "$str" ]]
}

#
#
#------------------------------------------------------------------------------
# NAME: ends-with
# DESC: Check if a string ends with a given suffix.
# USAGE: ends-with <string> <suffix>
#------------------------------------------------------------------------------
ends-with() {
  local str="$1"
  local suffix="$2"
  [[ "${str%"$suffix"}" != "$str" ]]
}

#
#
#--------------------------------------------------------------------------
# NAME: len
# DESC: gets the length of a string.
# USAGE: len <string>
#--------------------------------------------------------------------------
len() {
echo "${#1}"
}

#
#
#-----------------------------------------------------------------------
# NAME: strip
# DESC: Trim a leading & trailing character from a string.
# USAGE: strip <string from to remove> <character to strip> 
#        if no arg, strip whitespaces.
# FLAGS:
#   -s,--start  Strip only leading char.
#   -e,--end    Strip only trailing char.
#-------------------------------------------------------------------------
strip() {
  local string character
  local strip_start=false strip_end=false

  while [[ $# -gt 0 ]]; do
    case "$1" in
      -s | --start)
        strip_start=true
        shift
        ;;
      -e | --end)
        strip_end=true
        shift
        ;;
      *)
        if [[ -z "$string" ]]; then
          string="$1"
        elif [[ -z "$character" ]]; then
          character="$1"
        fi
        shift
        ;;
    esac
  done

  character="${character:- }"

  # Default to stripping whitespace
  if [[ "$strip_start" == false && "$strip_end" == false ]]; then
    strip_start=true
    strip_end=true
  fi


  # Strip leading occurrences of character
  if [[ "$strip_start" == true ]]; then
    while [[ "$string" == "$character"* ]]; do
      string="${string#"$character"}"
    done
  fi

  # Strip trailing occurrences of character
  if [[ "$strip_end" == true ]]; then
    while [[ "$string" == *"$character" ]]; do
      string="${string%"$character"}"
    done
  fi

  echo "$string"
}


#
#
#--------------------------------------------------------------------------
# NAME:  hyprlink
# DESC:  Print hyprlink in terminal.
# USAGE: hyprlink <url> <text>
#-------------------------------------------------------------------------
hyperlink() {
    local url="$1"
    local text="${2:-$1}" 
    echo -e "\e]8;;${url}\e\\${text}\e]8;;\e\\"
}