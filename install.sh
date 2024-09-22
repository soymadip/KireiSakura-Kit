#!/usr/bin/env bash

export LIB_DIR="${HOME}/.local/lib"
export BIN_DIR="${HOME}/.local/bin"

export KIT_DIR="${LIB_DIR}/KireiSakura-Kit"
export KIT_REPO="soymadip/KireiSakura-Kit"
export KIT_URL="https://github.com/${KIT_REPO}"
export RELEASE="$(curl -s -S  https://raw.githubusercontent.com/${KIT_REPO}/main/.version)"


# Make Kit dir
mkdir -p "$KIT_DIR" "$BIN_DIR"

# Download release.
curl -LsS "${KIT_URL}/archive/refs/tags/${RELEASE}.zip"


# Extract the catppuccin zip file
unzip ${REKEASE}.zip


ln -sf "${KIT_DIR}/init.sh" "${BIN_DIR}/Kireisakura"
