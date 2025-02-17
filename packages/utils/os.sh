
#
#
#---------------------------------------------------------------------------------
# NAME:  install-font
# DESC:  Install fonts from font file/directory.
# USAGE: install-font <flags> <arguments>
# FLAGS:
#      -d,--dir  install from directory.
# FIXME: Update this function with latest changes.
#---------------------------------------------------------------------------------
install-font() {
  local sys_font_dir="${1:-$HOME/.local/share/fonts}"
  local install_form_dir=false
  local font_dir font_file

  log.warn "Installing custom Fonts......"
  log.warn "copying fonts to ~/$sys_font_dir."
  cp -r "$font_dir/$font_file"/* "$sys_font_dir"/
  log.warn "Rebuilding font cache."
  sudo fc-cache -f -v
  log.success "Fonts are installed."

}

#
#
#---------------------------------------------------------------------------------
# NAME:  install-additional-arch-repo
# DESC:  install additional repositories like Chaotic AUR, ArcoLinux, Garuda, etc.
# USAGE: install-additional-arch-repo <repo_names>
# TODO:
#      - 1st determine distro with get-package-manager then install the repo.
#      - install only os specific repos, else give error.
# FIXME: This function is not up-to-date.
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
  log "Update complete."
  log.success "Chaotic AUR, ArcoLinux, and Garuda repos are successfully installed."
  return 0
}