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
        - [ ] Use ~~`.sh`~~ Yaml as format. 
        - [ ] Use YQ.
        - [ ] Make config hiararchy.
        - [ ] Allow customization, metadata input.
    
    - [ ] Add support for packages.
        - [x] Add `kmp` command for managing package.
            - [ ] make package registry in separate branch.
        - [x] Packages will reside in /packages dir.
        - [ ] Allow changing package dir.
        - [x] move existing modules to `utils` package.
        - [ ] Update `kimport` for importing plugin modules:
            - [x] For single plugin module:     `packageName.moduleName`
            - [ ] For all module in a package:  `packageName`
            - [x] For local module:              `.moduleName`
            - [ ] For all local module:          `.`

    - [ ] Write documentation [(help needed)](./contributing.md#how-to-help-writing-docs).
        - [x] Terms, Initialization, todo, faq.
        - [ ] Config Options.
        - [ ] Methods.

    - [ ] Make a clearer Design guide.
        - methods form packages should name with packageName.methodName
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
    - [ ] check for internet connection: `ping -c 2 soymadip.github.com &>/dev/null`
