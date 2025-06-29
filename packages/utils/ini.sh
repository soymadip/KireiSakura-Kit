# EXPERIMENTAL UTIL.
# Do NOT use in production.


#
#
#==---------------------------------------------------------------------------------
# NAME:   __read_ini
# ALIAS:  ini.read
# DESC:   Read a value from an INI file using section.key format.
# USAGE:  ini.read <ini_file> <section.key>
#==---------------------------------------------------------------------------------
__read_ini() {
    local ini_file="$1"
    local section_key="$2"
    local resolved_value=""

    # Check if the file exists
    if [[ ! -f "$ini_file" ]]; then
        echo "Error: File '$ini_file' does not exist."
        return 1
    fi

    # Extract section and key from the "section.key" format
    local section="${section_key%%.*}"
    local key="${section_key#*.}"

    # Use awk to process the INI file, ignoring comments and empty lines
    resolved_value=$(awk -F= -v section="$section" -v key="$key" '
    BEGIN { in_section = 0 }
    # Ignore comments (lines starting with # or ;)
    /^[#;]/ { next }
    # Match the section
    /^\[.*\]$/ {
        if ($0 == "[" section "]") {
            in_section = 1
        } else {
            in_section = 0
        }
    }
    # If inside the section, check for the key-value pair
    in_section && $1 ~ key {
        # Print the value and exit once we find the key
        print $2
        exit
    }
    ' "$ini_file")

    # Check if the key exists
    if [[ -z "$resolved_value" ]]; then
        echo "Error: Key '$section_key' not found in section '$section'."
        return 1
    fi

    # Trim only trailing spaces (preserving spaces in between)
    resolved_value=$(echo "$resolved_value" | sed 's/[[:space:]]*$//')

    # Output the resolved value
    echo -n "$resolved_value"
}
#==---------------------------------------------------------------------------------


#_____________________ Aliases _________________________
alias ini.read='__read_ini'
