---
title: 2. Initialization
forVersion: 0.6.5
icon: rocket
---
<h1 align="center">Initialization</a>
<br><br>

>[!warning]
> Although Kit is stable enough now
> - **Things are subject to change** as this *project is in alpha* stage .
> - Major changes are being made until stable release.

^6c74f6

<br><br>

## 1. Metadata Initialization

```bash
# Required
export PROJECT_NAME="Project Name"

# Optional
export CACHE_DIR="/path/to/cache/dir"
export LOG_FILE_NAME="log_file_name"
```


Some variable(s) must be exported *at the very top of your script,* even before sourcing KireiSakura-Kit. 
It provides essential metadata that the kit uses during setup.

### Variables:-

#### `PROJECT_NAME`
Specifies the name of your project.  
⚠️ *KireiSakura-Kit won't start without this one.*  

- **Default:** `NULL` (Kit will throw an error if not set.)

<br>

#### `CACHE_DIR` *(Optional)*  
Defines the directory path where KireiSakura-Kit will store temporary files.  

- **Default:**  
    - If `$XDG_CONFIG_HOME` is set: `$XDG_CONFIG_HOME/<project name>`  
    - Otherwise: `~/.config/<project name>`

<br>

#### `LOG_FILE_NAME` *(Optional)*  
Specifies the name of the log file. 
The log file will be created at:  `<CACHE_DIR>/<LOG_FILE_NAME>.log`

- **Default:** `<PROJECT_NAME>.log`

<br>

-------


## 2. Sourcing Kit

>[!todo] Prerequisites
>- Make sure you have `curl`, `grep`  installed.
> - `figlet` will be installed later for header. you can install it now too.

Add below lines to your script.
This will check if KireiSakura Kit is installed or download & source the kit:-

```bash
if command -v kireisakura &> /dev/null; then
  eval "$(kireisakura --init)"
else
  clear -x && echo
  echo "> Downloading KireiSakura-Kit"
  curl -sSL https://raw.githubusercontent.com/soymadip/KireiSakura-Kit/refs/heads/install/install.sh -o kirestaller.sh
  bash kirestaller.sh -ds
fi
```

> [!info]-  you can also only install KireiSakura Kit in your system
> Run this command in your terminal:-
>```bash
>curl -L https://raw.githubusercontent.com/soymadip/KireiSakura-Kit/refs/heads/install/install.sh | bash -s
>```

---

## 3. Loading modules

By default KireiSakura Kit only imports core modules.

Modules are imported using `kimport` method.

- To import [[terminology#2. Plugin modules|plugin modules]]:-
```bash
#import specific modules
kimport disk-utils change-shell enable-os-prober

#import all modules at once
kimport -a
```

- To import [[terminology#3. User modules|user modules]] use `-l` flag:-
```bash 
kimport -l module1 module2 module3

#to import all modules
kimport -l -a
```


---

>[!success] Done
> Now that Initialization is complete, you can use [[methods]] to build script.

