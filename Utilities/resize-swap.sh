# Function to Resize swap file:




resize_swap() {
    echo -e "Do you wanna Create/Resize your swapfile? (y/n)\n(Your swap file will be of ${swap_file_size}B)"
    read -p "=>"   rsz_swapf
    if [ "$rsz_swapf" == "y" ] || [ "$rsz_swapf" == "Y" ] || [ -z "$rsz_swapf" ]; then
        if [ -f "$swap_file" ]; then
            print_header "Swapfile already exists. Resizing to $swap_file_size..."
            log "turning off swaps"  #log
            sudo swapoff -a
            log "removing already present swapfile."   #log
            sudo rm "$swap_file"
        else
            print_header "Creating swapfile of size $swap_file_size..."
        fi
        log "creating new file of ${swap_file_size}B for swap."   #log
        sudo fallocate -l "$swap_file_size" "$swap_file"
        log "changing permissions." #log
        sudo chmod 600 "$swap_file"
        log "making the ${swap_file} a swapfile."   #log
        sudo mkswap "$swap_file"
        log "turning new swapfile on" #log
        sudo swapon "$swap_file"
        log "please check if everything is good:" #log
        swapon --show
        print_footer "Swapfile created and activated." #log
    else
        echo -e "${RED}swapfile size change skipped.${NC}"
    fi
}
