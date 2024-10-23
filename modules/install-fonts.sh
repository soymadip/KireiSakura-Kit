

# Install fonts to current user 
install_fonts() {
    prompt "Do you want to install fonts in /fonts folder" confirm_fontinstal
    if [ "$confirm_fontinstal" == "y" ] || [ "$confirm_fontinstal" == "Y" ] || [ -z "$confirm_fontinstal" ]; then
        log "Installing custom Fonts......"
        CURRENT_DIRECTORY=$(pwd)
        pushd ~
        log "copying fonts to ~/$SYSTEM_FONTS_DIRECTORY."
        cp -r "$CURRENT_DIRECTORY/$FONTS_DIRECTORY"/* "$SYSTEM_FONTS_DIRECTORY"/
        popd
        log "Rebuilding font cache."
        sudo fc-cache -f -v
        print_footer "Fonts are installed."
    else
        print_footer "skipped Installing fonts" skipped
    fi
}
