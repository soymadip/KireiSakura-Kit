#  ____                 _____                 _   _
# / ___|___  _ __ ___  |  ___|   _ _ __   ___| |_(_) ___  _ __  ___
#| |   / _ \| '__/ _ \ | |_ | | | | '_ \ / __| __| |/ _ \| '_ \/ __|
#| |__| (_) | | |  __/ |  _|| |_| | | | | (__| |_| | (_) | | | \__ \
# \____\___/|_|  \___| |_|   \__,_|_| |_|\___|\__|_|\___/|_| |_|___/

#
# Import  modules
# kimport <module1> <module2>
#   -l flag for user modules
#   -a flag for all modules
kimport() {
  local load_all=false
  local called_modules=()
  local module_path
  local failed_imports=()

  while [[ $# -gt 0 ]]; do
    case "$1" in
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

  if [ "$load_all" = true ]; then
    log.warn "Importing All modules....\n" kimport
    for module_path in "$kirei_module_dir"/*.sh; do
      module_name="$(basename "${module_path%.*}")"

      [[ "$module_name" == "_EXAMPLE" ]] && continue

      if source "$module_path"; then
        log "Imported: '$module_name'"
      else
        log.warn "Failed to import: '$module_name'"
        failed_imports+=("$module_name")
      fi
      sleep 0.3
    done
  else
    log.warn "Importing modules....\n" kimport
    for module_name in "${called_modules[@]}"; do
      module_path="$kirei_module_dir/$module_name.sh"

      if [ -f "$module_path" ]; then
        if source "$module_path"; then
          log "Imported: '$module_name'"
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
# Import all files from a directory
# DEPARCIATED. use kimport -a
load-all-from() {
  local directory=$1
  local file_ext=${2:-"sh"}

  for script in "${directory}"/*.${file_ext}; do
    if [ -e "$script" ]; then
      if ! source "$script"; then
        log.error "Failed to load $script"
        exit 1
      fi
    fi
  done
}

#
# Compare two numbers, also works for version numbers.
# return 0 if $1 is equal to $2
# return 1 if $1 is greater than $2
# return 2 if $1 is less than $2
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

# Checks which package manager is available
# though this is not full proof method, it works for most of the cases.
get-package-manager() {

  if [[ "$(uname)" == "Linux" ]]; then
    if has pacman; then
      echo "pacman"
    elif has apt; then
      echo "apt"
    elif has dnf; then
      echo "dnf"
    elif has zypper; then
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
# Install a package using package manager
# uses get-package-manager() to determine package manager
install-package() {
  local package="$1"
  local pkg_manager

  pkg_manager="$(get-package-manager)"

  case $pkg_manager in
  pacman)
    sudo pacman -S --noconfirm --needed "$package" >/dev/null || return 1
    ;;
  apt)
    sudo apt update >/dev/null || return 1
    sudo apt install -y "$package" >/dev/null || return 1
    ;;
  dnf)
    sudo dnf install -y "$package" >/dev/null || return 1
    ;;
  zypper)
    sudo zypper install -y "$package" >/dev/null || return 1
    ;;
  brew)
    brew install "$package" >/dev/null || return 1
    ;;
  *)
    log.error "Unknown package manager."
    log.error "Unsupported Linux distribution."
    log.warn "Use one (or derivatives) of below distros: "
    log.warn "Debian, Ubuntu, Fedora, Arch, SUSE"
    return 1
    ;;
  esac
  return 0
}

#
#
# Check if a dependency is installed
check-dep() {
  local dependency=$1
  local required=$2

  if pacman -Q "$dependency" &>/dev/null; then
    log.success "$dependency is installed."
  else
    log.warn "$dependency is not installed." inform
    if [ -n "$required" ] && [ "$required" == "--needed" ]; then
      log.warn "installing $dependency...."
      install_package "$dependency"
      log.success "$dependency installed."
    else
      prompt "Do you want to install $dependency?" confirm_install --no-separator
      if [ "$confirm_install" == "y" ] || [ "$confirm_install" == "Y" ] || [ -z "$confirm_install" ]; then
        install_package "$dependency"
        log.success "$dependency installed."
      else
        log.warn "$dependency installation was declined by the user."
      fi
    fi
  fi
}

#
# check if a directory exists (make it if it doesn't):
## check_dir <directory> [--needed || --el_exit] [--quiet]
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

#
# Check if a message strats with given char. if yes, srccessfull..
# strats_with <character_to_check> <message_in_which_to_check>
starts-with() {
  local character=$1
  local string=$2

  if [[ "$string" == "$character"* ]]; then
    return 0
  else
    return 1
  fi
}

#
#
trim-char() {
  local character=$1
  local string=$2
  local trimmed_message

  if starts-with "$character" "$string"; then
    trimmed_message="${string#"$character"}"
    echo "$trimmed_message"
  else
    echo "$string"
  fi
}

#
#
cfrm-reboot() {
  log.warn "!" prompt "Reboot is recommended, Do you wanna Reboot?" cfrm_reboot
  if [ "$cfrm_reboot" == "y" ] || [ "$cfrm_reboot" == "Y" ] || [ -z "$cfrm_reboot" ]; then
    log.warn "rebooting..."
    sleep 2
    sudo reboot
  else
    log.success "Ok, Enjoy your system! and don't forget to reboot later.."
    sleep 2
    clear
  fi
}
