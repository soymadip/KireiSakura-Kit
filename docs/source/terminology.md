---
title: 1. Terminologies
forVersion: 0.6.5
icon: book-a
---
<h1 align="center">Temninology</h1>
<br><p align="center">1st, let's understand some terms used throughout the Docs.</p>

<br>

## Config file

Config file holds configuration options like project name etc. 
It's location should be `<project root>/config.sh`

---
## Methods
**Methods** are the functions exposed by [[terminology#Modules|Modules.]] 
They are the primary API for interacting with KireiSakura-Kit.


---
## Modules
 **Modules** are shell scripts that store methods. Each module performs a specific task and can be sourced as needed.
 
 There are 3 types are modules: -
### 1. Core modules
These are essential components of the KireiSakura-Kit providing the foundational functionality required for the framework to operate. 

These are automatically loaded at start. 
 
### 2. Plugin modules
These are optional modules used to extend the functionality of the framework.

These are required to be [[init#3. Loading modules|loaded]] explicitly using `kimport` method.

### 3. Local modules
These are similar to [[terminology#2. Plugin modules|plugin modules]] except these are designed  & implemented by the user.

>[!danger] Info
>**Create local modules** by making a directory called `modules` in the project root.
>```sh
><PROJECT_ROOT>
>   |-main.sh
>   |-modules/
>       |
>       |-module1.sh
>       |-module2.sh
>```


---

## Packages


Packages are directories containing [[terminology#2. Package modules|package modules]]. 

There are inbuilt packages as well as external packages that can be installed with [[packages#kpm|KireiSakura Package Manger]].

- More on the package in [[packages]] page.
---
## Super Variables

KireiSakura-Kit defines several key environment variables, known as **Super Variables**, which store important paths and project-related information. 
__Super Variables__ start with `kirei_`. 


Currently there are below super vars: - 
### Project & Metadata
- **`kirei_docs_url`**         → URL to the official documentation.  
- **`kirei_project_name`** → Name of the project.  

### Core Directories
- **`kirei_dir`**                 → Root directory of KireiSakura-Kit.  
- **`kirei_core_dir`**      → Directory containing core scripts.  
- **`kirei_core`**               → Path to the main entry script.  
- **`kirei_module_dir`**  → Directory containing additional modules.  
- **`kirei_assets_dir`**  → Directory for assets like icons and themes.  

### Runtime & Logging
- **`kirei_cache_dir`** → Directory for caching temporary files.  
- **`kirei_log_file`**    → Path to the log file for debugging and tracking.  
- **`kirei_loaded_modules`**    → Array containing list of loaded modules.  



---

>[!success] Done
> Now that you know  the terms, head to [[init#^6c74f6|Initialization]] to start sourcing Kit.
