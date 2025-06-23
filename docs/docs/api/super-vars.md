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

    log.info $K_KIT_SITE

    ```

## **List of Super variables**

### 1. Project Information

- **`K_PRJ_NAME`**              → Name of the current project.
- **`K_PRJ_OWNER`**             → Owner/maintainer of the current project.
- **`K_PRJ_URL`**               → URL to the project's website.
- **`K_PRJ_REPO`**              → Project's repository (format: username/repo).
- **`K_PRJ_CONFIG`**            → Path to the project's configuration file.


### 2. Kit & Metadata

- **`K_KIT_NAME`**              → Name of the kit.
- **`K_KIT_OWNER`**             → Owner/maintainer of the kit.
- **`K_KIT_SITE`**              → URL to the kit's website.
- **`K_KIT_REPO`**              → GitHub repository of the kit (format: username/repo).
- **`K_KIT_BRANCH`**            → Production branch of the kit repository.
- **`K_KIT_INSTALLER_URL`**     → URL to the installer script.
- **`K_KIT_VERSION`**           → Version of the currently installed kit.
- **`K_KIT_UPSTREAM_VERSION`**  → Latest available version from upstream.
- **`K_KIT_VER_URL`**           → Path to the local version file.
- **`K_KIT_UPSTREAM_VER_URL`**  → URL to check for upstream version.


### 3. Library Directories

- **`K_KIT_DIR`**               → Root directory of KireiSakura-Kit.
- **`K_LIB_DIR`**               → Directory of KireiSakura-Kit core library.
- **`K_INIT_FILE`**             → Path to the main entry script.
- **`K_PACKAGE_DIR`**           → Directory containing packages.
- **`K_ASSETS_DIR`**            → Directory for assets like icons and themes.


### 4. Runtime & Logging

- **`K_DEBUG_MODE`**            → Runtime flag for enabling verbose debug output.
- **`K_CACHE_DIR`**             → Directory for caching temporary files.
- **`K_LOG_FILE`**              → Path to the log file for debugging and tracking.
- **`K_LOADED_MODULES`**        → _Array_ containing list of loaded modules.
