# by default GRUB doesn't show all OSs that are in other partitions.
# Read about it here: https://discovery.endeavouros.com/system-rescue/grub-how-to-fix-booting-of-other-arch-based-systems/2021/03/
# So we gotta Uncomment the GRUB_DISABLE_OS_PROBER=false line in /etc/default/grub file.
# This will enable os-prober allowing GRUB to detect other OS...

enable_os_prober() {
    prompt "Do you want enable os prober?" confirm_prober
    if [ "$confirm_prober" == "y" ] || [ "$confirm_prober" == "Y" ] || [ -z "$confirm_prober" ]; then
        log.warn "Editing /etc/default/grub file"
        sleep 2
        log.warn "Enabling os-prober"
        sed -i '/^#GRUB_DISABLE_OS_PROBER=/s/^#//' "$GRUB_FILE"
        log.warn "updating GRUB config"
        sudo grub-mkconfig -o /boot/grub/grub.cfg
        log.success "done"
        footer
    else
        log.imp "skipped enablig os-prober." "OS-Prober"
        log.imp "GRUB will not detect OS in other partitions" "OS-Prober"
        footer
    fi

}
