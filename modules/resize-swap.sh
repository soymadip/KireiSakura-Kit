# Function to Resize swap file:




resize_swap() {
    echo -e "Do you wanna Create/Resize your swapfile? (y/n)\n(Your swap file will be of ${swap_file_size}B)"
    read -p "=>"   rsz_swapf
    if [ "$rsz_swapf" == "y" ] || [ "$rsz_swapf" == "Y" ] || [ -z "$rsz_swapf" ]; then
        if [ -f "$swap_file" ]; then
            log.info "Swapfile already exists. Resizing to $swap_file_size..."
            log.warn "turning off swaps"
            sudo swapoff -a
            log.warn "removing already present swapfile."
            sudo rm "$swap_file"
        else
            log.info "Creating swapfile of size $swap_file_size..."
        fi
        log.warn "creating new file of ${swap_file_size}B for swap."
        sudo fallocate -l "$swap_file_size" "$swap_file"
        log.warn "changing permissions."
        sudo chmod 600 "$swap_file"
        log.warn "making the ${swap_file} a swapfile."
        sudo mkswap "$swap_file"
        log.warn "turning new swapfile on"
        sudo swapon "$swap_file"
        log.warn "please check if everything is good:"
        swapon --show
        footer "Swapfile created and activated."
    else
        echo -e "${RED}swapfile size change skipped.${NC}"
    fi
}
