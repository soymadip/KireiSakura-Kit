

#
#
#---------------------------------------------------------------------------------
# NAME:  install-additional-arch-repo
# DESC:  install additional repositories like Chaotic AUR, ArcoLinux, Garuda, etc.
# USAGE: install-additional-arch-repo <repo_names>
# TODO:
#      - 1st determine distro with get-package-manager then install the repo.
#      - install only os specific repos, else give error.
# FIXME: 
#      - This function is not up-to-date.
#      - Just Rewrite. It needs too much changes.
#---------------------------------------------------------------------------------
install-additional-repo() {

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



#_____________________ Aliases _________________________
alias os.install-additional-repo=install-additional-repo
