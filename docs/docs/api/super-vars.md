---
title: Super Variables
icon: material/variable
---

<h1 align="center"><b>Super Variables</b></h1>

- KireiSakura-Kit defines several environment variables, known as **Super Variables**, which store important kit & project related information.  
- These variables can be accessed like other variables to get many useful values.

!!! example "Example"
    
    ```bash
    # Print value of Kit's official site url
    log.info $k_kit_site

    ```

## **List of Super variables**

### 1. Project Information
- **`k_prj_name`**              → Name of the current project.
- **`k_prj_owner`**             → Owner/maintainer of the current project.
- **`k_prj_url`**               → URL to the project's website.
- **`k_prj_repo`**              → Project's repository (format: username/repo).
- **`k_prj_config`**            → Path to the project's configuration file.

### 2. Kit & Metadata
- **`k_kit_name`**              → Name of the kit.
- **`k_kit_owner`**             → Owner/maintainer of the kit.
- **`k_kit_site`**              → URL to the kit's website.
- **`k_kit_repo`**              → GitHub repository of the kit (format: username/repo).
- **`k_kit_branch`**            → Production branch of the kit repository.
- **`k_kit_installer_url`**     → URL to the installer script.
- **`k_kit_version`**           → Version of the currently installed kit.
- **`k_kit_upstream_version`**  → Latest available version from upstream.
- **`k_kit_ver_url`**           → Path to the local version file.
- **`k_kit_upstream_ver_url`**  → URL to check for upstream version.

### 3. Core Directories
- **`k_kit_dir`**               → Root directory of KireiSakura-Kit.
- **`k_core_dir`**              → Directory containing core scripts.
- **`k_loader`**                → Path to the main entry script.
- **`k_package_dir`**           → Directory containing packages.
- **`k_assets_dir`**            → Directory for assets like icons and themes.

### 4. Runtime & Logging
- **`k_cache_dir`**             → Directory for caching temporary files.
- **`k_log_file`**              → Path to the log file for debugging and tracking.
- **`k_loaded_modules`**        → _Array_ containing list of loaded modules.

---

