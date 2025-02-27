#!/usr/bin/env bash

#  ____      _
# / ___|___ | | ___  _ __ ___
#| |   / _ \| |/ _ \| '__/ __|
#| |__| (_) | | (_) | |  \__ \
# \____\___/|_|\___/|_|  |___/
#
# Detect terminal color support and define color codes

detect-ansi-support() {
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

generate-colors() {
    local COLOR_MODE=$(detect-ansi-support)

    # Define colors
    if [[ "$COLOR_MODE" == "256bit" ]]; then
        echo 'export RED="\e[38;5;196m"'
        echo 'export GREEN="\e[38;5;46m"'
        echo 'export BLUE="\e[38;5;27m"'
        echo 'export YELLOW="\e[38;5;226m"'
        echo 'export MAGENTA="\e[38;5;201m"'
        echo 'export CYAN="\e[38;5;51m"'
        echo 'export WHITE="\e[38;5;231m"'
        echo 'export BLACK="\e[38;5;16m"'
        echo 'export LAVENDER="\u001b[38;5;147m"'
        echo 'export ORANGE="\e[38;5;214m"'
        echo 'export PINK="\e[38;5;213m"'
        echo 'export PURPLE="\e[38;5;129m"'
        echo 'export TEAL="\e[38;5;30m"'
        echo 'export LIME="\e[38;5;154m"'
        echo 'export GRAY="\e[38;5;245m"'
        echo 'export BROWN="\e[38;5;94m"'
        echo 'export GOLD="\e[38;5;220m"'
        echo 'export NAVY="\e[38;5;19m"'
        echo 'export MAROON="\e[38;5;88m"'
        echo 'export SILVER="\e[38;5;251m"'

    elif [[ "$COLOR_MODE" == "16bit" || "$COLOR_MODE" == "8bit" ]]; then
        echo 'export RED="\e[31m"'
        echo 'export GREEN="\e[32m"'
        echo 'export BLUE="\e[34m"'
        echo 'export YELLOW="\e[33m"'
        echo 'export MAGENTA="\e[35m"'
        echo 'export CYAN="\e[36m"'
        echo 'export WHITE="\e[37m"'
        echo 'export BLACK="\e[30m"'
        echo 'export LAVENDER="\u001b[38;5;147m"'
        echo 'export ORANGE="\e[33m"'
        echo 'export PINK="\e[35m"'
        echo 'export PURPLE="\e[35m"'
        echo 'export TEAL="\e[36m"'
        echo 'export LIME="\e[32m"'
        echo 'export GRAY="\e[37m"'
        echo 'export BROWN="\e[33m"'
        echo 'export GOLD="\e[33m"'
        echo 'export NAVY="\e[34m"'
        echo 'export MAROON="\e[31m"'
        echo 'export SILVER="\e[37m"'

    else
        echo 'export RED="" GREEN="" BLUE="" YELLOW=""'
        echo 'export MAGENTA="" CYAN="" WHITE="" BLACK=""'
        echo 'export ORANGE="" PINK="" PURPLE="" TEAL=""'
        echo 'export LIME="" GRAY="" BROWN="" GOLD=""'
        echo 'export NAVY="" MAROON="" SILVER="" LAVENDER=""'
   fi

    # Define bold variants
    echo 'export BOLD="\e[1m"'

    echo 'export BOLD_RED="${BOLD}${RED}"'
    echo 'export BOLD_GREEN="${BOLD}${GREEN}"'
    echo 'export BOLD_BLUE="${BOLD}${BLUE}"'
    echo 'export BOLD_YELLOW="${BOLD}${YELLOW}"'
    echo 'export BOLD_MAGENTA="${BOLD}${MAGENTA}"'
    echo 'export BOLD_CYAN="${BOLD}${CYAN}"'
    echo 'export BOLD_WHITE="${BOLD}${WHITE}"'
    echo 'export BOLD_BLACK="${BOLD}${BLACK}"'
    echo 'export BOLD_ORANGE="${BOLD}${ORANGE}"'
    echo 'export BOLD_PINK="${BOLD}${PINK}"'
    echo 'export BOLD_PURPLE="${BOLD}${PURPLE}"'
    echo 'export BOLD_TEAL="${BOLD}${TEAL}"'
    echo 'export BOLD_LIME="${BOLD}${LIME}"'
    echo 'export BOLD_GRAY="${BOLD}${GRAY}"'
    echo 'export BOLD_BROWN="${BOLD}${BROWN}"'
    echo 'export BOLD_GOLD="${BOLD}${GOLD}"'
    echo 'export BOLD_NAVY="${BOLD}${NAVY}"'
    echo 'export BOLD_MAROON="${BOLD}${MAROON}"'
    echo 'export BOLD_SILVER="${BOLD}${SILVER}"'

    # Reset color
    echo 'export NC="\e[0m"'
}

# Export color codes
generate-colors