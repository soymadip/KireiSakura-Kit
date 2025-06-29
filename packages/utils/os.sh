

#
#
#==---------------------------------------------------------------------------------
# NAME:   __install_additional_repo
# ALIAS:  os.install.additional.repo
# DESC:   Install additional repositories like Chaotic AUR, ArcoLinux, Garuda, etc.
# USAGE:  os.install.additional.repo <repo_names>
# TODO:
#      - 1st determine distro with get-package-manager then install the repo.
#      - install only os specific repos, else give error.
#      - ADD support for config file. Like take install steps form config, like:
#        it should inject registry to to conf
#            install-additional-repo:
#              - chaotic-aur:
#                  for: arch
#                  steps:
#                    - sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
#                    - sudo pacman-key --lsign-key 3056513887B78AEB
#                    - sudo pacman -U --noconfirm https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst
#                    - sudo pacman -U --noconfirm https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst
#              - garuda-linux:
#                  for: arch
#                  steps:
#                    - sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
#                    - sudo pacman-key --lsign-key 3056513887B78AEB
# FIXME:
#      - This function is not up-to-date.
#      - Just Rewrite. It needs too much changes.
#==---------------------------------------------------------------------------------
__install_additional_repo() {

  local chaotic_aur_key="3056513887B78AEB"
  local chaotic_aur_keyserver="keyserver.ubuntu.com"
  local chaotic_aur_keyring_url="https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst"
  local chaotic_aur_mirrorlist_url="https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst"

  local garuda_repo="[garuda]\nSigLevel = Required DatabaseOptional\nInclude = /etc/pacman.d/chaotic-mirrorlist"

  local arcolinux_repo_url="https://github.com/arcolinux/archlinux-tweak-tool"
  local arcolinux_cache_dir="~/.cache/setup/arcolinux-app"

  log.warn "Installing Chaotic AUR..."
  log.warn "Appending keys..."
  sudo pacman-key --recv-key $chaotic_aur_key --keyserver $chaotic_aur_keyserver || {
    log.error "Failed to receive Chaotic AUR key"
    return 1
  }
  sudo pacman-key --lsign-key $chaotic_aur_key || {
    log.error "Failed to locally sign Chaotic AUR key"
    return 1
  }
  sudo pacman -U --noconfirm $chaotic_aur_keyring_url || {
    log.error "Failed to install Chaotic AUR keyring"
    return 1
  }
  sudo pacman -U --noconfirm $chaotic_aur_mirrorlist_url || {
    log.error "Failed to install Chaotic AUR mirrorlist"
    return 1
  }
  log.warn "Adding Chaotic AUR to /etc/pacman.conf..."
  echo -e "\n[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist" | sudo tee -a /etc/pacman.conf
  log.success "Chaotic AUR is installed."

  # ArcoLinux
  log.warn "Installing ArcoLinux repos..."
  log.warn "Cloning ArcoLinux tweak tool..."
  git clone $arcolinux_repo_url $arcolinux_cache_dir || {
    log.error "Failed to clone ArcoLinux Tweak Tool"
    return 1
  }
  log.warn "Installing ArcoLinux keyring and mirrorlist..."
  sudo pacman -U $arcolinux_cache_dir/usr/share/archlinux-tweak-tool/data/arco/packages/keyring/arcolinux-keyring-*-any.pkg.tar.zst || {
    log.error "Failed to install ArcoLinux keyring"
    return 1
  }
  sudo pacman -U $arcolinux_cache_dir/usr/share/archlinux-tweak-tool/data/arco/packages/mirrorlist/arcolinux-mirrorlist-*-any.pkg.tar.zst || {
    log.error "Failed to install ArcoLinux mirrorlist"
    return 1
  }
  log.warn "Adding ArcoLinux repositories to /etc/pacman.conf..."
  echo -e "\n[arcolinux_repo]\nSigLevel = PackageRequired DatabaseNever\nInclude = /etc/pacman.d/arcolinux-mirrorlist" | sudo tee -a /etc/pacman.conf
  echo -e "\n[arcolinux_repo_3party]\nSigLevel = PackageRequired DatabaseNever\nInclude = /etc/pacman.d/arcolinux-mirrorlist" | sudo tee -a /etc/pacman.conf
  echo -e "\n[arcolinux_repo_xlarge]\nSigLevel = PackageRequired DatabaseNever\nInclude = /etc/pacman.d/arcolinux-mirrorlist" | sudo tee -a /etc/pacman.conf
  rm -rf $arcolinux_cache_dir
  log.success "ArcoLinux repos are successfully installed."

  # Garuda
  log.warn "Installing Garuda repos..."
  echo -e "\n$garuda_repo" | sudo tee -a /etc/pacman.conf
  log.success "Garuda repos are successfully installed."

  # Update Repositories
  log.warn "Updating repositories..."
  sudo pacman -Syu || {
    log.error "Failed to update repositories"
    return 1
  }

  log.warn "Enabling RPM Fusion Repository"
  sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

  log.warn "enabling fedora-cisco-openh264 Repo"
  sudo dnf config-manager --enable fedora-cisco-openh264

  log.warn "installing appstream-data"
  sudo dnf groupupdate core

  log.warn "Enabling FlatHub"
  flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

  log.warn "Installing Multimedia Plugins"
  sudo dnf install gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel
  sudo dnf install lame\* --exclude=lame-devel
  sudo dnf group upgrade --with-optional Multimedia

  log "Update complete."
  log.success "Chaotic AUR, ArcoLinux, and Garuda repos are successfully installed."
  return 0
}
#==---------------------------------------------------------------------------------


