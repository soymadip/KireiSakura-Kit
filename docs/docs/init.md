---
title: Initialization
icon: material/rocket-launch
---
<h1 align="center"><b>Initialization</b></h1>


## **Directory Structure**

!!! info "About this.."
    - The default structure is intended (& recomended) to provide a great starting point & is followed by documentation.  
    - **Except modules dir**, you are free to organize your project however you like.

```markdown
Project-Root-Dir
│
├── main.sh
├── src/
│   └── packages.sh
└── modules/
    ├── Module1.sh
    └── Module2.sh
```

### **1. `main.sh`**

- **Location:** Project Root
- **Desc:**  
    - This is entry point of the project.  
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

### **2. `modules` dir**

- **Location:** Project Root
- **Desc:**  This directory holds [local modules](./api/methods-modules.md#__tabbed_1_3). This directory is interpreted as `local` package within the kit.


### **3. `src` dir**

- **Location:** Project Root
- **Desc:**  
    - This directory is intended to hold source files and scripts that are part of your project.
    - You can organize your source files in this directory as per your project requirements.

??? example "Example src/packages.sh"

    ```bash
    #!/bin/bash

    # Example function in packages.sh
    install_package() {
      local package_name="$1"
      echo "Installing package: $package_name"
      # Add package installation logic here
    }

    # Call the function with a package name
    install_package "example-package"
    ```

---

## **Install & source Kit**

!!! abstract "Before everything"
    - Make sure you have `curl`, `grep`  installed.
    - Optionally `figlet` too for the header.

#### There are two ways to Install & source the kit : -

=== "Install & Source directly within script"

    - Just execute your entry script, initialization will be done automatically.
    - Suitable for portable scripts. (ex. in a dotfiles install script)

    ```bash title="Add these lines at top of your script"
    if command -v kireisakura &> /dev/null; then
      eval "$(kireisakura --init)"
    else
      clear -x
      printf "\n> Downloading KireiSakura-Kit\n"
      curl -sSL https://raw.githubusercontent.com/soymadip/KireiSakura-Kit/refs/heads/install/install.sh | bash -s -ds
    fi
    ```
=== "Only install in System"

    - Installs the kit in your system **but Doesn't source kit even if executed inside a script**.
    - Suitable if only needed to install.

    ```bash title="Run this in terminal"
    curl -L https://raw.githubusercontent.com/soymadip/KireiSakura-Kit/refs/heads/install/install.sh | bash -s
    ```
