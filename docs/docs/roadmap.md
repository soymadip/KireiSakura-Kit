---
title: RoadMap
icon: material/clipboard-text-clock-outline
---
<h1 align="center"><b>RoadMap</b></h1>

=== "Stable Release"

    - [x] Make `init.sh` in kit root for initialisation.
    
    - [x] Make setup command: `eval "$(kireisakura --init)"`
    
    - [x] Make other commands:
        - [x] `kireisakura -h`
        - [x] `kireisakura -v`
        - [x] `kireisakura -d`
        - [x] `kireisakura -i`
        - [x] `kireisakura -u`
    
    - [x] Make install script.

    - [x] Make a test script.
    
    - [x] Revamp project.
        - [x] Better directory structure.
        - [x] Clearer naming conventions.
        - [x] Make old Modules compatible.
    
    - [x] Implement Auto-Update.

    - [x] Config file support.
        - [ ] ~~toml as format? Use of [YQ](https://chatgpt.com/share/671ab466-aaf0-8001-ba21-ae748636e88b)?~~
        - [x] Use `config.sh` & variables. 
    
    - [ ] Add support for packages.
        - [x] Add `kmp` command for managing package.
        - [ ] Packages will reside in /packages dir.
        - [x] move existing modules to `utils` package.
        - [ ] Update `kimport` for importing plugin modules:
            - [x] For single plugin module:            `packageName.moduleName`
            - [x] For local module:              `.moduleName`
            - [ ] For all module in a package:  `packageName.`
            - [ ] For all local module:          `.`

    - [ ] Write documentation (help needed).
        - [x] Terms, Initialization, todo, faq.
        - [ ] Methods.

    - [ ] Make a clearer Design guide.
          - The functons will print log with a tab at front.
          - so users heading, then function's logs...


=== "Later in Time"

    - [ ] Check if core functions & dependency functions are loaded and set that script load flag true using a variable.
    - [ ] Make use of log file in more functions (for more detailed logs).
    - [ ] Add more config options, make use of config file more.
    - [ ] Add `-q` or `--quiet` flag to all possible functions.
    - [ ] Enable completions (still thinking if useful):
        - Make script.
        - Source the file.
        - In install script: `printf "echo \"fpath+=(\"${kirei_dir}/completions\")\" >> \"${zsh_rc}\""`
