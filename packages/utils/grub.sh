# FIXME:
 #      - update with latest kit. 


#
#
#---------------------------------------------------------------------------------
# NAME:  enable-os-prober
# DESC:  by default GRUB doesn't show all OSs that are in other partitions.
#        This function enables os-prober in GRUB.
# USAGE: enable-os-prober
#---------------------------------------------------------------------------------
enable-os-prober() {
   local grub_file="${1:-/etc/default/grub}"

   log.warn "Enabling os-prober"
   log "Editing /etc/default/grub file"
   sed -i '/^#GRUB_DISABLE_OS_PROBER=/s/^#//' "$grub_file"
   log "Updating GRUB config"
   sudo grub-mkconfig -o /boot/grub/grub.cfg
   log.success "done"
}

#
#
#---------------------------------------------------------------------------------
# NAME:  set-grub-timeout
# DESC:  change GRUB timeeout to specified time.
# USAGE: set-grub-timeout <timeout in seconds>
#---------------------------------------------------------------------------------
set-grub-timeout() {
  log.error "Function not implemented yet."
}

