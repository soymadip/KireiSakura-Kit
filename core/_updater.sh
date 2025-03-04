#!/usr/bin/env bash

shopt -s expand_aliases
alias echos='echo -n "  "'


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

clearx() {
  if [[ "$(uname)" == "Darwin" ]]; then
    clear
  else
    clear -x
  fi
}

print_header() {
  local ktcolor="${1:-BLUE}"
  shift

  clearx
  echo -e " ${!ktcolor}$KIT_LOGO ${NO_COLOR}\n\n"
  sleep 0.3
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

install_package() {
  local package="$1"
  local pkg_manager="$(get_package_manager)"

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
  print_header
  warn "Checking Installer Dependencies..."
  sleep 0.3
  echos
  info "Package manager: $(get_package_manager)"
  sleep 0.3

  for package in "$@"; do
    if has "$package"; then
      echos
      completed "Found: $package"
      sleep 0.2
    else
      echos
      error "Missing: $package"
      echo -n "    "
      info "Installing..."
      install_package "$package" || {
        echos
        error "Couldn't install dependency: $package"
        echos
        error "Please manually install it."
        exit 1
      }
      echo -n "    "
      completed "Done."
      echos
      completed "Installed: $package"
    fi
  done

  completed "All dependencies are present."
  echo ""
  sleep 1.5
  return 0
}

compare() {
  mapfile -t ver1 < <(echo "$1" | tr '.' '\n')
  mapfile -t ver2 < <(echo "$2" | tr '.' '\n')

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
  local LATEST_VERSION=""
  local LOCAL_VERSION=""

  print_header
  warn "Checking if already installed..."

  if command -v kireisakura &>/dev/null; then
    completed "KireiSakura-Kit is already installed."
    sleep 0.6
    echo ""
    info "Checking for updates..."

    LOCAL_VERSION="$(kireisakura -v | grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+')"
    echos
    info "Local:  $LOCAL_VERSION"

    LATEST_VERSION="$(curl -s https://raw.githubusercontent.com/${KIT_REPO}/main/.version)"
    if [[ -z "$LATEST_VERSION" ]]; then
      echos
      error "Failed."
      error "Couldn't resolve upstream version."
      error "Please check your internet connection."
      exit 1
    fi
    echos
    info "Latest: $LATEST_VERSION"

    if [[ -n "$LOCAL_VERSION" ]]; then
      compare "$LOCAL_VERSION" "$LATEST_VERSION"

      case $? in
      0)
        completed "KireiSakura-Kit is up-to-date."
        echo
        sleep 0.6
        warn "Do you wanna reinstall? [y/n]"
        read -p "> " cfrm_rnstl
        if [[ "$cfrm_rnstl" =~ ^[yY]$ || -z "$cfrm_rnstl" ]]; then
          warn "Reinstalling..."
          sleep 0.6
        else
          completed "OK, See you again next time."
          completed "Sayonara..."
          exit 0
        fi
        ;;
      1)
        eror "Your local installation is greater than the latest release?"
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
        info "Starting update...."
        sleep 0.6
        ;;
      *)
        error "There's some problem. Please re-run the installer "
        error "Or contact dev at: $KIT_URL"
        exit 1
        ;;
      esac
    else
      error "Your installation has problems."
      warn "Do you wanna reinstall? [y/n]"
      read -p "> " cfrm_rnstl2
      if [[ "$cfrm_rnstl2" =~ ^[yY]$ || -z "$cfrm_rnstl2" ]]; then
        warn "Reinstalling..."
        sleep 0.5
      else
        error "Installation Cancelled by user."
        warn "Sayodada..."
        sleep 2
        clearx
        exit 1
      fi
    fi
  else
    error "KireiSakura-Kit is not installed."
    info "Starting Installation..."
  fi

  sleep 1.5
}

rm_dir() {
  local DIR="$1"

  { rm -rf $TEMP_DIR && sleep 0.7; } || {
    echos
    error "Failed."
    echos
    error "Please manually delete: $TEMP_DIR"
  }
}

check_dir() {
  local DIR="$1"

  if [ -d "$DIR" ]; then
    completed "Directory already exists."
    return 0
  fi

  if mkdir -p "$DIR"; then
    return 0
  else
    warn "Failed to create directory. Attempting with sudo..."
    if ! sudo mkdir -p "$DIR"; then
      error "Failed to create directory."
      error "Please manually create: $DIR"
      exit 1
    else
      return 0
    fi
  fi
}

download_kit() {
  local VERSION=${1:-latest}
  local DOWN_URL="${KIT_URL}/releases/latest/download/${KIT_NAME}.tar.gz"

  print_header

  [[ "${VERSION}" != "latest" ]] && DOWN_URL="${KIT_URL}/releases/download/${VERSION}/${KIT_NAME}.tar.gz"

  warn "Creating Cache directory..."
  check_dir "$TEMP_DIR"
  sleep 0.2
  completed "Cache directory created..."
  sleep 0.6

  echo ""
  info "Downloading package..."
  curl -L "${DOWN_URL}" -o "${TEMP_DIR}/${KIT_NAME}.tar.gz"
  echo ""
  completed "Downloaded package in Cache dir."
  echo ""
  sleep 1.5
}

rlink() {
  local SOURCE="$1"
  local TARGET="$2"

  if ! ln -sf -r "$SOURCE" "$TARGET"; then
    warn "Failed to link. Attempting with sudo..."
    if ! sudo ln -sf -r "$SOURCE" "$TARGET"; then
      error "Failed to link."
      error "Please check source or target."
      exit 1
    fi
  fi
  return 0
}

login_shell() {
  local SHELL_PATH=$(which "$SHELL")
  echo "$(basename "$SHELL_PATH")"
}

