---
title: Methods & Modules
icon: material/puzzle
---

<h1 align="center"><b>Methods & Modules</b></h1>

## **1. Methods**

**Methods** are the functions exposed by [Modules.](#modules) 

They are the primary API for interacting with KireiSakura-Kit.

---

## **2. Modules**

**Modules** are shell scripts that store methods. Each module performs a specific task and can be sourced as needed.

#### There are 3 types are modules : -

=== "Core Modules"

    These are essential components of the KireiSakura-Kit providing the foundational functionality required for the framework to operate. 

    These are automatically loaded at start & listed in [loaded modules](./super-vars.md#3-runtime--logging).


=== "Plugin Modules"

    Plugin modules are optional modules, used to extend the functionality of the framework.  
    Plugin modules are usually contained in packages and are dependent on [core modules](#__tabbed_1_1).

    !!! info
        These are required to be [loaded](./loading-modules.md#import-plugin-modules) explicitly using [`kimport`](#).


=== "Local Modules"

    These are similar to [plugin modules](#__tabbed_1_2) except these are designed & implemented by the user.
    Local modules gives users to write their own modules by using core modules & plugin modules.

    !!! info "**Create local modules** by making a directory called `modules` in the project root."

        ```sh
        <PROJECT_ROOT>
        |-main.sh
        |-modules/
            |
            |-module1.sh
            |-module2.sh
        ```

