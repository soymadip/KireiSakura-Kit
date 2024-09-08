export LOG_FILE="test_script.log"
export CACHE_DIR="$HOME/.cache/test_setup_dir"

eval "$(kireisakura -i )"


#//////////////// SCRIPT START \\\\\\\\\\\\\\\\

kimport restore_dotfiles install_fonts  install_pkgs  kde-plasma_utils

log "This is a test script" inform




log "Here are dirs:------" inform
echo  -e "" 
echo  -e " Log file name:    $kirei_log_file" 
echo  -e " Cache dir:        $kirei_cache_dir" 
echo  -e " Installation dir: $kirei_dir" 
echo  -e " Utilities dir:    $kirei_utils_dir" 
echo  -e " Core file:        $kirei_core" 
echo  -e "\n"


rm -rf $kirei_cache_dir
