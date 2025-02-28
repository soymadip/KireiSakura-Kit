---
title: Methods & Modules
icon: material/puzzle
---

<h1 align="center"><b>Methods & Modules</b></h1>

## :material-pound-box-outline: **Methods**

**Methods** are the functions exposed by [Modules.](#modules) 

They are the primary API for interacting with KireiSakura-Kit.

---

## :material-puzzle: **Modules**

**Modules** are shell scripts that store methods.  
Each module performs a specific task and can be sourced as needed.

**There are 3 types are modules : -**

=== ":simple-securityscorecard: Core Modules"

    These are essential components of KireiSakura-Kit, providing foundational functionality.

      - Automatically loaded at startup.
      - Cannot be modified or removed.
      - Listed in [loaded modules](#).

=== ":material-power-plug-outline: Plugin Modules"

    Extend the functionality of the framework.  

    - These are optional & must be loaded manually.  
    - Can be dependent on core modules.
    - Contained in packages. See [packages](./packages.md).


=== ":material-folder-open: Local Modules"

    Local modules allow users to write their own extensions within a project.  

    - These work similarly to plugin modules but are project specific.
    - Core & plugin modules can be used to make these.
    - This makes main [entry script](../init.md#1-mainsh) clean, separating methods.

    !!! info "**Create local modules** by making a sub directory called `modules` within project root."

        ```sh
        <PROJECT_ROOT>
        |
        |-modules/
            |
            |-module1.sh
            |-module2.sh
        ```
