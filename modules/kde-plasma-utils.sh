# Vrious utilities to fine-tune KDE-Plasma DE.



# Change meta key to open krunner:
change_meta_to_krunner() {
    prompt "Do you want to change meta key to open krunner?" confirm_meta
    if [ "$confirm_meta" == "y" ] || [ "$confirm_meta" == "Y" ] || [ -z "$confirm_meta" ]; then
        log.warn "Changing meta key to open krunner."
        kwriteconfig6 --file kwinrc --group ModifierOnlyShortcuts --key Meta "org.kde.krunner,/App,,toggleDisplay"
        sleep 3
        log.warn "Applying changes."
        log.success "Done"
        qdbus org.kde.KWin /KWin reconfigure
        log.warn "To get all possible commands using kwriteconfig5" "TIP"
        log.warn "run 'qdbus org.kde.kglobalaccel /component/kwin org.kde.kglobalaccel.Component.shortcutNames'."
        # kwriteconfig5 --file ~/.config/kwinrc --group ModifierOnlyShortcuts --key Meta "org.kde.kglobalaccel,/component/kwin,org.kde.kglobalaccel.Component,invokeShortcut,NAME_OF_THE_THING_YOU_WANT_TO_OPEN" for custom shortcut..
        footer "Meta key will now open Krunner."
    else
        footer "meta key change skipped." skipped
    fi
}



# Change wallpaper: [change_wallpaper absolute/path/to/wallpaper]
change_wallpaper() {

    local wallpaper_path="$1"
    prompt "Do you want to change wallpaper?" confirm_wallpaper
    if [ "$confirm_wallpaper" == "y" ] || [ "$confirm_wallpaper" == "Y" ] || [ -z "$confirm_wallpaper" ]; then
        log.warn "Changing wallpaper."
        sleep 2
        qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "var Desktops = desktops();for (i=0;i<Desktops.length;i++) { d = Desktops[i];d.wallpaperPlugin = 'org.kde.image';d.currentConfigGroup = Array('Wallpaper', 'org.kde.image', 'General');d.writeConfig('Image', 'file:///${wallpaper_path}') }"
        log.success "Done"
        footer "Wallpaper changed to $wallpaper_path." success
    else
        footer "Wallpaper change skipped." skipped
    fi
}



# Change icon theme: [change_icon_theme icon_theme_name]
change_icon_theme() {
    local icon_theme="$1"
    prompt "Do you want to change icon theme?" confirm_icon_theme
    if [ "$confirm_icon_theme" == "y" ] || [ "$confirm_icon_theme" == "Y" ] || [ -z "$confirm_icon_theme" ]; then
        log.warn "Changing icon theme."
        sleep 2
        kwriteconfig6 --file kdeglobals --group Icons --key Theme "$icon_theme"
        qdbus org.kde.KWin /KWin reconfigure
        log.success "Done"
        footer "Icon theme changed to $icon_theme." success
    else
        footer "Icon theme change skipped." skipped
    fi
}


# Change cursor theme & size: [change_cursor_theme cursor_theme_name cursor_size]
change_cursor_theme() {
    local cursor_theme="$1"
    local cursor_size="$2"

    prompt "Do you want to change cursor theme?" confirm_cursor_theme
    if [ "$confirm_cursor_theme" == "y" ] || [ "$confirm_cursor_theme" == "Y" ] || [ -z "$confirm_cursor_theme" ]; then
        log.warn "Changing cursor theme."
        sleep 2
        kwriteconfig6 --file ~/.config/kcminputrc --group Mouse --key cursorTheme "$cursor_theme"
        kwriteconfig6 --file ~/.config/kcminputrc --group Mouse --key cursorSize "$cursor_size"
        qdbus org.kde.KWin /KWin reconfigure
        log.success "Done, Changes will be applied after relogin."
        footer "Cursor theme changed to $cursor_theme." success
    else
        footer "Cursor theme change skipped." skipped
    fi
}



# Function to change the SDDM theme
change_sddm_theme() {
    local theme_name="$1"
    local config_file="${2:-/etc/sddm.conf.d/kde_settings.conf}"
    local theme_dir="/usr/share/sddm/themes/$theme_name"

    # Check if the theme name is provided
    if [[ -z "$theme_name" ]]; then
        log.error "Error: No theme name provided."
        log.warn "Usage: change_sddm_theme <theme_name> [config_file]"
        return 1
    fi

    # Check if the theme directory exists
    if [[ ! -d "$theme_dir" ]]; then
        echo "Error: Theme '$theme_name' does not exist in $theme_dir."
        return 1
    fi

    log.warn "Changing SDDM theme to $theme_name."
    if sudo sed -i "s/^Current=.*/Current=$theme_name/" "$config_file" ; then
        echo "SDDM theme changed to $theme_name."
    else
        echo "Failed to change SDDM theme."
    fi

}


