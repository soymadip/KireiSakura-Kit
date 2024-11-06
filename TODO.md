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

- [ ]  Make a clearer Design guide.

- [x] Revamp project.
  - [x] Better directory structure.
  - [x] Clearer naming conventions.
  - [x] Make old Modules compatible.

## For Another Time:

- [x] Implement Auto-Update.
- [ ] Make use of log file in more functions (for more detailed logs).
- [ ] Check if core functions & dependency functions are loaded and set that script load flag true using a variable.
- [ ] Config file support.
    - [ ] toml as format?
    - [ ] use of [yq][yq_cg]?
- [ ] Add `-q` or `--quiet` flag to all possible functions.
- [ ] Write documentation (help needed).
- [ ] Enable completions (still thinking if useful):
  - Make script.
  - Source the file.
  - In install script: `printf "echo \"fpath+=(\"${kirei_dir}/completions\")\" >> \"${zsh_rc}\""`

</br></br>


# Directory structure:

```shell
./
 |- Assets/         - holds icon, default configs etc..
 |- bin/kireisakura - enables command, help message, version message, init system, updater.
 |- core/
 |      |- _loader  - loads configs & modules.
 |      |- logging  - enables logging.
 |      |- test     - test script to verify the setup.
 |      |- ui       - holds ui components.
 |      |- utils    - holds core functions.
 |      └─ updater  - as the name suggests :)
 |
 |- modules/        - holds modules
 └- .version        - vesion number

```





[yq_cg]: [yq](https://chatgpt.com/share/671ab466-aaf0-8001-ba21-ae748636e88b)
