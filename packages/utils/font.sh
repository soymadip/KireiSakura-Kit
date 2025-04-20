#        _____           _
#       |  ___|__  _ __ | |_
#       | |_ / _ \| '_ \| __|
#       |  _| (_) | | | | |_
# Utils.|_|  \___/|_| |_|\__|
#
# Various font related methods.

# install fontconfig if not present
install-pckage "fontconfig"

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
# NAME:  list-font
# DESC:  List all installed fonts..
# TODO: add -p to get the font's path.
#---------------------------------------------------------------------------------
list-fonts() {

  fc-list | cut -d: -f2 | cut -d, -f1 | sort -u
}

#
#
#---------------------------------------------------------------------------------
# NAME:  is_installed-font
# DESC:  Returns True if given font is installed, else False.
# USAGE: is_installed-font <full-font-file-name>
#---------------------------------------------------------------------------------
is_installed-font() {
  local font_file="$1"

  list-font | grep -q "$font_file" &>/dev/null
}

#
#
#---------------------------------------------------------------------------------
# NAME:  remove-font
# DESC:  Remove given font(s)
# USAGE: remove-font <full-font-file-name>
#---------------------------------------------------------------------------------
remove-font() {

  log.nyi
}

#------------- Aliases --------------
alias font.install='install-font'
alias font.remove='remove-font'
alias font.list='list-fonts'
alias font.isInstalled='is_installed-font'
