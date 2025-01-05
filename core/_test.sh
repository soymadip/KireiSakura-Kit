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

# echo -e "\n${LAVENDER}-------: OUTPUT BY KIT :-------${NC}\n"
# kireisakura -i

#

echo -e "\n${LAVENDER}-------: EXPORTED VARIABLES :-------${NC}\n"

echo -e " ${GREEN}Installation dir${NC}   (kirei_dir):     $kirei_dir"
echo -e " ${GREEN}Core dir${NC}      (kirei_core_dir):     $kirei_core_dir"
echo -e " ${GREEN}Core file${NC}         (kirei_core):     $kirei_core"
echo -e " ${GREEN}Module dir${NC}  (kirei_module_dir):     $kirei_module_dir"
echo -e " ${GREEN}Assets dir${NC}  (kirei_assets_dir):     $kirei_assets_dir"
echo -e "\n"
echo -e " ${GREEN}Project name${NC} (kirei_project_name):  $kirei_project_name"
echo -e " ${GREEN}Cache dir${NC}    (kirei_cache_dir):     $kirei_cache_dir"
echo -e " ${GREEN}Log file name${NC} (kirei_log_file):     $kirei_log_file"

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

echo -e "\n${LAVENDER}------------: LOGS :-----------${NC}\n"

log.info "Log level: info"
log.success "Log level: success"
log.error "Log level: error"
log.warn "Log level: inform"

#

echo -e "\n${LAVENDER}--------: IMPORTING ALL MODULES :--------${NC}\n"

if kimport -a; then
  log.success "All modules imported."
else
  log.error "Failed to import all modules."
  exit 1
fi

#

echo -e "\n${LAVENDER}---------- REMOVING CACHE DIR ----------${NC}\n"

if rm -rf "$kirei_cache_dir"; then
  echo -e "${GREEN}[✔]-> Cache dir removed.${NC}"
  exit 0
else
  echo -e "${RED}[X]-> Failed to remove Cache dir.${NC}"
  exit 1
fi
