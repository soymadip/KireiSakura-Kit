---
title: Packages
icon: octicons/package-16
---


<h1 align="center"><b> Packages</b></h1>

!!! warning "Be carefull"
    <center><big>Packages are not yet fully implemented. They need more work.</big></center>

Packages are directories containing [plugin modules](./methods-modules.md#__tabbed_1_2).


Packages allow to group related plugin modules & enable easily sharing plugin modules as installable pack.

## **Structure of package**

```bash
<PACKAGE_ROOT | PACKAGE_NAME>
    |
    |-module1.sh
    |-module2.sh
    |-mosule3.sh
```

- The package dir name should be of desired name for the package. 
- Version detection & updating will be added later.

---
## **Import package & modules**

To use a package, import modules of that package, we need to use `kimport` function.

- Like this: -

```bash
kimport package1.module2   # import module2 from packge1
kimport package1           # import all modules from packge1

kimport .module3           # import LOCAL module: module3 
kimport .                  # import all local mosules.
```

!!! info
    - The local modules directory, `modules` is also considered as a package named `local` but is not necessary to mention the package name. 
    - `.module_name` is actually interprited as `local.module_name`.

---
## **Install a package**

To install a package, we use `kpm` or KireiSakura Package Manager.

```bash
kpm install <git_username>/<package_name>
```

- By default, kpm assumes the package is at github 
- So the above is expressed as  `<git_username>/<package_name>@github.com` -> `https://github.com/<git_username>/<package_name>`
- To install from other sources: - 

```bash
kpm install <git_username>/<package_name>@domain_name

# to install a packge from gitlab:
kpm install <git_username>/<package_name>@gitlab.com
```

--- 
## **List all packages**
To list all installed packages, 

```bash
kpm list
```

---
## **Update packages**

To update all packages use: -

```bash
kpm update
```

---
## **Uninstall package**

To uninstall a package use: -
```
kpm remove <package_name>
```

Or to uninstall all packages: -
```bash
kpm remove all
```

---
