# Name of this module.
# Short info about what this module does.
# Credits: creator of the module.

#
#
#==---------------------------------------------------------------------------------
# NAME:   __example_method
# ALIAS:  _example.method
# DESC:   Example method that demonstrates how to structure a method.
# USAGE:  _example.method
#==---------------------------------------------------------------------------------
__method() {
    if ui.prompt "Do you want start example method?"; then
        log "Executing step 1"     # log your message/instruction...
        date                       # commands
        time                       # another command
        log "Executing step 2"     # log, pattern: log "your message for logs" < log mode (normal or null/error/inform) >
        ls -a                      # another command
        swapon --show              # another command
        inform "inforning"         # Print test in Bold yellow
        ui.footer "Completed executing example method"    # pattern: print_footer "Your success message"
    else
        log.warn "Skipped executing eample method"     # log error
        ui.footer                     # To print the footer only, without message.
    fi
}
#==---------------------------------------------------------------------------------



#_____________________ Aliases _________________________
alias _example.method='__method'
