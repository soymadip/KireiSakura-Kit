#
#
#==---------------------------------------------------------------------------------
# NAME:   __change_shell
# ALIAS:  shell.change
# DESC:   Change the login shell of the current user.
# USAGE:  shell.change <shell_name>
# FIXME:
#      - sync with current project.
#      - adapt to use which need lchsh (https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH#install-and-set-up-zsh-as-default)
#==---------------------------------------------------------------------------------
__change_shell() {
    local shell_name="$1"

    if [ "$(basename "$SHELL")" == "${shell_name}" ]; then
        log "${shell_name} is already Currnet shell."
    else
        log "Changing shell"
        log "Checking if ${shell_name} is installed."
        check-dep "${shell_name}" needed
        log "${shell_name} is installed."
        log "Changing SHELL to ${shell_name}.."
        chsh -s $(which "${shell_name}")
        log.success "Shell changed for current user."
        log.warn "Log out and log back again for changes to take effect."
    fi
}
#==---------------------------------------------------------------------------------


#
#
#==---------------------------------------------------------------------------------
# NAME:   __enable_sudo_feedback
# ALIAS:  shell.enable.sudo.feedback
# DESC:   Enable feedback (adds * as chars are typed) when typing sudo password.
# USAGE:  shell.enable.sudo.feedback
#==---------------------------------------------------------------------------------
__enable_sudo_feedback() {

    if sudo grep -q "Defaults.*pwfeedback" /etc/sudoers; then
        log.success "Sudo feedback is already enabled."
    else
        log.warn "Sudo feedback is not enabled."
        log.warn "Enabling pwfeedback..."

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
#==---------------------------------------------------------------------------------




#_____________________ Aliases _________________________
alias shell.change='__change_shell'
alias shell.enable.sudo.feedback='__enable_sudo_feedback'