#!/usr/bin/env bash

BOLD="$(tput bold 2>/dev/null || printf '')"
GREY="$(tput setaf 0 2>/dev/null || printf '')"
UNDERLINE="$(tput smul 2>/dev/null || printf '')"
RED="$(tput setaf 1 2>/dev/null || printf '')"
GREEN="$(tput setaf 2 2>/dev/null || printf '')"
YELLOW="$(tput setaf 3 2>/dev/null || printf '')"
BLUE="$(tput setaf 4 2>/dev/null || printf '')"
MAGENTA="$(tput setaf 5 2>/dev/null || printf '')"
NO_COLOR="$(tput sgr0 2>/dev/null || printf '')"

export KIT_NAME="KireiSakura-Kit"
export LIB_DIR="${HOME}/.local/lib"
export BIN_DIR="${HOME}/.local/bin"
export KIT_DIR="${LIB_DIR}/${KIT_NAME}"
export TEMP_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/${KIT_NAME}"

export KIT_REPO="soymadip/${KIT_NAME}"
export KIT_URL="https://github.com/${KIT_REPO}"
export KIT_LOGO="$(
  cat <<"EOF"
 _  ___          _ ____        _                          _  ___ _
 | |/ (_)_ __ ___(_) ___|  __ _| | ___   _ _ __ __ _      | |/ (_) |_
 | ' /| | '__/ _ \ \___ \ / _` | |/ / | | | '__/ _` |_____| ' /| | __|
 | . \| | | |  __/ |___) | (_| |   <| |_| | | | (_| |_____| . \| | |_
 |_|\_\_|_|  \___|_|____/ \__,_|_|\_\\__,_|_|  \__,_|     |_|\_\_|\__|

EOF
)"

info() {
  printf '%s\n' "${BOLD}${GREY}>${NO_COLOR} $*"
}

warn() {
  printf '%s\n' "${YELLOW}! $*${NO_COLOR}"
}

error() {
  printf '%s\n' "${RED}x $*${NO_COLOR}" >&2
}

completed() {
  printf '%s\n' "${GREEN}✓${NO_COLOR} $*"
}


has() {
  command -v "$1" >/dev/null 2>&1
}


confirm_start() {

  warn "Start Installing? [y/n]"
  read -p "-> " cfrm_kk
  if [[ "$cfrm_kk" =~ ^[yY]$ || -z "$cfrm_kk" ]]; then
    info "Starting installation..."
    echo ""
    sleep 0.5
  else
    error "Installation aborted by user."
    error "Exiting...."
    exit 1
  fi
}

get_package_manager() {

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
  elif [[ "$(uname)" == "Darwin" ]]; then
    echo "brew"
  else
    error "Unsupported OS."
    error "Only Linux and macOS are supported."
    exit 1
  fi
}


install_package() {
  local package="$1"
  local pkg_manager="$(get_package_manager)"

  case $pkg_manager in
  pacman)
    sudo pacman -S --noconfirm --needed "$package" > /dev/null
    [ $? -ne 0 ] && return 1
    ;;
  apt)
    sudo apt update > /dev/null
    sudo apt install -y "$package" > /dev/null
    [ $? -ne 0 ] && return 1
    ;;
  dnf)
    sudo dnf install -y "$package" > /dev/null
    [ $? -ne 0 ] && return 1
    ;;
  zypper)
    sudo zypper install -y "$package" > /dev/null
    [ $? -ne 0 ] && return 1
    ;;
  brew)
    brew install "$package" > /dev/null
    [ $? -ne 0 ] && return 1
    ;;
  *)
    error "Unknown package manager."
    error "Unsupported Linux distribution."
    error "Use one (or derivatives) of below distros: "
    error "Debian, Ubuntu, Fedora, Arch, SUSE"
    return 1
    ;;
  esac
  return 0
}


check_deps() {
  info "Checking Dependencies..."
  info "Using package manager: $(get_package_manager)"

  for package in "$@"; do
    if has "$package"; then
      echo -n "  "; completed "Found: $package"
    else
      echo -n "  "; error "Missing: $package"
      echo -n "    "; info "Installing..." 
      install_package "$package" || {
        echo -n "  "; error "Couldn't install dependency: $package"
        echo -n "  "; error "Please manually install it."
        exit 1
      }
      echo -n "    "; completed "Done." 
      echo -n "  "; completed "Installed: $package" 
    fi
  done

  completed "All dependencies are present." && echo ""
  return 1
}


