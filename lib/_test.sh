#!/bin/env bash

set -e # Exit on error
# set -x

#

export PROJECT_NAME="Kirei-Test"
export LOG_FILE_NAME="Kirei-test.log"

#

echo -e "\n\033[38;5;225m-----------: SETTING KIT :-----------\033[0m\n"
eval "$(kireisakura -i)"

#

echo -e "\n${LAVENDER}-------: VERSION CHECKS :-------${NC}\n"

if [[ -n "$K_KIT_VERSION" && -n "$K_KIT_UPSTREAM_VERSION" ]]; then
  echo -e "${GREEN}✔ Local version: $K_KIT_VERSION${NC}"
  echo -e "${GREEN}✔ Upstream version: $K_KIT_UPSTREAM_VERSION${NC}"UPSTREAM_VERSION${NC}"
else
  echo -e "${RED}X Version information not available${NC}"
fi

echo -e "\n${LAVENDER}-------: SUPER VARIABLES :-------${NC}\n"

super_vars=(
  "K_KIT_DIR"
  "K_LIB_DIR"
  "K_INIT_FILE"
  "K_PACKAGE_DIR"
  "K_ASSETS_DIR"
  "K_KIT_NAME"
  "K_KIT_OWNER"
  "K_KIT_SITE"
  "K_KIT_REPO"
  "K_KIT_BRANCH"
  "K_KIT_INSTALLER_URL"
  "K_KIT_VER_URL"
  "K_KIT_UPSTREAM_VER_URL"
  "K_KIT_VERSION"
  "K_KIT_UPSTREAM_VERSION"
  "K_PRJ_NAME"
  "K_PRJ_OWNER"
  "K_PRJ_URL"
  "K_PRJ_REPO"
  "K_PRJ_CONFIG"
  "K_CACHE_DIR"
  "K_LOG_FILE"
)

missing_vars=()

for var in "${super_vars[@]}"; do

  if [[ -z "${!var}" ]]; then
    missing_vars+=("$var")
    echo -e "${RED}X${NC} ${BOLD_RED} $var: ${NC}"
  else
    echo -e "${GREEN}✔${NC} ${BOLD_GREEN}$var${NC}: ${!var}"
  fi
done

if [[ ${#missing_vars[@]} -gt 0 ]]; then
  echo -e "\n${RED}X${NC} ${BOLD_RED} Missing Super Vars: ${NC}"
  for var in "${missing_vars[@]}"; do
    echo -e "      $var"
  done
  exit 1
else
  echo -e "\n${GREEN}✔${NC} ${BOLD_GREEN} All super variables are properly set.${NC}"
fi

#

echo -e "\n${LAVENDER}-------: CHECKING CACHE DIR :-------${NC}\n"

if [[ -d "$K_CACHE_DIR" ]]; then
  echo -e "${GREEN}✔ Cache dir exists${NC}"
else
  echo -e "${RED}X Cache dir doesn't exist${NC}"
  exit 1
fi

if [[ -f "$K_LOG_FILE" ]]; then
  echo -e "${GREEN}✔ log file exists${NC}"
else
  echo -e "${RED}X log file doesn't exist${NC}"
  exit 1
fi

#

echo -e "\n${LAVENDER}---------- COLORS ----------${NC}\n"

colors=(
  "RED:Red"
  "GREEN:Green"
  "BLUE:Blue"
  "YELLOW:Yellow"
  "MAGENTA:Magenta"
  "CYAN:Cyan"
  "WHITE:White"
  "ORANGE:Orange"
  "PINK:Pink"
  "PURPLE:Purple"
  "TEAL:Teal"
  "LIME:Lime"
  "GRAY:Gray"
  "BROWN:Brown"
  "GOLD:Gold"
  "NAVY:Navy"
  "MAROON:Maroon"
  "SILVER:Silver"
)

for color_pair in "${colors[@]}"; do
  color_var="${color_pair%%:*}"
  color_name="${color_pair##*:}"
  bold_var="BOLD_${color_var}"

  printf "${!color_var}%-10s${NC} | ${!bold_var}%-10s${NC}\n" "$color_name" "Bold $color_name"
done

#

echo -e "\n${LAVENDER}------------: LOGS :-----------${NC}\n"

log.info "Log level: info"
log.success "Log level: success"
log.error "Log level: error"
log.warn "Log level: warn"

#

echo -e "\n${LAVENDER}--------: IMPORTING ALL MODULES :--------${NC}\n"

kimport utils.font utils.app-patches


echo -e "\n${LAVENDER}---------- REMOVING CACHE DIR ----------${NC}\n"

if rm -rf "$K_CACHE_DIR"; then
  echo -e "${GREEN}✔ Cache dir removed.${NC}"
  exit 0
else
  echo -e "${RED}X Failed to remove Cache dir.${NC}"
  exit 1
fi
