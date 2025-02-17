
check-mount-entry() {
  local disk_id="$1"
  local mount_dir="$2"
  local fstab_file="/etc/fstab"

  # Check if the disk_id or mount_dir is already in fstab
  if grep -q "$disk_id" "$fstab_file"; then
      mount_point="$(grep $disk_id $fstab_file | sed -E 's/^[^ ]+ +([^ ]+).*/\1/')"
      log.warn "The Drive has entry to already Mount in : $mount_point"
      return 1
  elif grep -q "$mount_dir" $fstab_file; then
      local disk_to_mount="$(grep $mount_dir $fstab_file | sed -E 's/^([^ ]+).*/\1/')"
      log.warn "Dir is in entry to be used for Mounting: $disk_to_mount"
      return 1
  else
      return 0
  fi

}

mount-external-drive() {
  local mount_dir username user_group disk_id mount_config

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
            log.error "Invalid flag."
            exit 1
            ;;
    esac
  done


  # Make mount folder
  log.warn "Checking given Mount directory."
  check_dir "$mount_dir" --needed || { log.error "Error creating dir."; exit 1; }


  # Get ownership of the dir & drive
  log.warn "Getting ownership of the Mount directory."
  sudo chown -R $username:$user_group $mount_dir || { log.error "Error ownership."; exit 1; }
  sudo chmod -R 744 $mount_dir || { log.error "Error Getting writing permission."; exit 1; }

  log.warn "Getting ownership of the External Drive."
  sudo chown -R $username:$user_group $disk_id || { log.error "Error owning External Drive."; exit 1; }


  # Backup fstab file
  log.warn "Backing up current fstab file."
  sudo cp /etc/fstab /etc/fstab.bak || { log.error "Failed to back up current fstab file."; exit 1; }


  # Mounting device
  mount_config="$disk_id                                 $mount_dir      auto    noatime,x-systemd.automount,x-systemd.device-timeout=10,x-systemd.idle-timeout=1min 0 2"

  log.warn "Adding Drive entry in fstab file."
  echo "$mount_config" | sudo tee -a /etc/fstab

  log.warn "Reloading systemd configuration."
  sudo systemctl daemon-reload

  log.warn "Mounting Drive."
  sudo mount -a || { log.error "Failed to mount device."; exit 1; }

  log.success "External Drive '$disk_id' mounted at '$mount_dir'"
}



# Function to Resize swap file:
resize-swap() {
    echo -e "Do you wanna Create/Resize your swapfile? (y/n)\n(Your swap file will be of ${swap_file_size}B)"
    read -p "=>"   rsz_swapf
    if [ "$rsz_swapf" == "y" ] || [ "$rsz_swapf" == "Y" ] || [ -z "$rsz_swapf" ]; then
        if [ -f "$swap_file" ]; then
            log.info "Swapfile already exists. Resizing to $swap_file_size..."
            log.warn "turning off swaps"
            sudo swapoff -a
            log.warn "removing already present swapfile."
            sudo rm "$swap_file"
        else
            log.info "Creating swapfile of size $swap_file_size..."
        fi
        log.warn "creating new file of ${swap_file_size}B for swap."
        sudo fallocate -l "$swap_file_size" "$swap_file"
        log.warn "changing permissions."
        sudo chmod 600 "$swap_file"
        log.warn "making the ${swap_file} a swapfile."
        sudo mkswap "$swap_file"
        log.warn "turning new swapfile on"
        sudo swapon "$swap_file"
        log.warn "please check if everything is good:"
        swapon --show
        footer "Swapfile created and activated."
    else
        echo -e "${RED}swapfile size change skipped.${NC}"
    fi
}