---
title: Configuration
icon: fontawesome/solid/gear
---

<h1 align="center"><b>Configuration File</b></h1>

You can **customize** or **override** the default behavior of KireiSakura-Kit using configuration files.

The configuration is done in YAML format.


!!! warning 
    Config System is not yet implemented.

## :fontawesome-solid-location-crosshairs: **Configuration Files**

KireiSakura-Kit supports two levels of configuration : -

=== ":material-earth: **Global**"

    - **Applies to all projects**, overriding default settings.
    - **Primary Location:** `$XDG_CONFIG_HOME/kireisakura-kit/config.toml`
    - **Fallback Location:** `~/.config/kireisakura-kit/config.toml` _(used if `$XDG_CONFIG_HOME` is not set)_

=== ":material-folder: **Project Specific**"

    - **Applies only to the current project.**
    - **Has the highest priority**, overriding both default & global settings.
    - **Location:** `<project_root>/config.toml`

    ??? info "This config file's name can be changed!"

        **What if we want to change the project config file's name?**  

        - You can set a custom name using the **global config option:** `project_config_name`.


---

## :material-sort-numeric-ascending: **Loading Process**

- The options set in config file overwrites their default values set by the Kit.  
- Options in Project config file overwrite global & default values.

```mermaid

graph TD
    B{{Is XDG_CONFIG_HOME env variable set?}}
    B -- Yes --> C[Use<br>XDG_CONFIG_HOME/KireiSakura-Kit/config.toml]
    B -- No --> D[Use<br>$HOME/.config/KireiSakura-Kit/config.toml]
    C --> E[Load global config values.<br>Overwriting default values.]
    D --> E
    E --> F{{'config.toml' file present in current project root?}}
    F -- Yes --> G[Load project config values.<br>Overwrite global ones present in this.]
    F -- No --> H[Use global config values]
    G --> I[Use loaded config values]
    H --> I
```
