---
title: Example config
icon: material/vector-difference-ab
---

```yaml

Project:
  name: Dotfiles 
  owner: rahul
  repo: rahul/Dotfiles
  url: https://dotfiles.rahul.me
  config_file: config.yml
  module_dir: modules

Custom:
  kit_dir: "${XDG_DATA_HOME:-$HOME/.local/share}/KireiSakura-Kit"
  cache_dir: "${XDG_CACHE_HOME:-$HOME/.cache}/KireiSakura-Kit"
  package_dir: 

Kit:
  repo: Rahul/KireiSakura-Kit
  branch: main

Options:
  auto_update:
  debug_mode:
  silent_mode:
  falisafe_mode: 

```

```bash

# Declare Config variables

project_name="${configs[project_name]}"
project_owner="${configs[project_owner]}"
project_config_file="${configs[project_config_file]}"
local_module_dir="${configs[local_module_dir]}"
project_repo="${configs[project_repo]}"

upstream_ver_url="${configs[upstream_ver_url]}"
installer_url="${configs[installer_url]}"
docs_url="${configs[docs_url]}"

kit_dir="${configs[kit_dir]}"
core_dir="${configs[core_dir]}"
loader_path="${configs[loader_path]}"
package_dir="${configs[package_dir]}"
assets_dir="${configs[assets_dir]}"
kit_verison="${configs[kit_verison]}"

cache_dir="${configs[cache_dir]}"
log_file_name="${configs[log_file_name]}"
log_file="$cache_dir/$log_file_name"

```