add_in_path() {
  local DIR="$1"
  local LSHELL="$(login_shell)"
  local SHELL_FILE=""

  if echo "$PATH" | grep -q "$DIR"; then
    completed "Directory is already in PATH."
    return 0
  else
    info "Directory is not in PATH. Adding it..."
    case "$LSHELL" in
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
      info "Shell: Bash"
      if [ -e "$HOME/.bash_profile" ]; then
        SHELL_FILE="$HOME/.bash_profile"
        info "Using .bash_profile"
      else
        SHELL_FILE="$HOME/.bashrc"
        info "Using .bashrc"
      fi
      ;;
    *)
      error "Current shell is not supported."
      exit 1
      ;;
    esac

    info "Adding directory to: $(basename "$SHELL_FILE")"
    if string_present "export PATH=\"$DIR:\$PATH\"" "$SHELL_FILE"; then
      completed "PATH entry is already in $SHELL_FILE."
    else
      echo -e "\n#__ Added by KireiSakura-Kit____" >>"$SHELL_FILE"
      echo -e "export PATH=\"$DIR:\$PATH\"" >>"$SHELL_FILE"
      completed "Added directory to PATH."
      info "Shell will be reloaded later."
    fi
  fi
}

install_kit() {

  print_header
  warn "Checking installation directory...."
  check_dir "${KIT_DIR}"
  completed "Installation directory is OK."
  echo ""
  sleep 1.5

  print_header
  warn "Installing Kit..."
  info "Extracting kit binary to proper directories...."
  sleep 0.3
  if ! tar -xzf "${TEMP_DIR}/${KIT_NAME}.tar.gz" -C "${KIT_DIR}"; then
    error "Failed to extract kit binary to $KIT_DIR"
    exit 1
  else
    completed "Extracted Successfully."
    echo "" && sleep 0.9
  fi

  info "Checking local BIN directory...."
  check_dir "$BIN_DIR"
  add_in_path "$BIN_DIR"
  completed "Local BIN dir check complete."
  
  info "Installing 'yq'..."
  if ! curl -L $YQ_BIN_URL -o $BIN_DIR/yq; then
    error "Failed to download 'yq'."
    exit 1
  fi
  if ! chmod +x $BIN_DIR/yq; then
    error "Failed to make 'yq' executable."
    exit 1
  fi
  echo "" && sleep 0.9

  completed "Installation complete."
  sleep 1.5
}

string_present() {
  local string="$1"
  local file="$2"

  if grep -qF "$string" "$file"; then
    return 0
  else
    return 1
  fi
}

cleanup() {

  print_header
  warn "Cleaning up...."

  echos
  info "Cleaning Cache dir.."
  rm_dir "$TEMP_DIR"
  echos
  completed "Done."

  echos
  info "Cleaning LIB dir.."
  sleep 1
  echos
  completed "Done."

  completed "Done cleaning up."
  sleep 2
}

sayonada() {

  print_header "GREEN"
  completed "Latest release version is now installed in your system."

  if [[ "$1" == "-s" ]]; then
    sleep 3
    print_header "GREEN"
    completed "Sourcing Kit...."
    eval "$(bash "$BIN_DIR/kireisakura" -i)"
  else
    completed "Use 'kireisakura -h' for help."
    echo -e "\n\n"
    warn "Please relogin to apply changes."
    sleep 3
    exit
  fi
}


#________________ Variables ________________

export BOLD="$(tput bold 2>/dev/null || printf '')"
export GREY="$(tput setaf 0 2>/dev/null || printf '')"
export UNDERLINE="$(tput smul 2>/dev/null || printf '')"
export RED="$(tput setaf 1 2>/dev/null || printf '')"
export GREEN="$(tput setaf 2 2>/dev/null || printf '')"
export YELLOW="$(tput setaf 3 2>/dev/null || printf '')"
export BLUE="$(tput setaf 4 2>/dev/null || printf '')"
export MAGENTA="$(tput setaf 5 2>/dev/null || printf '')"
export NO_COLOR="$(tput sgr0 2>/dev/null || printf '')"

export KIT_NAME="KireiSakura-Kit"
export LIB_DIR="${HOME}/.local/share"
export KIT_DIR="${LIB_DIR}/${KIT_NAME}"
export BIN_DIR="${KIT_DIR}/bin"
export TEMP_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/${KIT_NAME}"

export KIT_REPO="soymadip/${KIT_NAME}"
export KIT_URL="https://github.com/${KIT_REPO}"

export YQ_BIN_URL="https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64"

export KIT_LOGO="$(
  cat <<"EOF"
 _  ___          _ ____        _                          _  ___ _
 | |/ (_)_ __ ___(_) ___|  __ _| | ___   _ _ __ __ _      | |/ (_) |_
 | ' /| | '__/ _ \ \___ \ / _` | |/ / | | | '__/ _` |_____| ' /| | __|
 | . \| | | |  __/ |___) | (_| |   <| |_| | | | (_| |_____| . \| | |_
 |_|\_\_|_|  \___|_|____/ \__,_|_|\_\\__,_,|_|  \__,_|     |_|\_\_|\__|
EOF
)"


#________________ Main Func ________________

# TODO:
#     - Close terminal if not directly sourcing
#     - Make the script use KireiSakura-Kit itself.
main() {
  local direct_source=false

  [[ "$1" == "-ds" ]] && direct_source=true

  print_header
  warn 'Welcome to KireiSakura-Kit installer.'
  sleep 1
  info 'KireiSakura-Kit will soon be installed in your system.'
  sleep 2
  check_deps tr curl grep figlet
  check_update
  download_kit latest
  install_kit
  sleep 2
  cleanup
  if [ "$direct_source" = true ]; then
    sayonada -s
  else
    sayonada
  fi
}

main "$@"
