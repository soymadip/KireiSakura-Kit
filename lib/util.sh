#  ____                 _____                 _   _
# / ___|___  _ __ ___  |  ___|   _ _ __   ___| |_(_) ___  _ __  ___
#| |   / _ \| '__/ _ \ | |_ | | | | '_ \ / __| __| |/ _ \| '_ \/ __|
#| |__| (_) | | |  __/ |  _|| |_| | | | | (__| |_| | (_) | | | \__ \
# \____\___/|_|  \___| |_|   \__,_|_| |_|\___|\__|_|\___/|_| |_|___/
#


#
#
#==---------------------------------------------------------------------------------
# NAME:   __compare_num
# ALIAS:  util.compare-num
# DESC:   Compare 2 numbers. also works for version numbers.
# USAGE:  util.compare-num <number1> <number2>
#==---------------------------------------------------------------------------------
__compare_num() {
  local ver1 ver2

  if [[ $BASH_VERSION ]]; then
    IFS='.' read -r -a ver1 <<<"$1"
    IFS='.' read -r -a ver2 <<<"$2"
  else
    IFS='.' read -rA ver1 <<<"$1"
    IFS='.' read -rA ver2 <<<"$2"
  fi

  for i in {0..2}; do
    local v1_part=${ver1[i]:-0}
    local v2_part=${ver2[i]:-0}

    if ((v1_part > v2_part)); then
      echo 1
      return
    elif ((v1_part < v2_part)); then
      echo 2
      return
    fi
  done

  echo 0
  return 0
}
#==---------------------------------------------------------------------------------


#
#
#==---------------------------------------------------------------------------------
# NAME:   __starts_with
# ALIAS:  lib.starts_with
# DESC:   Check if a string starts with a given prefix.
# USAGE:  starts-with <string> <prefix>
#==---------------------------------------------------------------------------------
__starts_with() {
  local str="$1"
  local prfx="$2"

  [[ "${str#"$prfx"}" != "$str" ]]
}
#==---------------------------------------------------------------------------------


#
#
#==---------------------------------------------------------------------------------
# NAME:   __ends_with
# ALIAS:  ends-with
# DESC:   Check if a string ends with a given suffix.
# USAGE:  ends-with <string> <suffix>
#==---------------------------------------------------------------------------------
__ends_with() {
  local str="$1"
  local suffix="$2"

  [[ "${str%"$suffix"}" != "$str" ]]
}
#==---------------------------------------------------------------------------------


#
#
#==---------------------------------------------------------------------------------
# NAME:   __len
# ALIAS:  len
# DESC:   Gets the length of a string.
# USAGE:  len <string>
#==---------------------------------------------------------------------------------
__len() {
  echo "${#1}"
}
#==---------------------------------------------------------------------------------


#
#
#==---------------------------------------------------------------------------------
# NAME:   __strip
# ALIAS:  strip
# DESC:   Trim a leading & trailing character from a string.
# USAGE:  strip [<flags>] <string> [<character>]
# FLAGS:
#         -s,--start    Strip only leading char.
#         -e,--end      Strip only trailing char.
#==---------------------------------------------------------------------------------
__strip() {
  local string character
  local strip_start=false strip_end=false

  while [[ $# -gt 0 ]]; do
    case "$1" in
    -s | --start)
      strip_start=true
      shift
      ;;
    -e | --end)
      strip_end=true
      shift
      ;;
    *)
      if [[ -z "$string" ]]; then
        string="$1"
      elif [[ -z "$character" ]]; then
        character="$1"
      fi
      shift
      ;;
    esac
  done

  character="${character:- }"

  # Default to stripping whitespace
  if [[ "$strip_start" == false && "$strip_end" == false ]]; then
    strip_start=true
    strip_end=true
  fi

  # Strip leading occurrences of character
  if [[ "$strip_start" == true ]]; then
    while [[ "$string" == "$character"* ]]; do
      string="${string#"$character"}"
    done
  fi

  # Strip trailing occurrences of character
  if [[ "$strip_end" == true ]]; then
    while [[ "$string" == *"$character" ]]; do
      string="${string%"$character"}"
    done
  fi

  echo "$string"
}
#==---------------------------------------------------------------------------------


#
#
#==---------------------------------------------------------------------------------
# NAME:   __split
# ALIAS:  split
# DESC:   Split a string by a delimiter & store the result in an array.
# USAGE:  split <string> <delimiter>
#==---------------------------------------------------------------------------------
__split() {
  local string="$1"
  local delimiter="$2"
  mapfile -t split_result < <(awk -v d="$delimiter" '{ n = split($0, parts, d); for (i = 1; i <= n; i++) print parts[i] }' <<<"$string")
}
#==---------------------------------------------------------------------------------


#
#
#==---------------------------------------------------------------------------------
# NAME:   __hyperlink
# ALIAS:  hyperlink
# DESC:   Print hyperlink in terminal.
# USAGE:  hyperlink <url> <text>
#==---------------------------------------------------------------------------------
__hyperlink() {
  local url="$1"
  local text="${2:-$1}"
  echo -e "\e]8;;${url}\e\\${text}\e]8;;\e\\"
}
#==---------------------------------------------------------------------------------


#
#
#==---------------------------------------------------------------------------------
# NAME:   __kit_version
# DESC:   Get the version of the kit.
# USAGE:  kit-version [<flags>]
# FLAGS:
#         -u,--upstream   Get version of upstream.
#         -l,--local      Get version of local installation.
#==---------------------------------------------------------------------------------
__kit_version() {
  local url
  local version
  local local=true

  case "$1" in
  -u | --upstream)
    local=false
    version=$(curl -s "$k_kit_upstream_ver_url" || echo "N/A")
    ;;
  -l | --local)
    version=$(cat -s "$k_kit_ver_url" || echo "N/A")
    ;;
  *)
    version=$(cat -s "$k_kit_ver_url" || echo "N/A")
    ;;
  esac

  if [[ "$version" == "N/A" ]]; then
    log.error "Couldn't resolve version. Please check your connection or the URL."
    return 1
  fi
  
  [[ "$local" == "true" ]] && k_kit_version="$version"
  [[ "$local" == "false" ]] && k_kit_upstream_version="$version"

  echo "$version"
  return 0
}
#==---------------------------------------------------------------------------------






#_____________________ Aliases ________________________

alias util.compare-num='__compare_num'