---
title: Loading Modules
icon: material/import
---

<h1 align="center"><b>Loading Modules</b></h1>

By default, KireiSakura Kit only imports [core modules](./methods-modules.md#__tabbed_1_1).  

Modules are imported using the `kimport` method.


## **Import Plugin Modules**

To import [plugin modules](./methods-modules.md#__tabbed_1_2):

```bash
# Import specific modules of a package
kimport packageName.moduleName
kimport utils.disk utils.shell

# Import all modules of a package (in development)
kimport packageName.*
kimport utils.*
```

## **Import Local Modules**

To import [local modules](./methods-modules.md#__tabbed_1_3):

```bash
# import local modules
kimport ModuleName
kimport module1 module2 module3

# Import all local modules (in development)
kimport *
```
<!-- 
!!! info "Module Naming Conventions"
    Plugin module methods should be named with the format `packageName.methodName` to avoid naming conflicts.
    
    For example:
    ```bash
    # Method from the 'utils.disk' module
    disk.free-space

    # Method from the 'utils.font' module
    font.list
    ``` -->
