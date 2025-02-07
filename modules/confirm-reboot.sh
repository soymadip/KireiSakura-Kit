#
cfrm-reboot() {
  log.warn "!" prompt "Reboot is recommended, Do you wanna Reboot?" cfrm_reboot
  if [ "$cfrm_reboot" == "y" ] || [ "$cfrm_reboot" == "Y" ] || [ -z "$cfrm_reboot" ]; then
    log.warn "rebooting..."
    sleep 2
    sudo reboot
  else
    log.success "Ok, Enjoy your system! and don't forget to reboot later.."
    sleep 2
    clear
  fi
}

