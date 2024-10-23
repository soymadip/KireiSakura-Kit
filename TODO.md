# Future Plans:

## For Initial Release:

- [x] Make `init.sh` in kit root for initialization.
- [x] Make setup command: `eval "$(kireisakura --init)"`
- [x] Make other commands:
  - `kireisakura -h`
  - `kireisakura -v`
  - `kireisakura -d` etc.
- [x] Make a test script.
- [x] Make install script.
- [x] Better directory structure.

## For Another Time:

- [x] Implement Auto-Update.
- [ ] Make use of log file in more functions (for more detailed logs).
- [ ] Check if core functions & dependency functions are loaded and set that script load flag true using a variable.
- [ ] Add `-q` or `--quiet` flag to all possible functions.
- [ ] Write documentation (help needed).
- [ ] Enable completions (still thinking if useful):
  - Make script.
  - Source the file.
  - In install script: `printf "echo \"fpath+=(\"${kirei_dir}/completions\")\" >> \"${zsh_rc}\""`
