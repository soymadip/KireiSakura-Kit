hex-to-ansi() {
    local hex="$1"
    local r=$((0x${hex:1:2}))
    local g=$((0x${hex:3:2}))
    local b=$((0x${hex:5:2}))

    local ansi=$((16 + (r / 51) * 36 + (g / 51) * 6 + (b / 51)))

    echo "\e[38;5;${ansi}m"
}