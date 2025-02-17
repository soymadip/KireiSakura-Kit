---
title: 6. TODO
icon: circle-dot
---
<h1 align="center">RoadMap</h1>

## Initial Release

- [x] Make `init.sh` in kit root for initialisation.

- [x] Make setup command: `eval "$(kireisakura --init)"`

- [x] Make other commands:
    - [x] `kireisakura -h`
    - [x] `kireisakura -v`
    - [x] `kireisakura -d`
    - [x] `kireisakura -i`
    - [x] `kireisakura -u`

- [x] Make a test script.

- [x] Make install script.

- [x] Better directory structure.

- [x] Revamp project.
    - [x] Better directory structure.
    - [x] Clearer naming conventions.
    - [x] Make old Modules compatible.

- [x] Implement Auto-Update.

- [ ] Make a clearer Design guide.
      - The functons will print log with a tab at front.
      - so users heading, then function's logs...

- [x] Config file support.
    - [ ] ~~toml as format?~~
    - [ ] ~~use of [YQ](https://chatgpt.com/share/671ab466-aaf0-8001-ba21-ae748636e88b)?~~
    - [x] Use `config.sh` & variables. 

- [ ] Check if core functions & dependency functions are loaded and set that script load flag true using a variable.

- [ ] Add support for packages.
    - [ ] Add `kmp` command for managing package.
    - [ ] move existing modules to /packages dir.
    - [ ] 3rd party packages will be installed there.
        - [ ] can be imported with package_name.module_name syntax.

----------------------------------------------------------------

## Another Time

- [ ] Make use of log file in more functions (for more detailed logs).
- [ ] Add more config options, make use of config file more.
- [ ] Add `-q` or `--quiet` flag to all possible functions.
- [ ] Write documentation (help needed).
- [ ] Enable completions (still thinking if useful):
    - Make script.
    - Source the file.
    - In install script: `printf "echo \"fpath+=(\"${kirei_dir}/completions\")\" >> \"${zsh_rc}\""`