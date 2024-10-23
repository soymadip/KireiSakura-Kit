# In order to work native-messaging to work with librewolf, we need
# to symlink forefox dirs to librewolf.

function enable_librewolf_ntv_msging {
  local librewolf_dir1='~/.librewolf/native-messaging-hosts'
  local librewolf_dir2='/usr/lib/librewolf/native-messaging-hosts'
  local firefox_dir1='~/.mozilla/native-messaging-hosts'
  local firefox_dir2='/usr/lib/mozilla/native-messaging-hosts'

  if [ -e "$librewolf_dir1" ]; then
    log "The destination directory '$librewolf_dir1' already exists."
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
