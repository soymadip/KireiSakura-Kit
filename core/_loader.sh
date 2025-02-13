#____ shell-opts _____

if [[ $- != *i* ]]; then
    shopt -s expand_aliases
fi

#------------------------------------

remove-command-conflict() {
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

export kirei_loaded_core_modules=()
export kirei_loaded_modules=()

remove-command-conflict loader

source "$kirei_core_dir/ui.sh"
source "$kirei_core_dir/logging.sh"
source "$kirei_core_dir/utils.sh"
