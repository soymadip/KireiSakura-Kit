# Goodbye message:


cfrm_reboot() {
    log "!" inform
    log "Script completed." success
    prompt "Reboot is recommended, Do you wanna Reboot?" cfrm_reboot
    if [ "$cfrm_reboot" == "y" ] || [ "$cfrm_reboot" == "Y" ] || [ -z "$cfrm_reboot" ]; then
        log "rebooting..." inform
        sleep 2
        sudo reboot
    else
        log "Ok, Enjoy your system! and don't forget to reboot later.." success
        sleep 2
        clear
    fi
}