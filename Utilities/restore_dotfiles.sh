# Function to restore dotfiles using stow



# This function estimates that dotfiles folder is in $HOME dir. 
function stow_restore {
    local cwd=$(pwd)
    local dot_dir="$HOME/${1:-Dotfiles}"

    log "Restoring dotfiles using stow" inform

    if ! command -v stow >/dev/null 2>&1; then
        log "Stow is not installed, installing.... " inform
        install_package stow
    fi

    log "Current dir is $cwd"
    log "Changing directory to $dot_dir"

    if cd "$dot_dir"; then
        log "Running stow -v -R ."
        if stow -v -R .; then
            log "Stow completed" success
        else
            log "Stow failed" error
        fi
    else
        log "Failed to change directory to $dot_dir" error
    fi

    log "Changing directory back to $cwd"
    cd "$cwd" || log "Failed to change back to $cwd" error
}