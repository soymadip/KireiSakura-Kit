---
title: Initialization
icon: material/rocket-launch
---
<h1 align="center"><b>Initialization</b></h1>

## Installing Kit

!!! info "Prerequisites"
    - Make sure you have `curl`, `grep`  installed.
    - Install `figlet` too for the header. (optional)

There are two ways to Install & source the kit :-

=== "Install & Source directly within script"

    This option :-
 
    - Installs & sources the kit in your script.
    - Suitable for auto checking, installing & source the kit. (ex. in a dotfiles install script)

    ```bash title="Add these lines at top of your script"
    if command -v kireisakura &> /dev/null; then
      eval "$(kireisakura --init)"
    else
      clear -x && echo
      echo "> Downloading KireiSakura-Kit"
      curl -sSL https://raw.githubusercontent.com/soymadip/KireiSakura-Kit/refs/heads/install/install.sh -o kirestaller.sh
      bash kirestaller.sh -ds
    fi
    ```
=== "Only install in System"

    This option :-

    - Installs the kit in your system **but Doesn't source kit if executed inside a script**.
    - Suitable if only needed to install.

    ```bash title="Run this in terminal"
    curl -L https://raw.githubusercontent.com/soymadip/KireiSakura-Kit/refs/heads/install/install.sh | bash -s
    ```

---

## Loading modules

By default KireiSakura Kit only imports [core modules](./terminology.md#1-core-modules).

Modules are imported using `kimport` method.

- To import [plugin modules](./terminology.md#2-plugin-modules):-
```bash
# import specific modules of a package.
kimport packageName.ModuleName
kimport utils.disk utils.shell

# import all modules of a package
kimport PackageName.
kimport utils.
```

- To import [local modules](./terminology.md#3-local-modules) use `-l` flag:-
```bash 
# import local modules
kimport .ModuleName
kimport .module1 .module2 .module3

# import all local modules
kimport .
```
