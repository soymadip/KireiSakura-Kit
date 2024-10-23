# Name of this module.
# Short info about what this module does.
# Credits: creator of the module.

example_function() {
    prompt "Do you want start example function?" confirm_exfunc   # pattern: prompt "your question to ask" < return variable of respond, starting with confirm_ >
    if [ "$confirm_exfunc" == "y" ] || [ "$confirm_exfunc" == "Y" ] || [ -z "$confirm_exfunc" ]; then
        log "Executing step 1"     # log your message/instruction...
        date                       # commands
        time                       # another command
        log "Executing step 2"     # log, pattern: log "your message for logs" < log mode (normal or null/error/inform) > 
        ls -a                      # another command
        swapon --show              # another command
        inform "inforning"         # Print test in Bold yellow
        print_footer "Completed executing example function"   # pattern: print_footer "Your success message"
    else
    log "Skipped executing eample function" inform         # log error
    print_footer                   # To print the footer only, without message.
    fi
}



test() {
    prompt "User Prompt with question" confirm_exfunc   # pattern: prompt "your question to ask" < return variable of respond, starting with confirm_ >
    if [ "$confirm_exfunc" == "y" ] || [ "$confirm_exfunc" == "Y" ] || [ -z "$confirm_exfunc" ]; then
        log "simple log"     
        log "inform log " inform
        log "need attention/important" imp             
        log "error log " error "TESTER"
        check_dependency keepassxc
        change_shell
        install_chaotic_aur
        prompt "User Prompt with next question" test_sx
        if [ "$test_sx" == "y" ] || [ -z "$test_sx" ]; then
        check_dependency keepassxc
            print_footer "Function complete"
        else
            print_footer "Process skipped" "skiped"
        fi
        print_footer "Complete function footer & then footer"
        cfrm_reboot
    else
        print_footer "Process skipped" skipped
        exit 
    fi
}
