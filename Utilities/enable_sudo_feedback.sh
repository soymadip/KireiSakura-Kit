

enable_sudo_feedback() {

    if sudo grep -q "Defaults.*pwfeedback" /etc/sudoers; then
        log "Sudo feedback is already enabled." success
    else
        log "Sudo feedback is not enabled." inform
        log "Enabling pwfeedback..."

        sleep 1
        sudo cp /etc/sudoers /etc/sudoers.bak
        sudo bash -c 'echo "Defaults        pwfeedback" >> /etc/sudoers'

        if [ $? -eq 0 ]; then
            log "Sudo feedback has been enabled." success
        else
            echo "Failed to enable pwfeedback. Restoring backup..." error
            sudo mv /etc/sudoers.bak /etc/sudoers
        fi
    fi
}