compare() {
  local ver1=(${1//./ })
  local ver2=(${2//./ })

  for i in {0..2}; do
    local v1_part=${ver1[i]:-0}
    local v2_part=${ver2[i]:-0}

    if ((v1_part > v2_part)); then
      return 1
    elif ((v1_part < v2_part)); then
      return 2
    fi
  done

  return 0
}


check_update() {
  local LATEST_VERSION

  info "Checking if already installed..."

  if command -v kireisakura &>/dev/null; then
    local LOCAL_VERSION="$(kireisakura -v | grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+')"

    completed "KireiSakura-Kit is already installed."
    echo ""
    sleep 0.5
    info "Checking for updates..."

    LATEST_VERSION="$(curl -s https://raw.githubusercontent.com/${KIT_REPO}/main/.version)"
    if [[ -z "$LATEST_VERSION" ]]; then
      error "Couldn't resolve upstream version."
      error "Please check your connection."
      exit 1
    fi

    if [[ -n "$LOCAL_VERSION" ]]; then
      compare "$LOCAL_VERSION" "$LATEST_VERSION"

      case $? in
      0)
        completed "KireiSakura-Kit is up-to-date."
        warn "Do you wanna reinstall? [y/n]"
        read -p "> " cfrm_rnstl
        if [[ "$cfrm_rnstl" =~ ^[yY]$ || -z "$cfrm_rnstl" ]]; then
          warn "Reinstalling..."
        else
          completed "OK, See you again next time."
          completed "Sayonara..."
          exit 0
        fi
        ;;
      1)
        warn "Your local installation version is greater than the latest release."
        warn "Do you wanna reinstall? [y/n]"
        read -p "> " cfrm_rnstl1
        if [[ "$cfrm_rnstl1" =~ ^[yY]$ || -z "$cfrm_rnstl1" ]]; then
          warn "Reinstalling..."
          sleep 0.5
        else
          warn "Don't wanna?"
          warn "OK, be careful then."
          exit 1
        fi
        ;;
      2)
        warn "Update available. ($LOCAL_VERSION -> $LATEST_VERSION)"
        ;;
      *)
        error "There is some problem. Please re-run the installer "
        error "Or contact dev at: https://github.com/soymadip/KireiSakura-Kit"
        exit 1
        ;;
      esac
    else
      warn "KireiSakura-Kit is not installed."
      info "Installing..."
    fi
  else
    warn "KireiSakura-Kit is not installed."
    info "Installing..."
  fi

  echo ""
  sleep 0.5
}


check_dir() {
  local DIR="$1"

  if ! mkdir -p "$DIR"; then
    warn "Failed to create directory. Attempting with sudo..."
    if ! sudo mkdir -p "$DIR"; then
      error "Failed to create cache directory."
      error "Please manually create: $DIR"
      exit 1
    fi
  fi
}


download_pkg() {
  local VERSION=${latest:-$1}
  local DOWN_URL="${KIT_URL}/releases/latest/download/${KIT_NAME}.tar.gz"

  [[ "${VERSION}" != "latest" ]] && DOWN_URL="${KIT_URL}/releases/download/${TAG}/${KIT_NAME}.tar.gz"

  info "Creating Cache directory..."
  check_dir "$TEMP_DIR"
  completed "Cache directory created..."
  sleep 0.6

  echo ""; info "Downloading package..."
  curl -L "${DOWN_URL}" -o "${TEMP_DIR}/${KIT_NAME}.tar.gz"
  echo ""
  completed "Downloaded package in Cache dir."; echo ""
  sleep 0.6
}


rlink() {
  local SOURCE="$1"
  local TARGET="$2"

  if ! ln -s -r -i "$SOURCE" "$TARGET"; then
    warn "Failed to link. Attempting with sudo..."
    if ! sudo ln -s -r "$SOURCE" "$TARGET"; then
      error "Failed to link."
      error "Please check source or target."
      exit 1
    fi
  fi
  return 0
}


login_shell() { 
  local SHELL_PATH=$(which $SHELL)
  echo $(basename $SHELL_PATH)
}


add_in_path() {
  local DIR="$1"
  local SHELL="$(login_shell)"
  local SHELL_FILE=""

  if echo "$PATH" | grep -q "$DIR"; then
    completed "Directory is already in PATH."
    return 0
  else
    info "Directory is not in PATH. Adding it..."
    case "$SHELL" in
      zsh)
        info "Shell: ZSH"
        if [ -e "$HOME/.zshenv" ]; then
          SHELL_FILE="$HOME/.zshenv"
          info "Using .zshenv"
        else
          SHELL_FILE="$HOME/.zshrc"
          info "Using .zshrc"
        fi
        ;;
      bash)
        SHELL_FILE="$HOME/.bashrc"
        info "Shell: BASH"
        info "Using .bashrc"
        ;;
      *)
        error "Current shell is not supported."
        exit 1
        ;;
    esac

    info "Adding directory to: $(basename "$SHELL_FILE")"
    echo -e "\n#__ Added by KireiSakura-Kit____" >> "$SHELL_FILE"
    echo -e "export PATH=\"$DIR:\$PATH\"" >> "$SHELL_FILE"
    completed "Added directory to PATH."
  fi
}


install_pkg() {

  info "Checking installation directory..."
  check_dir "${KIT_DIR}"
  completed "Installation directory is OK."; echo ""
  sleep 0.5

  warn "Installing Package..."
  info "Extracting package to proper directories..."
  if ! tar -xzf "${TEMP_DIR}/${KIT_NAME}.tar.gz" -C "${KIT_DIR}"; then
    error "Failed to extract package to $KIT_DIR"
    exit 1
  else 
    completed "Extracted Successfully."
    echo "" && sleep 0.6
  fi

  info "Checking local BIN directory..."
  check_dir "$BIN_DIR"
  add_in_path "$BIN_DIR"
  completed "Local BIN dir check complete."
  echo "" && sleep 0.6

  info "Adding entry in local BIN directory..."
  rlink "${KIT_DIR}/init.sh" "${BIN_DIR}/kireisakura"
  completed "Added entry in BIN directory."
  echo "" && sleep 0.6
}

cleanup() {

  echo " ${GREEN}$KIT_LOGO ${NO_COLOR}"; echo -e "\n"
  warn "Your shell will be restrated to apply changes...";

  
}

#________________ Main Func ________________

main() {

  clear; sleep 0.2
  echo " ${GREEN}$KIT_LOGO ${NO_COLOR}"; echo -e "\n"; sleep 0.4
  confirm_start
  check_deps curl grep ezas
  check_update
  warn "Starting update..."
  download_pkg latest
  install_pkg; sleep 2
  cleanup

}

main
