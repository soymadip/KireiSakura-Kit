# _____            _                                      _
#| ____|_ ____   _(_)_ __ ___  _ __  _ __ ___   ___ _ __ | |_
#|  _| | '_ \ \ / / | '__/ _ \| '_ \| '_ ` _ \ / _ \ '_ \| __|
#| |___| | | \ V /| | | | (_) | | | | | | | | |  __/ | | | |_
#|_____|_| |_|\_/ |_|_|  \___/|_| |_|_| |_| |_|\___|_| |_|\__|
#
# Setup required options/env vars before anyting else.




#------------Enable aliases in non-interactive shell-----------------------
if [[ $- != *i* ]]; then
    shopt -s expand_aliases
fi


#------------ Export arrays for module count -----------------------
export k_loaded_modules=()


#
#
#---------------------------------------------------------------------------------
# NAME:  remove-command
# DESC:  Remove command conflicts between functions and aliases.
# USAGE: remove-command <command>
#---------------------------------------------------------------------------------
remove-command() {
    local command="$1"

    if type "$command" &>/dev/null; then
        if type "$command" | grep -q -E 'is a (shell )?function'; then
            unset -f "$command"
        fi

        if alias "$command" &>/dev/null; then
            unalias "$command"
        fi
    fi
}