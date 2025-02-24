---
title: Loading Modules
icon: material/import
---

<h1 align="center"><b>Loading Modules</b></h1>

By default, KireiSakura Kit only imports [core modules](./terminology.md#1-core-modules).

Modules are imported using the `kimport` method.

## **Import Plugin Modules**

To import [plugin modules](./terminology.md#2-plugin-modules):

```bash
# import specific modules of a package.
kimport packageName.ModuleName
kimport utils.disk utils.shell

# import all modules of a package
kimport PackageName
kimport utils
```

## **Import Local Modules**

To import [local modules](./terminology.md#3-local-modules) use the `-l` flag:

```bash 
# import local modules
kimport .ModuleName
kimport .module1 .module2 .module3

# import all local modules
kimport .
```
