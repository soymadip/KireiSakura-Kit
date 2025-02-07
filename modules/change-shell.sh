# Switching to ZSH Shell:

change_shell() {
    local shell_name="$1"

    prompt "Do you want to switch to ${shell_name} shell?" confirm_shell
    if [ "$confirm_shell" == "y" ] || [ "$confirm_shell" == "Y" ] || [ -z "$confirm_shell" ]; then
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
        footer
    else
        footer "Shell change skipped." skipped
    fi
}