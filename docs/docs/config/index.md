---
title: Configuration
icon: fontawesome/solid/gear
---

<h1 align="center"><b>Configuration File</b></h1>

The configuration file allows users to customize/override default behaviour of the kit.


## **:simple-rocket: Quick Start**
- Create a file named `kconf.ini` in `.config/KireiSakura-Kit` directory &  
- Add following content : -

    ```bash
    # Name of the project
    project_name="Your Project Name"
    ```

## :fontawesome-solid-location-crosshairs: **Location of files**
- **Global : -** 
    1. `$XDG_CONFIG_HOME/kireiSakura-kit/config`  
    2. `.config/kireiSakura-kit/config`

- **Per Project : -** `<project_root>/config`


## **:material-arrow-up: Loading Process**

- The options set in config files overwrites their default values set in the Kit.  
- Options in Project config values overwrite global & default values.

```mermaid

graph TD
    B{{Is XDG_CONFIG_HOME env variable set?}}
    B -- Yes --> C[Use<br>XDG_CONFIG_HOME/KireiSakura-Kit/config]
    B -- No --> D[Use<br>$HOME/.config/KireiSakura-Kit/config]
    C --> E[Load global config values.<br>Overwriting default values.]
    D --> E
    E --> F{{'config' file present in current project root?}}
    F -- Yes --> G[Load project config values.<br>Overwrite global ones present in this.]
    F -- No --> H[Use global config values]
    G --> I[Use loaded config values]
    H --> I
```
