
#
#
#==---------------------------------------------------------------------------------
# NAME:   __fix_ntv_message
# ALIAS:  app-patches.fix.ntv_message
# DESC:   Fix the "Native Messaging Host" message (by default Firefox forks).
# USAGE:  app-patches.fix.ntv_message <config folder>
# FIXME:  This function is not up-to-date.
#==---------------------------------------------------------------------------------
__fix_ntv_message() {
  local librewolf_dir1='~/.librewolf/native-messaging-hosts'
  local librewolf_dir2='/usr/lib/librewolf/native-messaging-hosts'
  local firefox_dir1='~/.mozilla/native-messaging-hosts'
  local firefox_dir2='/usr/lib/mozilla/native-messaging-hosts'

  if [ -e "$librewolf_dir1" ]; then
    log.warn "The destination directory '$librewolf_dir1' already exists."
    read -p "Do you want to overwrite it? (y/n): " overwrite
    if [ "$overwrite" = "y" ]; then
      rm -i "$librewolf_dir1"
      ln -s -r -i "$firefox_dir1" "$librewolf_dir1"
    else
      echo "Aborting..."
      return 0
    fi
  fi

  if [ -e "$librewolf_dir2" ]; then
    echo "The destination directory '$librewolf_dir2' already exists."
    read -p "Do you want to overwrite it? (y/n): " overwrite2
    if [ "$overwrite2" = "y" ]; then
      sudo rm -i "$librewolf_dir2"
      sudo ln -s "$firefox_dir2" "$librewolf_dir2"
    else
      echo "Aborting..."
      return 0
    fi
  fi
}
#==---------------------------------------------------------------------------------


#
#
#==---------------------------------------------------------------------------------
# NAME:   __change_papirus_folder_color
# ALIAS:  app-patches.change.papirus.folder.color
# DESC:   Change folder color for Papirus icon theme.
# USAGE:  app-patches.change.papirus.folder.color <color_name> [<theme_name>]
# FIXME:  This function is not up-to-date.
#==---------------------------------------------------------------------------------
__change_papirus_folder_color() {
  local color_name=$1
  local theme_name=${2:-Papirus-Dark}

  if ! command -v papirus-folders >/dev/null 2>&1; then
    log.warn "Papirus-folders is not installed, installing..."
    install-package papirus-folders-catppuccin-git
  fi
  log.warn "Changing Papirus folder color to $color_name with theme $theme_name."
  command papirus-folders -v -C $color_name --theme $theme_name
  log.success "Papirus folder color changed to $color_name."
}
#==---------------------------------------------------------------------------------


#_____________________ Aliases _________________________
alias app-patches.fix.ntv_message='__fix_ntv_message'
alias app-patches.change.papirus.folder.color='__change_papirus_folder_color'
