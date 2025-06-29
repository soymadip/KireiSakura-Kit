#
#
#==---------------------------------------------------------------------------------
# NAME:   __detect_ansi_support
# ALIAS:  ansi.detect.support
# DESC:   Detect terminal color support.
# USAGE:  ansi.detect.support
# Returns:
#         none:   If terminal does not support colors.
#         8bit:   If terminal supports 8-bit colors.
#         16bit:  If terminal supports 16-bit colors.
#         256bit: If terminal supports 256-bit colors.
#==---------------------------------------------------------------------------------
__detect_ansi_support() {
    local colors=$(tput colors 2>/dev/null)

    case "$colors" in
        ''|[0-7])
            echo "none"
            ;;
        [8-15])
            echo "8bit"
            ;;
        [16-255])
            echo "16bit"
            ;;
        *)
            echo "256bit"
            ;;
    esac
}
#==---------------------------------------------------------------------------------


#
#
#==---------------------------------------------------------------------------------
# NAME:   __hex_to_ansi
# ALIAS:  ansi.convert.hex
# DESC:   Convert hex color code to ANSI escape sequence.
# USAGE:  ansi.convert.hex <hex_color>

#==---------------------------------------------------------------------------------
__hex_to_ansi() {
    local hex="$1"
    local r=$((0x${hex:1:2}))
    local g=$((0x${hex:3:2}))
    local b=$((0x${hex:5:2}))

    local ansi=$((16 + (r / 51) * 36 + (g / 51) * 6 + (b / 51)))

    echo "\e[38;5;${ansi}m"
}
#==---------------------------------------------------------------------------------



#_____________________ Aliases _________________________
alias ansi.detect.support='__detect_ansi_support'
alias ansi.convert.hex='__hex_to_ansi'