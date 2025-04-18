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

echo -e "\n${LAVENDER}-------: SUPER VARIABLES :-------${NC}\n"

echo -e " ${GREEN}Installation dir${NC}    (kirei_dir):    $kirei_dir"
echo -e " ${GREEN}Core dir${NC}       (kirei_core_dir):    $kirei_core_dir"
echo -e " ${GREEN}Core file${NC}          (kirei_loader):    $kirei_loader"
echo -e " ${GREEN}Package dir${NC} (kirei_package_dir):    $kirei_package_dir"
echo -e " ${GREEN}Assets dir${NC}   (kirei_assets_dir):    $kirei_assets_dir"
echo -e "\n"
echo -e " ${GREEN}Project name${NC} k_project_name):   $k_project_name"
echo -e " ${GREEN}Cache dir${NC}     (kirei_cache_dir):    $kirei_cache_dir"
echo -e " ${GREEN}Log file name${NC}  (kirei_log_file):    $kirei_log_file"

#

echo -e "\n${LAVENDER}-------: CHECKING CHACHE DIR :-------${NC}\n"

if [[ -d "$kirei_cache_dir" ]]; then
  echo -e " ${GREEN}Cache dir exists${NC}"
else
  echo -e " ${RED}Cache dir doesn't exist${NC}"
  exit 1
fi

if [[ -f "$kirei_log_file" ]]; then
  echo -e " ${GREEN}log file exists${NC}"
else
  echo -e " ${RED}log file doesn't exist${NC}"
  exit 1
fi

#

echo -e "\n${LAVENDER}---------- COLORS ----------${NC}\n"

echo -e "${RED}Red${NC} | ${BOLD_RED}Bold Red${NC}"
echo -e "${GREEN}Green${NC} | ${BOLD_GREEN}Bold Green${NC}"
echo -e "${BLUE}Blue${NC} | ${BOLD_BLUE}Bold Blue${NC}"
echo -e "${YELLOW}Yellow${NC} | ${BOLD_YELLOW}Bold Yellow${NC}"
echo -e "${MAGENTA}Magenta${NC} | ${BOLD_MAGENTA}Bold Magenta${NC}"
echo -e "${CYAN}Cyan${NC} | ${BOLD_CYAN}Bold Cyan${NC}"
echo -e "${WHITE}White${NC} | ${BOLD_WHITE}Bold White${NC}"
echo -e "${ORANGE}Orange${NC} | ${BOLD_ORANGE}Bold Orange${NC}"
echo -e "${PINK}Pink${NC} | ${BOLD_PINK}Bold Pink${NC}"
echo -e "${PURPLE}Purple${NC} | ${BOLD_PURPLE}Bold Purple${NC}"
echo -e "${TEAL}Teal${NC} | ${BOLD_TEAL}Bold Teal${NC}"
echo -e "${LIME}Lime${NC} | ${BOLD_LIME}Bold Lime${NC}"
echo -e "${GRAY}Gray${NC} | ${BOLD_GRAY}Bold Gray${NC}"
echo -e "${BROWN}Brown${NC} | ${BOLD_BROWN}Bold Brown${NC}"
echo -e "${GOLD}Gold${NC} | ${BOLD_GOLD}Bold Gold${NC}"
echo -e "${NAVY}Navy${NC} | ${BOLD_NAVY}Bold Navy${NC}"
echo -e "${MAROON}Maroon${NC} | ${BOLD_MAROON}Bold Maroon${NC}"
echo -e "${SILVER}Silver${NC} | ${BOLD_SILVER}Bold Silver${NC}"

#

echo -e "\n${LAVENDER}------------: LOGS :-----------${NC}\n"

log.info "Log level: info"
log.success "Log level: success"
log.error "Log level: error"
log.warn "Log level: inform"

#

echo -e "\n${LAVENDER}--------: IMPORTING ALL MODULES :--------${NC}\n"

kimport utils.os utils.app-patches utils.font


font.list


echo -e "\n${LAVENDER}---------- REMOVING CACHE DIR ----------${NC}\n"

if rm -rf "$kirei_cache_dir"; then
  echo -e "${GREEN}[✔]-> Cache dir removed.${NC}"
  exit 0
else
  echo -e "${RED}[X]-> Failed to remove Cache dir.${NC}"
  exit 1
fi
