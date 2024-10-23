export LOG_FILE="test_script.log"
export CACHE_DIR="$HOME/.cache/test_setup_dir"

echo -e "\n Kirei Sakura Test Script"
eval "$(kireisakura -i)"


#//////////////// SCRIPT START \\\\\\\\\\\\\\\\

echo -e "\n\n"
log "Here are dirs:------" inform
echo  -e "" 
echo  -e " Log file name:    $kirei_log_file" 
echo  -e " Cache dir:        $kirei_cache_dir" 
echo  -e " Installation dir: $kirei_dir" 
echo  -e " Core dir:         $kirei_core_dir" 
echo  -e " Core file:        $kirei_core" 
echo  -e " Modules dir:      $kirei_module_dir" 

echo  -e "\n"


kimport restore-dotfiles install-fonts  install-pkgs  kde-plasma-utils

rm -rf $kirei_cache_dir
