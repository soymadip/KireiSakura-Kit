
#
#
#==---------------------------------------------------------------------------------
# NAME:   __read_config
# ALIAS:  kit.conf.get
# DESC:   Parse Configuration file(s) & return value
# USAGE:  kit.conf.get
# TODO:   
#       - Use utils.yaml to parse config file.
#       - Add multiple config reading support.
#         Order to find value: project>user>system config.
#==---------------------------------------------------------------------------------
__read_config() {
    local property="$1"

    if ! __has_command "yq"; then
        log.error "Yq is not installed.\nPlease install it."
        return 1
    fi

    if value=$(yq -r ".${property}" "$K_CONFIG_FILE" 2>/dev/null); then
        echo "$value"
    else
        log.error "Failed to read property '$property' from configuration file."
        return 1
    fi
}
#==---------------------------------------------------------------------------------




#------------------------ Aliases -----------------------

alias kit.conf.get='__read_config'