---
title: Configuration
icon: fontawesome/solid/gear
---

## Config file

Config file holds configuration options like project name etc. 
It's location should be `<project root>/config.sh`

---

Some variable(s) must be exported at the [[terminology#Config file|config file]] even before sourcing KireiSakura-Kit. 
It provides essential metadata that the kit uses during setup.

```bash title="config.sh"
# <project_root>/config.sh

# Required
export PROJECT_NAME="Project Name"

# Optional
export CACHE_DIR="/path/to/cache/dir"
export LOG_FILE_NAME="log_file_name"
```


### PROJECT_NAME
Specifies the name of your project.  
⚠️ *KireiSakura-Kit won't start without this one.*  

- **Default:** `NULL` (Kit will throw an error if not set.)


### CACHE_DIR *(Optional)*  
Defines the directory path where KireiSakura-Kit will store temporary files.  

- **Default:**  
    - If `$XDG_CONFIG_HOME` is set: `$XDG_CONFIG_HOME/<project name>`  
    - Otherwise: `~/.config/<project name>`

### LOG_FILE_NAME *(Optional)*  
Specifies the name of the log file. 
The log file will be created at:  `<CACHE_DIR>/<LOG_FILE_NAME>.log`

- **Default:** `<PROJECT_NAME>.log`


-------


