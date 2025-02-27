---
# icon: material/puzzle
title: API
icon: material/api
---

<h1 align="center"><b>Using API</b></h1>

## **Overview**

KireiSakura-Kit provides a set of ways to interact with and leverage it's capabilities.
This documentation will guide you through the available methods and their usage.


## **Elements**

- [Super Variables](./super-vars.md)
- [Methods & Modules](./methods-modules.md)
- [Packages](./packages.md)
- [Loading Modules](./loading-modules.md)

<!--

## **Loading modules**

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
-->
