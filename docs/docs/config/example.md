---
title: Example config
icon: material/vector-difference-ab
---

```yaml

Project:
  name: KireiSakura-Kit  #project name
  owner: soymadip
  config_file: kconf.yml
  module_dir: modules
  repo_url: https://github.com/soymadip/KireiSakura-Kit

Custom:
  kit_dir: "${XDG_DATA_HOME:-$HOME/.local/share}/KireiSakura-Kit"
  cache_dir: "${XDG_CACHE_HOME:-$HOME/.cache}/KireiSakura-Kit"
  log_file_name: "${custom.cache_dir}/KireiSakura-Kit.log"
  package_dir: 

Kit:
  installer_url:
  docs_url:
  latest_version_url: 

Options:
  auto_update:
  debug_mode:
  silent_mode:
  falisafe_mode: 

```
