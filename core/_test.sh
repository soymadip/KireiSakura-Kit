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

if [[ -n "$k_kit_version" && -n "$k_kit_upstream_version" ]]; then
  echo -e "${GREEN}✔ Local version: $k_kit_version${NC}"
  echo -e "${GREEN}✔ Upstream version: $k_kit_upstream_version${NC}"
else
  echo -e "${RED}X Version information not available${NC}"
fi

echo -e "\n${LAVENDER}-------: SUPER VARIABLES :-------${NC}\n"

super_vars=(
  "k_kit_dir"
  "k_core_dir"
  "k_init_file"
  "k_package_dir"
  "k_assets_dir"
  "k_kit_name"
  "k_kit_owner"
  "k_kit_site"
  "k_kit_repo"
  "k_kit_branch"
  "k_kit_installer_url"
  "k_kit_ver_url"
  "k_kit_upstream_ver_url"
  "k_kit_version"
  "k_kit_upstream_version"
  "k_prj_name"
  "k_prj_owner"
  "k_prj_url"
  "k_prj_repo"
  "k_prj_config"
  "k_cache_dir"
  "k_log_file"
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

if [[ -d "$k_cache_dir" ]]; then
  echo -e "${GREEN}✔ Cache dir exists${NC}"
else
  echo -e "${RED}X Cache dir doesn't exist${NC}"
  exit 1
fi

if [[ -f "$k_log_file" ]]; then
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

if rm -rf "$k_cache_dir"; then
  echo -e "${GREEN}✔ Cache dir removed.${NC}"
  exit 0
else
  echo -e "${RED}X Failed to remove Cache dir.${NC}"
  exit 1
fi
