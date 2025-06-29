#        _____           _
#       |  ___|__  _ __ | |_
#       | |_ / _ \| '_ \| __|
#       |  _| (_) | | | | |_
# Utils.|_|  \___/|_| |_|\__|
#
# Various font related methods.

# install fontconfig if not present
install-package "fontconfig"

#
#
#==---------------------------------------------------------------------------------
# NAME:   __install_font
# ALIAS:  font.install
# DESC:  Install fonts from font file/directory.
# USAGE: font.install <flags> <arguments>
# FLAGS:
#         -d,--dir  Install from directory.
# FIXME: Update this function with latest changes.
#==---------------------------------------------------------------------------------
__install_font() {
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
#==---------------------------------------------------------------------------------


#
#
#==---------------------------------------------------------------------------------
# NAME:   __list_fonts
# ALIAS:  font.list
# DESC:   List all installed fonts.
# USAGE:  font.list
# TODO:   add -p to get the font's path.
#==---------------------------------------------------------------------------------
__list_fonts() {

  fc-list | cut -d: -f2 | cut -d, -f1 | sort -u
}
#==---------------------------------------------------------------------------------


#
#
#==---------------------------------------------------------------------------------
# NAME:   __is_installed_font
# ALIAS:  font.is_installed
# DESC:   Returns True if given font is installed, else False.
# USAGE:  font.is_installed <full-font-file-name>
#==---------------------------------------------------------------------------------
__is_installed_font() {
  local font_file="$1"

  __list_fonts | grep -q "$font_file" &>/dev/null
}
#==---------------------------------------------------------------------------------


#
#
#==---------------------------------------------------------------------------------
# NAME:   __remove_font
# ALIAS:  font.remove
# DESC:   Remove given font(s)
# USAGE:  font.remove <full-font-file-name>
#==---------------------------------------------------------------------------------
__remove_font() {

  log.nyi
}
#==---------------------------------------------------------------------------------


#_____________________ Aliases _________________________
alias font.install='__install_font'
alias font.remove='__remove_font'
alias font.list='__list_fonts'
alias font.is_installed='__is_installed_font'
