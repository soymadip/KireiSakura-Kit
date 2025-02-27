---
title: Overrides
icon: octicons/sliders-24
---

<h1 align="center"><b>Available Overrides</b></h1>

## **List of Available Overrides**

### ==`project_name`==

Specifies the name of your project.  

- **Type**: string
- **Optional**: No 
- **Default**: `KireiSakura-Kit`

---

### ==`custom_kit_dir`==

Directory to use instead of default kit installation.

- **Type**: string/path
- **Optional**: Yes
- **Default**:`$XDG_DATA_HOME/<project_name>`

---

### ==`cache_dir`==

Defines the directory path where KireiSakura-Kit will store temporary files.

- **Type**: string/path
- **Optional**: yes
- **Default**:
    - If `$XDG_CONFIG_HOME` is set: `$XDG_CONFIG_HOME/<project name>`  **Desc**: 
    - Else: `~/.config/<project name>`

---

### ==`log_file_name`==  

Specifies the name of the log file.  

- **Type**: string
- **Location**: cache_dir/
- **Optional**: yes
- **Default**: `<project_name>.log`

---

### ==`debug_mode`==  

Enable Debug mode. In this mode, extra messages are printed (helpful for debugging).  

- **Type**: bool
- **Optional**: yes
- **Default**: false

---

### ==`installer_url`==  

Direct URL to the installer script. This is used for installing/updating kit.  

- **Type**: string/url
- **Optional**: yes
- **Default**: `https://raw.githubusercontent.com/soymadip/KireiSakura-Kit/refs/heads/install/install.sh`

---

### ==`local_modules_dir`==

Path of the directory that holds local modules, **relative to the project root.**

- **Type**: string/path
- **Optional**: Yes
- **Default**: modules/


