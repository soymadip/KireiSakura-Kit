

enable_sudo_feedback() {

    if sudo grep -q "Defaults.*pwfeedback" /etc/sudoers; then
        log.success "Sudo feedback is already enabled."
    else
        log.warn "Sudo feedback is not enabled."
        log.warn "Enabling pwfeedback..."

        sleep 1
        sudo cp /etc/sudoers /etc/sudoers.bak
        sudo bash -c 'echo "Defaults        pwfeedback" >> /etc/sudoers'

        if [ $? -eq 0 ]; then
            log.success "Sudo feedback has been enabled."
        else
            log.error "Failed to enable pwfeedback. Restoring backup..."
            sudo mv /etc/sudoers.bak /etc/sudoers
        fi
    fi
}

