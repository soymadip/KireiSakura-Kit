# Switching to ZSH Shell:

change_shell() {
    prompt "Do you want to switch to Zsh shell?" confirm_shell
    if [ "$confirm_shell" == "y" ] || [ "$confirm_shell" == "Y" ] || [ -z "$confirm_shell" ]; then
        if [ "$(basename "$SHELL")" == "zsh" ]; then
            log "ZSH is already Currnet shell."    
        else
            log "Changing shell"
            log "Checking if ZSH is installed."
            check_dependency zsh needed
            log "zsh is installed."
            log "Changing SHELL to ZSH.."
            chsh -s $(which zsh)
            log "Shell changed for current user." success
            log "Log out and log back again for changes to take effect." inform
        fi
        print_footer 
    else
        print_footer "Shell change skipped." skipped
    fi
}