#
#
#==---------------------------------------------------------------------------------
# NAME:   __list_users
# ALIAS:  os.list.users
# DESC:   List users on the system. (by default, only human users)
# USAGE:  os.list.users [ -a|--all ]
# FLAGS:
#         -a, --all  List all users including system users
#==---------------------------------------------------------------------------------
__list_users() {
  local user_list=""
  local list_sys=false

  case "$1" in
  "") ;; # For no argument
  -a | --all) list_sys=true ;;
  *)
    log.error "Invalid argument\n  Available: -a or --all to list system users too"
    return 1
    ;;
  esac

  if [[ "$list_sys" == false ]]; then
    if ! user_list="$(awk -F: '$3 >= 1000 && $3 < 65534 {print $1}' /etc/passwd)"; then
      log.error "Failed to list users"
      return 1
    fi
  else
    if ! user_list="$(cut -d: -f1 /etc/passwd)"; then
      log.error "Failed to list users"
      return 1
    fi
  fi

  echo "$user_list"
}
#==---------------------------------------------------------------------------------


#
#
#==---------------------------------------------------------------------------------
# NAME:   __list_users_with_uid
# ALIAS:  os.list.users.with.uid
# DESC:   List users with their UIDs. (by default, only human users)
# USAGE:  os.list.users.with.uid [-a|--all]
# FLAGS:
#         -a|--all   List all users including system users.
#==---------------------------------------------------------------------------------
__list_users_with_uid() {
  local flag="$1"
  local usernames username uid

  if ! usernames="$(__list_users "$flag")"; then
    log.error "Failed to get user list"
    return 1
  fi

  # Loop over usernames and extract UID
  while IFS= read -r username; do
    uid=$(getent passwd "$username" | cut -d: -f3)

    if [[ -n "$uid" ]]; then
      printf "%-20s %s\n" "$username" "$uid"
    fi
  done <<<"$usernames"
}
#==---------------------------------------------------------------------------------



#
#
#==---------------------------------------------------------------------------------
# NAME:   __create_swap
# ALIAS:  os.swap.create
# DESC:   Create the system swap file.
# USAGE:  os.swap.create [size]
# FLAGS:
#         -s, --size        Size of the swap file (e.g. "4G", "8G")
#         -p, --path        Path to create the swap file (default: /swapfile)
#==---------------------------------------------------------------------------------
__create_swap() {
  local swap_file="/swapfile"
  local swap_file_size="4G"

  while [[ "$#" -gt 0 ]]; do
    case "$1" in
      -s|--size)
        swap_file_size="$2"
        shift 2
        ;;
      -p|--path)
        swap_file="$2"
        shift 2
        ;;
      *)
        log.error "Invalid flag: $1"
        log.warn "Usage: os.swap.create [-s|--size SIZE] [-p|--path PATH]"
        return 1
        ;;
    esac
  done

  prompt "Do you want to create/resize swapfile of size ${swap_file_size}?" confirm_swap

  if [ "$confirm_swap" == "y" ] || [ "$confirm_swap" == "Y" ] || [ -z "$confirm_swap" ]; then
    if [ -f "$swap_file" ]; then
      log.info "Swapfile already exists at $swap_file. Resizing to $swap_file_size..."

      log.warn "Turning off swaps"
      sudo swapoff -a || { log.error "Failed to turn off swap"; return 1; }

      log.warn "Removing existing swapfile"
      sudo rm "$swap_file" || { log.error "Failed to remove swapfile"; return 1; }

    else
      log.info "Creating new swapfile of size $swap_file_size at $swap_file"
    fi

    log.warn "Creating new swap file"
    sudo fallocate -l "$swap_file_size" "$swap_file" || { 
      log.error "Failed to create swap file. Trying dd method..."
      sudo dd if=/dev/zero of="$swap_file" bs=1M count=$((${swap_file_size%G} * 1024)) || {
        log.error "Failed to create swap file using dd"; 
        return 1;
      }
    }

    log.warn "Setting swap file permissions"
    sudo chmod 600 "$swap_file" || { log.error "Failed to set swap file permissions"; return 1; }

    log.warn "Setting up swap file"
    sudo mkswap "$swap_file" || { log.error "Failed to set up swap file"; return 1; }

    log.warn "Activating swap file"
    sudo swapon "$swap_file" || { log.error "Failed to activate swap"; return 1; }

    log.warn "Checking swap status:"
    swapon --show

    log.warn "Updating /etc/fstab to enable swap on boot..."
    if ! grep -q "$swap_file" /etc/fstab; then
      echo -e "$swap_file none swap defaults 0 0" | sudo tee -a /etc/fstab > /dev/null
    fi

    footer "Swapfile created and activated successfully" "success"
  else
    footer "Swapfile creation skipped" "skipped"
  fi
}
#==---------------------------------------------------------------------------------


