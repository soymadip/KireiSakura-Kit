
```sh
declare -A INI_DATA  # Temporary global storage for ini.get
EXPANSION_LIMIT=5    # Max recursion depth for variable expansion

# Function: ini.read <file>
# Reads an INI file and stores values in an associative array named after the exact filename.
ini.read() {
    local file="$1"
    local file_var="${file//./_}"
    file_var="${file_var//\//_}"

    declare -gA "$file_var"  # Define dynamic associative array

    local awk_script='
    BEGIN { FS = "="; section = "" }
    /^[[:space:]]*;/ { next }  # Skip comments (;)
    /^[[:space:]]*#/ { next }  # Skip comments (#)
    /^[[:space:]]*$/ { next }  # Skip empty lines

    /^\[[^]]+\]/ {  # Match [section]
        section = substr($0, 2, length($0) - 2);
        next;
    }

    /^[^=]+=[^=]*$/ {  # Match key=value
        key = $1; gsub(/^[ \t]+|[ \t]+$/, "", key);  # Trim spaces
        value = $2; gsub(/^[ \t]+|[ \t]+$/, "", value);  # Trim spaces

        # Store value with section prefix
        full_key = section "." key;
        ini_data[full_key] = value;
    }

    END {
        for (k in ini_data) {
            print k " " ini_data[k];  # Output parsed data
        }
    }
    '

    # Read INI file using awk and populate the dynamic array
    while IFS= read -r line; do
        key="${line%% *}"  # Extract key (before space)
        value="${line#* }"  # Extract value (after space)
        eval "${file_var}[$key]=\"$value\""  # Store value without expansion
    done < <(awk "$awk_script" "$file")
}

# Function: ini.get <file> <section.key>
# Retrieves a value from the INI file without creating an array.
ini.get() {
    local file="$1"
    local key="$2"

    local awk_script='
    BEGIN { FS = "="; section = "" }
    /^[[:space:]]*;/ { next }  # Skip comments (;)
    /^[[:space:]]*#/ { next }  # Skip comments (#)
    /^[[:space:]]*$/ { next }  # Skip empty lines

    /^\[[^]]+\]/ {  # Match [section]
        section = substr($0, 2, length($0) - 2);
        next;
    }

    /^[^=]+=[^=]*$/ {  # Match key=value
        k = $1; gsub(/^[ \t]+|[ \t]+$/, "", k);
        v = $2; gsub(/^[ \t]+|[ \t]+$/, "", v);

        if (section "." k == target_key) {
            print v;
            exit;
        }
    }
    '

    local raw_value
    raw_value=$(awk -v target_key="$key" "$awk_script" "$file")

    echo "$raw_value"  # Return value without expansion
}



#
#
#---------------------------------------------------------------------------------
# NAME:  ini.expand
# DESC:  Expand the function to support variable expansion.
# FIXME: line 103: database.host: syntax error: invalid arithmetic operator (error token is ".host")
#---------------------------------------------------------------------------------

ini.expand() {
    local file_var="$1"
    local value="$2"
    local depth="${3:-0}"

    if (( depth >= EXPANSION_LIMIT )); then
        echo "Error: Expansion limit reached for: $value" >&2
        echo "$value"
        return
    fi

    local regex='\$\{([^}]+)\}'
    while [[ "$value" =~ $regex ]]; do
        local var="${BASH_REMATCH[1]}"
        local replacement
        # 🔹 Use indirect expansion to safely reference the associative array
        local key_ref="${file_var}[\"$var\"]"
        replacement="${!key_ref}"

        if [[ -n "$replacement" ]]; then
            value="${value//\$\{$var\}/$replacement}"
        else
            break
        fi
    done

    echo "$value"
}

```
