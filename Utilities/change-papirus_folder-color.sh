# This function is for changing the color of the Papirus icon folder.

change_papirus_folder_color() {
    local color_name=$1
    local theme_name=${2:-Papirus-Dark}

    if ! command -v papirus-folders >/dev/null 2>&1; then
        log "Papirus-folders is not installed, installing..." inform
        install_package papirus-folders-catppuccin-git 
    fi

    log "Changing Papirus folder color to $color_name with theme $theme_name." inform
    papirus-folders -v -C $color_name --theme $theme_name

    log "Papirus folder color changed to $color_name." success
    print_footer
}