#
#
#==---------------------------------------------------------------------------------
# NAME:   __resize_swap
# ALIAS:  os.swap.resize
# DESC:   Resize an existing system swap file.
# USAGE:  os.swap.resize <size>
# FLAGS:
#       -s, --size     New size for the swap file (e.g. "4G", "8G")
#       -p, --path     Path to the swap file (default: /swapfile)
#==---------------------------------------------------------------------------------
__resize_swap() {
  local swap_file="/swapfile"
  local new_size=""

  while [[ "$#" -gt 0 ]]; do
    case "$1" in
      -s|--size)
        new_size="$2"
        shift 2
        ;;
      -p|--path)
        swap_file="$2"
        shift 2
        ;;
      *)
        log.error "Invalid flag: $1"
        log.warn "Usage: os.swap.resize -s|--size SIZE [-p|--path PATH]"
        return 1
        ;;
    esac
  done

  # Check if size is provided
  if [ -z "$new_size" ]; then
    log.error "Please specify a new size with -s or --size"
    log.warn "Usage: os.swap.resize -s|--size SIZE [-p|--path PATH]"
    return 1
  fi

  # Check if swap file exists
  if [ ! -f "$swap_file" ]; then
    log.error "Swap file $swap_file does not exist"
    log.warn "Use os.swap.create to create a new swap file"
    return 1
  fi

  prompt "Do you want to resize swap file $swap_file to $new_size?" confirm_resize

  if [ "$confirm_resize" == "y" ] || [ "$confirm_resize" == "Y" ] || [ -z "$confirm_resize" ]; then
    log.warn "Turning off all swaps"
    sudo swapoff -a || { log.error "Failed to turn off swap"; return 1; }

    log.warn "Removing existing swap file"
    sudo rm "$swap_file" || { log.error "Failed to remove old swap file"; return 1; }

    log.warn "Creating new swap file with size $new_size"
    sudo fallocate -l "$new_size" "$swap_file" || {
      log.error "Failed to create swap file with fallocate. Trying dd method..."
      sudo dd if=/dev/zero of="$swap_file" bs=1M count=$((${new_size%G} * 1024)) || {
        log.error "Failed to create swap file using dd"; 
        return 1;
      }
    }

    log.warn "Setting swap file permissions"
    sudo chmod 600 "$swap_file" || { log.error "Failed to set swap file permissions"; return 1; }

    log.warn "Setting up swap file"
    sudo mkswap "$swap_file" || { log.error "Failed to set up swap file"; return 1; }

    log.warn "Activating swap file"
    sudo swapon "$swap_file" || { log.error "Failed to activate swap"; return 1; }

    log.warn "Current swap status:"
    swapon --show

    footer "Swap file resized to $new_size successfully" "success"
  else
    footer "Swap resize operation skipped" "skipped"
  fi
}
#==---------------------------------------------------------------------------------




#_____________________ Aliases _________________________

alias os.install.additional.repo='__install_additional_repo'

alias os.list.users='__list_users'
alias os.list.users.all='__list_users -a'

alias os.list.users.with.uid='__list_users_with_uid'
alias os.list.users.all.with.uid='__list_users_with_uid -a'

alias os.swap.create='__create_swap'
alias os.swap.resize='__resize_swap'
