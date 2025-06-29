# FIXME:
#      - update with latest kit.


#
#
#==---------------------------------------------------------------------------------
# NAME:   __enable_os_prober
# ALIAS:  grub.enable.os_prober
# DESC:   By default GRUB doesn't show all OSs that are in other partitions.
#         This function enables os-prober in GRUB.
# USAGE:  grub.enable.os_prober [<grub_file>]
#==---------------------------------------------------------------------------------
__enable_os_prober() {
    local grub_file="${1:-/etc/default/grub}"

    log.warn "Enabling os-prober"
    log "Editing /etc/default/grub file"
    sed -i '/^#GRUB_DISABLE_OS_PROBER=/s/^#//' "$grub_file"
    log "Updating GRUB config"
    sudo grub-mkconfig -o /boot/grub/grub.cfg
    log.success "done"
}
#==---------------------------------------------------------------------------------


#
#
#==---------------------------------------------------------------------------------
# NAME:   __set_grub_timeout
# ALIAS:  grub.set.timeout
# DESC:   Change GRUB timeout to specified time.
# USAGE:  grub.set.timeout <timeout in seconds>
#==---------------------------------------------------------------------------------
__set_grub_timeout() {
    log.nyi
}
#==---------------------------------------------------------------------------------



#_____________________ Aliases _________________________

alias grub.enable.os_prober='__enable_os_prober'
alias grub.set.timeout='__set_grub_timeout'

