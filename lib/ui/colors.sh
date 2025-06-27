#  ____      _
# / ___|___ | | ___  _ __ ___
#| |   / _ \| |/ _ \| '__/ __|
#| |__| (_) | | (_) | |  \__ \
# \____\___/|_|\___/|_|  |___/
#
# Detect terminal color support and define color codes

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

__generate_colors() {
    local COLOR_MODE=$(__detect_ansi_support)

    # Define colors
    if [[ "$COLOR_MODE" == "256bit" ]]; then
        export RED="\e[38;5;196m"
        export GREEN="\e[38;5;46m"
        export BLUE="\e[38;5;27m"
        export YELLOW="\e[38;5;226m"
        export MAGENTA="\e[38;5;201m"
        export CYAN="\e[38;5;51m"
        export WHITE="\e[38;5;231m"
        export BLACK="\e[38;5;16m"
        export LAVENDER="\u001b[38;5;147m"
        export ORANGE="\e[38;5;214m"
        export PINK="\e[38;5;213m"
        export PURPLE="\e[38;5;129m"
        export TEAL="\e[38;5;30m"
        export LIME="\e[38;5;154m"
        export GRAY="\e[38;5;245m"
        export BROWN="\e[38;5;94m"
        export GOLD="\e[38;5;220m"
        export NAVY="\e[38;5;19m"
        export MAROON="\e[38;5;88m"
        export SILVER="\e[38;5;251m"

    elif [[ "$COLOR_MODE" == "16bit" || "$COLOR_MODE" == "8bit" ]]; then
        export RED="\e[31m"
        export GREEN="\e[32m"
        export BLUE="\e[34m"
        export YELLOW="\e[33m"
        export MAGENTA="\e[35m"
        export CYAN="\e[36m"
        export WHITE="\e[37m"
        export BLACK="\e[30m"
        export LAVENDER="\u001b[38;5;147m"
        export ORANGE="\e[33m"
        export PINK="\e[35m"
        export PURPLE="\e[35m"
        export TEAL="\e[36m"
        export LIME="\e[32m"
        export GRAY="\e[37m"
        export BROWN="\e[33m"
        export GOLD="\e[33m"
        export NAVY="\e[34m"
        export MAROON="\e[31m"
        export SILVER="\e[37m"

    else
        export RED="" GREEN="" BLUE="" YELLOW=""
        export MAGENTA="" CYAN="" WHITE="" BLACK=""
        export ORANGE="" PINK="" PURPLE="" TEAL=""
        export LIME="" GRAY="" BROWN="" GOLD=""
        export NAVY="" MAROON="" SILVER="" LAVENDER=""
    fi

    # Define bold variants
    export BOLD="\e[1m"

    export BOLD_RED="${BOLD}${RED}"
    export BOLD_GREEN="${BOLD}${GREEN}"
    export BOLD_BLUE="${BOLD}${BLUE}"
    export BOLD_YELLOW="${BOLD}${YELLOW}"
    export BOLD_MAGENTA="${BOLD}${MAGENTA}"
    export BOLD_CYAN="${BOLD}${CYAN}"
    export BOLD_WHITE="${BOLD}${WHITE}"
    export BOLD_BLACK="${BOLD}${BLACK}"
    export BOLD_ORANGE="${BOLD}${ORANGE}"
    export BOLD_PINK="${BOLD}${PINK}"
    export BOLD_PURPLE="${BOLD}${PURPLE}"
    export BOLD_TEAL="${BOLD}${TEAL}"
    export BOLD_LIME="${BOLD}${LIME}"
    export BOLD_GRAY="${BOLD}${GRAY}"
    export BOLD_BROWN="${BOLD}${BROWN}"
    export BOLD_GOLD="${BOLD}${GOLD}"
    export BOLD_NAVY="${BOLD}${NAVY}"
    export BOLD_MAROON="${BOLD}${MAROON}"
    export BOLD_SILVER="${BOLD}${SILVER}"

    # Reset color
    export NC="\e[0m"
}


__generate_colors

alias os.detect.ansi_support='__detect_ansi_support'
alias os.generate.colors='__generate_colors'