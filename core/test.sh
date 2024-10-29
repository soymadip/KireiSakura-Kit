echo -e "\n\n"
clear -x
echo -e "\n--------------------- KireiSakura Kit Test Utility ----------------------\n\n"


export LOG_FILE="test_script.log"
export CACHE_DIR="$HOME/.cache/test_setup_dir"


eval "$(kireisakura -i)"; echo -e "\n"



log.warn "Set variables:------\n"
echo  -e " ${GREEN}Log file name${NC} (kirei_log_file):   $kirei_log_file"
echo  -e " ${GREEN}Cache dir${NC}    (kirei_cache_dir):   $kirei_cache_dir"
echo  -e " ${GREEN}Installation dir${NC}   (kirei_dir):   $kirei_dir"
echo  -e " ${GREEN}Core dir${NC}      (kirei_core_dir):   $kirei_core_dir"
echo  -e " ${GREEN}Core file${NC}         (kirei_core):   $kirei_core"
echo  -e " ${GREEN}Module dir${NC}  (kirei_module_dir):   $kirei_module_dir"
echo  -e "\n\n"


log.warn "Logs:------\n"

log.success "Log level: success"
log.error "Log level: error"
log.warn "Log level: inform"
echo  -e "\n\n"


log.warn "Importing modules:------\n"

kimport restore-dotfiles install-fonts kde-plasma-utils disk-utils
echo  -e "\n\n"


rm -rf $kirei_cache_dir
rm $kirei_log_file


echo -e "\n\n------------------------- END ----------------------------\n"
