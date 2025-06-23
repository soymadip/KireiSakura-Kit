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

**:fontawesome-solid-circle-info: There are 3 types of modules:**

=== ":simple-securityscorecard: Library Modules"

    These are essential components of KireiSakura-Kit, providing foundational functionality.

    **These are :-**

    - Automatically loaded at startup
    - Cannot be modified or removed
    - Listed in `K_LOADED_MODULES` variable


=== ":material-power-plug-outline: Plugin Modules"

    Plugin modules extend the functionality of the framework.  

    **These are :-**

    - Optional & must be loaded manually  
    - Can depend on library modules
    - Organized in [packages](./packages.md)

    **How to Import:**

    ```bash
    # Import specific modules
    pkg.import packageName.moduleName
    pkg.import utils.disk utils.shell

    # Import all modules in a package
    pkg.import packageName.*
    pkg.import utils.*

    # Import from subpackages
    pkg.import packageName.subPackage.moduleName
    pkg.import utils.network.wifi

    # Import all modules from a subpackage
    pkg.import packageName.subPackage.*
    pkg.import utils.network.*
    ```

    **Import Behavior:**

    When importing with wildcards (`*`), the system will:

    1. Source the package's `__init__.sh` file if it exists
    2. Import all modules in the specified directory (excluding `__init__.sh`)
    3. Import modules from subdirectories under the specified package path

    For more details on available packages, see [Packages](./packages.md).

=== ":material-folder-open: Local Modules"

    Local modules allow users to write their own extensions within a project.  

    **These are :-**

    - Project-specific modules
    - Can use library & plugin modules
    - Keep main [entry script](../init.md#1-mainsh) clean by separating functionality

    **Directory Structure:**

    Create a `modules` directory in your project root:

    ```
    <PROJECT_ROOT>/
    └── modules/
        ├── module1.sh
        ├── module2.sh
        └── subdir/           # Optional subdirectories
            ├── module3.sh
            └── module4.sh
    ```

    **How to Import:**
    ```bash
    # Import specific local modules
    pkg.import .moduleName
    pkg.import .module1 .module2 .module3
    
    # Import modules from subdirectories
    pkg.import .subdir.moduleName
    pkg.import .utils.network .utils.system
    
    # Import all local modules at once (including subdirectories)
    pkg.import .*
    ```

!!! quote ""

<br>

## **Best Practices**

- **Group related imports** by package:
  ```bash
  pkg.import utils.disk utils.shell utils.archive
  ```

- **Use wildcards** for complete packages:
  ```bash
  pkg.import utils.*
  ```

- **Organize complex projects** with subdirectories:
  ```bash
  pkg.import .ui.dialog .ui.form
  ```

- For **small scripts**, import only what you need:
  ```bash
  pkg.import utils.disk
  ```
