# Vrious utilities to fine-tune KDE-Plasma DE.



# Change meta key to open krunner:
change_meta_to_krunner() {
    prompt "Do you want to change meta key to open krunner?" confirm_meta
    if [ "$confirm_meta" == "y" ] || [ "$confirm_meta" == "Y" ] || [ -z "$confirm_meta" ]; then
        log "Changing meta key to open krunner."
        kwriteconfig5 --file kwinrc --group ModifierOnlyShortcuts --key Meta "org.kde.krunner,/App,,toggleDisplay"
        sleep 3
        log "Applying changes."
        log "Done"
        qdbus org.kde.KWin /KWin reconfigure
        log "To get all possible commands using kwriteconfig5" inform "TIP"
        log "run 'qdbus org.kde.kglobalaccel /component/kwin org.kde.kglobalaccel.Component.shortcutNames'." inform
        # kwriteconfig5 --file ~/.config/kwinrc --group ModifierOnlyShortcuts --key Meta "org.kde.kglobalaccel,/component/kwin,org.kde.kglobalaccel.Component,invokeShortcut,NAME_OF_THE_THING_YOU_WANT_TO_OPEN" for custom shortcut..
        # Go to Assets/meta-commnads.png
        print_footer "Meta key will now open Krunner."
    else
        print_footer "meta key change skipped." skipped
    fi
}


#  