# Future plans:



## For initial release:

[x] Make `init.sh` in kit root for initialization.

[x] Make setup command: eval "$(kireisakura --init)" 

[x] Make other commands: kireisakura -h
                         kireisakura -v          
                         kireisakura -d etc..

[x] Make a test sctipt.

[ ] Make install script.


## For another time:

[ ] Implement Auto-Update.

[ ] Make use of log file in more functions (for more detailed logs).

[ ] Check if core functions & dependency functions are loaded and set that script load true using a variable

[ ] Add -q or --quiet flag to all possible functions.

[ ] Write documentation (help needed)

[ ] Enable completions.
        make script. 
        source the file.
        in install sctipt: printf "echo \"fpath+=(\"${kirei_dir}\"/completions)\" >> \"${zsh_rc} \" "

