
#____ shell-opts _____
shopt -s expand_aliases


#------------------------------------


remove-command-conflict() {
    local command="$1"

    if type "$command" &> /dev/null; then
        if type "$command" | grep -q -E 'is a (shell )?function'; then
            unset -f "$command"
        fi

        if alias "$command" &> /dev/null; then
            unalias "$command"
        fi
    fi
}


export kirei_loaded_core_modules=()
export kirei_loaded_modules=()


remove-command-conflict loader

#loader() {
#    local module_type="$1"
#    local query="$2"
#    shift
#    local called_modules=("@")
#    local failed_imports=()
#    local module_path
#
#    echo -e "Importing modules....\n"
#
#    for module_name in "${called_modules[@]}"; do
#        module_path="$kirei_module_dir/$module_name.sh"
#
#        if [ -f "$module_path" ]; then
#            if source "$module_path"; then
#                log "Imported: '$module_name'"
#            else
#                log "Failed to import: '$module_name'" inform
#                failed_imports+=("$module_name")
#            fi
#        else
#            log "Failed to import '$module_name': doesn't exist." inform
#            failed_imports+=("$module_name")
#        fi
#        sleep 0.3
#    done
#
#
#    fr
#
#}
#
#
#alias loader.module.load="loader extrnl load"
#alias loader.module-core.load="loader core load"
#
#alias loader.module.isloaded="loader extrnl isloaded"
#alias loader.module-core.isloaded="loader extrnl isloaded"



source "$kirei_core_dir/ui.sh"
source "$kirei_core_dir/logging.sh"
source "$kirei_core_dir/utils.sh"
