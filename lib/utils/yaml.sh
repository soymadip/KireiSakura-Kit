
#
#
#==---------------------------------------------------------------------------------
# NAME:   __read_yaml
# ALIAS:  yaml.read
# DESC:   Parese yaml file and replace variables
# USAGE:  yaml.read [<arguments>].
# FIXME:  NOT COMPLETED.
#         Variable parsing is not implemented properly.
#==---------------------------------------------------------------------------------
__read_yaml() {
  local key="$1"
  local yml_file="$2"
  local value

  # Get raw value
  value=$(yq -e ".$key" "$yml_file" 2>/dev/null) || {
    echo "❌ Key not found: $key" >&2
    return 1
  }

  # 🔧 Strip outer quotes if present
  value="${value%\"}"
  value="${value#\"}"
  value="${value%\'}"
  value="${value#\'}"

  # 🔁 Resolve placeholders recursively
  while [[ "$value" =~ \${{\ *([^}]+)\ *}} ]]; do
    local nested_key="${BASH_REMATCH[1]}"
    local nested_value
    nested_value=$(yq -e ".$nested_key" "$yml_file" 2>/dev/null) || {
      echo "❌ Nested key not found: $nested_key" >&2
      return 1
    }

    value="${value//\${{ $nested_key }}/$nested_value}"
    value="${value//\${{$nested_key}}/$nested_value}"
  done

  echo "$value"
}
#==---------------------------------------------------------------------------------


alias yaml.read="__read-yaml"