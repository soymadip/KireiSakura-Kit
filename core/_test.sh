echo -e "\n\n"
sleep 0.5; clear -x

echo -e "\n--------------------- KireiSakura Kit Test Utility ----------------------\n\n"


export LOG_FILE="Kirei-test.log"
export CACHE_DIR="$HOME/.cache/test_setup_dir"


echo -e "\n\n---------: TO BE EXPORTED BY KIT :---------\n"
kireisakura -i


echo -e "\n\n-----------: SETTING KIT :-----------\n"
eval "$(kireisakura -i)"


echo -e  "\n\n-------: EXPORTED VARIABLES :-------\n"
echo  -e " ${GREEN}Log file name${NC} (kirei_log_file):   $kirei_log_file"
echo  -e " ${GREEN}Cache dir${NC}    (kirei_cache_dir):   $kirei_cache_dir"
echo  -e " ${GREEN}Installation dir${NC}   (kirei_dir):   $kirei_dir"
echo  -e " ${GREEN}Core dir${NC}      (kirei_core_dir):   $kirei_core_dir"
echo  -e " ${GREEN}Core file${NC}         (kirei_core):   $kirei_core"
echo  -e " ${GREEN}Module dir${NC}  (kirei_module_dir):   $kirei_module_dir"


log.warn "\n\n------------: LOGS :-----------\n"
log.success "Log level: success"
log.error "Log level: error"
log.warn "Log level: inform"


echo -e "\n\n--------: IMPORTING ALL MODULES :--------\n"

kimport -a # loads all


log.success "\n\n============= TEST SUCCESSFULLY COMPLETED =============="


echo -e "\n\n\n------------------------- END ----------------------------\n"
