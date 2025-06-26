---
title: RoadMap
icon: material/calendar-clock
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
        - [ ] Make old Modules compatible.
    
    - [ ] Implement Auto-Update.

    - [ ] Make a clearer Design guide.
        1. **Packages:-**
            - Should contain `__init__.sh` file for initialisation, it will be sourced first.
        2. **Modules:-**
            - Should be contained using package or `local` dir in project
            - Should be named using kebab-case
        3. **Methods:-**
            - Names start with `__` & follow `snake_case`.
            - Aliased using `moduleName.method-name` format.
                - `moduleName` should be same as modlule file (without `.sh`).
                - `method-name` should follow kebab case.
            - Methods from packages should use same format
        4. **Logging:-**
            - [ ]  Properly parse escape sequences.
    
    - [ ] Config file support.
        - [x] Use `Yaml` as format. 
        - [x] Make config hierarchy.
        - [ ] Implement YAML processing:
            - [x] Add YQ binary installation in setup scripts.
            - [ ] Create config parser using YQ.
            - [ ] Add config validation.
        - [ ] Allow customization, metadata input.
    
    - [x] Add support for packages.
        - [x] Add `kmp` command for managing package.
        - [x] Packages reside in /packages dir.
        - [ ] Allow changing package dir via config.
        - [x] Move existing modules to `utils` package.
        - [x] Advanced module import system via `__kimport` || `kit.import`:
            - [x] Auto-importing package `__init__.sh` files
            - [x] Track loaded modules in `K_LOADED_MODULES` array.
            - [x] Support for nested subpackages
            - [x] For single plugin module:     `packageName.moduleName`
            - [x] For all modules in a package: `packageName.*`
            - [x] For local module:             `.moduleName`
            - [x] For local modules in subdir:  `.subdir.moduleName`
            - [x] For all local modules:        `.*`
    
    - [ ] Write documentation [(help needed)](./contributing.md#how-to-help-writing-docs).
        - [x] Terms, Initialization, todo, faq.
        - [x] Config Options.
        - [ ] Methods:
            - [ ] Clean up TODOs and FIXMEs in module files
            - [ ] Document all module functions with consistent DocBlock format
            - [ ] Generate comprehensive API reference from DocBlocks


=== "Later in Time"

    - [x] Make `__kimport` adapt like python's import system. introduce namespacing.
      - [ ] Add support for relative imports (like Python's `from .. import x`)
      - [ ] Add import caching to prevent duplicate imports
    - [ ] Switch to [Docusaurus](https://docusaurus.io) for documentation
        - mkdocs is excellent but is limited in some areas. 
        - Docusaurus will be more flexibile.
    - [ ] Check if core functions & dependency functions are loaded and set that script load flag true using a variable.
    - [ ] Make use of log file in more functions (for more detailed logs).
    - [ ] Allow adding custom log levels.
    - [ ] Add more config options, make use of config file more.
    - [ ] Add `-q` or `--quiet` flag to all possible functions.
    - [ ] Enable completions (still thinking if useful):
        - Make script.
        - Source the file.
        - In install script: `printf "echo \"fpath+=(\"${k_dir}/completions\")\" >> \"${.zshrc}\""`
    - [ ] Check for internet connection: `ping -c 2 soymadip.github.com &>/dev/null`
    - [ ] Make Package registry in separate branch.
      - [ ] kpm will by default search package form here.
    - [ ] Make methods to parse method doc blocks.
