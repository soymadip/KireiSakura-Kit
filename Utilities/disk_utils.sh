
check_entry() {
  local disk_id="$1" 
  local mount_dir="$2"
  local fstab_file="/etc/fstab"

  # Check if the disk_id or mount_dir is already in fstab
  if grep -q "$disk_id" "$fstab_file"; then
      mount_point="$(grep $disk_id $fstab_file | sed -E 's/^[^ ]+ +([^ ]+).*/\1/')"
      log "The Drive has entry to already Mount in : $mount_point" inform
      return 1
  elif grep -q "$mount_dir" $fstab_file; then
      local disk_to_mount="$(grep $mount_dir $fstab_file | sed -E 's/^([^ ]+).*/\1/')"
      log "Dir is in entry to be used for Mounting: $disk_to_mount" inform
      return 1
  else 
      return 0
  fi

}

mount_external_drive() {
  local mount_dir
  local username
  local user_group
  local disk_id
  local mount_config

  # Parse options
  while [[ "$#" -gt 1 ]]; do
    case "$1" in
        -md|--mount-dir)
            mount_dir=$2
            shift 2
            ;;
        -u|--user)
            username=$2
            shift 2
            ;;
        -ug|--user-group)
            user_group=$2
            shift 2
            ;;
        -di|--disk-id)
            disk_id=$2
            shift 2
            ;;
        *)
            log "Invalid flag." error
            exit 1
            ;;
    esac
  done


  # Make mount folder
  log "Checking given Mount directory." inform
  check_dir "$mount_dir" --needed || { log "Error creating dir." error; exit 1 }


  # Get ownership of the dir & drive
  log "Getting ownership of the Mount directory." inform
  sudo chown -R $username:$user_group $mount_dir || { log "Error ownership." error; exit 1 }
  sudo chmod -R 744 $mount_dir || { log "Error Getting writing permission." error; exit 1 }

  log "Getting ownership of the External Drive." inform
  sudo chown -R $username:$user_group $disk_id || { log "Error owning External Drive." error; exit 1 }


  # Backup fstab file
  log "Backing up current fstab file." inform
  sudo cp /etc/fstab /etc/fstab.bak || { log "Failed to back up current fstab file." error; exit 1 }


  # Mounting device
  mount_config="$disk_id                                 $mount_dir      auto    noatime,x-systemd.automount,x-systemd.device-timeout=10,x-systemd.idle-timeout=1min 0 2"

  log "Adding Drive entry in fstab file." inform
  echo "$mount_config" | sudo tee -a /etc/fstab

  log "Reloading systemd configuration." inform
  sudo systemctl daemon-reload

  log "Mounting Drive." inform
  sudo mount -a || { log "Failed to mount device." error; exit 1 }

  log "External Drive '$disk_id' mounted at '$mount_dir'" success 
}

