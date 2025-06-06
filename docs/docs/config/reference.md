---
title: Reference 
icon: octicons/sliders-24
description: "A detailed guide to all configuration options in KireiSakura-Kit."
---

<h1 align="center"><b>Configuration Options</b></h1>

This page details all available **configuration options** for KireiSakura-Kit.  

!!! info "Configuration follows YAML format."

    ```yaml
    # example config.yml

    Project:
      name: "KireiSakura-Kit"
      owner: soymadip

    Options:
        debug_mode: false
    ```

---

:fontawesome-solid-circle-info: **Below are options, grouped by section : -**

## :material-vector-intersection: ^^**Project**^^

### :material-shield-key: **name**

Specifies the name of your project.  

- **Type:** string
- **Optional:** ❌
- **Default:** `KireiSakura-Kit`

---

### :material-shield-key: **owner**

Name of the maintainer of current project.

- **Type:** string
- **Optional:** ❌
- **Default:** Null

---

### :material-shield-key: **module_dir**

Path of the directory that holds local modules, **relative to the project root.**

- **Type:** string/path
- **Optional:** ✅
- **Default:** `modules/`

---

### :material-shield-key: **config_file**

Name or path of the project config file.  

:octicons-arrow-right-16: **Name** if config file is in the project root.  
:octicons-arrow-right-16: **Path**, relative to project root if it's not in root.

- **Type:** String or path
- **Optional:** ✅
- **Default:** config.yml

??? example "Example"

    Let's suppose project name is `Dotfile Heaven`.

    1. Config file is in project root but only name is changed:-

        ```yaml
        Project:
            name: "Dotfile Heaven"
            config_file: "kirei.yml"
        ```
    2. Config file is in `config` subdirectory & is named `kirei.yml`. so:-

        ```yaml
        Project:
            name: "Dotfile Heaven"
            config_file: "config/kirei.yml"
        ```
---

### :material-shield-key: **repo_url**

Url of the current project's Repository/Website.

- **Type:** String/url
- **Optional:** ✅
- **Default:** Null

<br><!-- a glitch in mkdocs :-) -->
!!! quote ""

## :material-vector-intersection: ^^**Custom**^^

### :material-shield-key: **kit_dir**

Directory to use instead of default kit installation.

- **Type:** string/path
- **Optional:** ✅
- **Default:**`$XDG_DATA_HOME/<project_name>`

---

### :material-shield-key: **cache_dir**

Defines the directory path where temporary files will be stored.

- **Type:** string/path
- **Optional:** ✅
- **Default:**  
  - Primary: `$XDG_CONFIG_HOME/<project name>` (If `$XDG_CONFIG_HOME` is set)
  - Fallback: `~/.config/<project name>`

---

### :material-shield-key: **log_file_name**

Specifies the name of the log file.  

- **Type:** string
- **Optional:** ✅
- **Default:** `<project_name>.log`

---

### :material-shield-key: **installer_url**

Direct URL to the installer script. This is used for installing/updating kit.  

- **Type:** string/url
- **Optional:** ✅
- **Default:** `https://raw.githubusercontent.com/soymadip/KireiSakura-Kit/refs/heads/install/install.sh`

---

### :material-shield-key: **package_dir**

Directory to use to hold installed packages.

- **Type:** string/path
- **Optional:** ✅
- **Default:** `$k_kit_dir/packages`

<br><!-- a glitch in mkdocs :) -->
!!! quote ""

## :material-vector-intersection: ^^**Kit**^^

---

### :material-shield-key: **docs_url**

Url of the Kit's documentation website.

- **Type:** string/url
- **Optional:** ✅
- **Default:** <https://soymadip.github.io/KireiSakura-Kit>

---

### :material-shield-key: **custom_repo**

Direct link to kit's installer script.

- **Type:** string/url
- **Optional:** ✅
- **Default:** `https://raw.githubusercontent.com/soymadip/KireiSakura-Kit/refs/heads/install/install.sh`

---

### :material-shield-key: **upstream_ver_url**

Direct download link of the file that holds the version number.

- **Type:** string/url
- **Optional:** ✅
- **Default:** `https://raw.githubusercontent.com/soymadip/KireiSakura-Kit/main/.version`

<br><!-- a glitch in mkdocs :) -->
!!! quote ""

## :material-vector-intersection: ^^**Options**^^

### :material-shield-key: **auto_update**

Should the Kit update everytime it's run?

- **Type:** bool
- **Optional:** ✅
- **Default:** true

---

### :material-shield-key: **debug_mode**

Enable Debug mode.

:octicons-arrow-right-16: In this mode, extra messages are printed (helpful for debugging).  

- **Type:** bool
- **Optional:** ✅
- **Default:** false

---

### :material-shield-key: **quiet_mode**

Enable quiet mode.

:octicons-arrow-right-16: In this mode, most of the logs are suppressed & delays are removed.  

- **Type:** bool
- **Optional:** ✅
- **Default:** false

---

### :material-shield-key: **failsafe_mode**

Enable failsafe mode.  

:octicons-arrow-right-16: Exit (stop execution of) script in case of error.

- **Type:** bool
- **Optional:** ✅
- **Default:** false
