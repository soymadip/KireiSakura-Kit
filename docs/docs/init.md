---
title: Initialization
icon: material/rocket-launch
description: Set up a project, install KireiSakura-Kit, and create config file.
---
<h1 align="center"><b>Initialization</b></h1>

In this page, you'll learn,

- Recommended Folder structure of a project.
- How to install and source the Kit
- Creating basic configuration file


## :material-file-tree: **Directory Structure**

!!! info "About this.."
    - The default structure is intended (& recommended) to provide a clean structure & follo
    - wed by documentation.  
    - **Except modules dir, config file**, you are free to organize your project however you like.[^*]

```markdown
Project Root
│
├── main.sh
├── config.yml 
├── src/
│   └── packages.sh
└── modules/
    ├── Module1.sh
    └── Module2.sh
```

### **1. `main.sh`**

- **Location:** Project Root
- **Desc:**  
  - This is *entry point* of the project.  
  - This file holds all steps. initializing kit, importing modules, using methods, is done in this method.

??? example "Example main.sh"

    ```bash
    #!/bin/bash

    # Init Kit
    eval "$(kireisakura -i)"

    # Import modules
    kimport utils.os utils.font

    # list all installed fonts & find one
    font.list | grep "jetbrains"

    # Rest of the script

    ```

---

### **2. `config.yml`**

- **Location:** Project Root
- **Desc:**  
  - This file holds configuration for your project.
  - It allows you to customize the behavior of the Kit in your project.
  - See [configuration reference](./config/reference.md) for details.

---

### **3. `modules` dir**

- **Location:** Project Root
- **Desc:**  This directory holds [local modules](./api/methods-modules.md#__tabbed_1_3). This directory is interpreted as `local` package within the kit.

---

### **4. `src` dir**

- **Location:** Project Root
- **Desc:** This directory is intended to hold resource files that are part of your project.

??? example "Example src/packages.sh"

    === "packages.sh"

        ```bash
        cli_packages=(
            "yazi"
            "eza"
            "htop"
        )

        gui_packages=(
            "zen-browser"
            "code-oss"
            "mpv"
            "redshift"
        )
        ```

    === "main.sh"

        ```bash
        #!/bin/env bash
        source src/packages.sh

        install-package cli_packages gui_packages
        ```

<br>
!!! quote ""

## :material-import: **Installation & source Kit**

!!! abstract "Before everything"
    - Make sure you have `curl`, `grep` installed.
    - Optionally `figlet` too for the header.

**ℹ️ There are two ways to Install & source the kit** : -

=== "Install & Source directly within script"

    - This one is recommended.
    - Just execute your entry script, initialization will be done automatically.
    - Suitable for portable scripts. (ex. in a dotfiles install script)

    ```bash title="Add these lines at top of your script"
    #!/bin/env bash

    if command -v kireisakura &> /dev/null; then
      eval "$(kireisakura --init)"
    else
      clear -x
      printf "\n> Downloading KireiSakura-Kit\n"
      curl -sSL https://kireisakura.soymadip.me/install | bash -s -ds
    fi
    ```
=== "Only install in System"

    - Installs the kit in your system **but Doesn't source kit even if executed inside a script**.
    - Suitable if only needed to install.

    ```bash title="Run this in terminal"
    curl -L https://kireisakura.soymadip.me/install | bash -s
    ```

<br>
!!! quote ""

## :fontawesome-solid-gear: **Create config file**

Create a file called `config.yml` in your project root.

Add below lines with proper values : -

```yaml

Project:
    name: "Your project name"
    owner: "your name"
```

[^*]: These can be customized too. See [configuration reference](./config/reference.md).
