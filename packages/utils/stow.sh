
#
#
#==---------------------------------------------------------------------------------
# NAME:   __stow_restore
# ALIAS:  stow.restore
# DESC:   Restore dotfiles using GNU Stow.
# USAGE:  stow.restore [<dotfiles_dir>]
# TODO:   Just re-implement this. I was too immature when I wrote this.
#==---------------------------------------------------------------------------------
__stow_restore() {
    local cwd=$(pwd)
    local dot_dir="$HOME/${1:-Dotfiles}"

    log.warn "Restoring dotfiles using stow"

    if ! command -v stow >/dev/null 2>&1; then
        log.warn "Stow is not installed, installing.... "
        install-package stow
    fi

    log.warn "Current dir is $cwd"
    log.warn "Changing directory to $dot_dir"

    if cd "$dot_dir"; then
        log.warn "Running stow -v -R ."
        if stow -v -R .; then
            log.success "Stow completed"
        else
            log.error "Stow failed"
        fi
    else
        log.error "Failed to change directory to $dot_dir"
    fi

    log.warn "Changing directory back to $cwd"
    cd "$cwd" || log.error "Failed to change back to $cwd"
}
#==---------------------------------------------------------------------------------



#_____________________ Aliases _________________________
alias stow.restore='__stow_restore'
