---
title: Configuration
icon: fontawesome/solid/gear
---

<h1 align="center"><b>Config file</b></h1>

📌 **Location:** `<project_root>/config.sh`  

The config file stores essential options, such as the project name and other settings used by KireiSakura-Kit.



Configuration is done by exporting variables.

```bash title="Example config.sh"
# <project_root>/config.sh


export PROJECT_NAME="Project Name" # Set Project name
export CACHE_DIR="/path/to/cache/dir" # Set Cache dir location
export LOG_FILE_NAME="log_file_name" # Set log file name
```

---

## **Available Config options**

###

### ==`PROJECT_NAME`==

- **Desc**: Specifies the name of your project.
- **Type**: string
- **Optional**: yes
- **Default**: `KireiSakura-Kit`


---

### ==`CACHE_DIR`==

- **Desc**: Defines the directory path where KireiSakura-Kit will store temporary files.
- **Type**: string
- **Optional**: yes
- **Default**:
    - If `$XDG_CONFIG_HOME` is set: `$XDG_CONFIG_HOME/<project name>`  
    - Else: `~/.config/<project name>`

---

### ==`LOG_FILE_NAME`==  

- **Desc**: Specifies the name of the log file.
- **Type**: string
- **Location**: CACHE_DIR/
- **Optional**: yes
- **Default**: `<PROJECT_NAME>.log`

---

### ==`DEBUG_MODE`==  

- **Desc**: Enable Debug mode. In this mode, kit prints extra messages helpful for debugging.
- **Type**: bool
- **Optional**: yes
- **Default**: false

---



