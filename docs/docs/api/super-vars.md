---
title: Super Variables
icon: material/variable
---

<h1 align="center"><b>Super Variables</b></h1>

- KireiSakura-Kit defines several key environment variables, known as **Super Variables**, which store important paths and project-related information.  
- These variables can be used like other variables to get many useful values.

!!! example "Here is an example of getting values of Super Variables"
    
    ```bash
    # Print a value of a Super Variable (here, Documentation site url)
    log.info $Kirei_docs_url

    # make a temporary directory in cache dir
    mkdir $kirei_cache_dir/temparary_dir

    ```

## **List of Super variables**

### 1. Project & Metadata
- **`kirei_docs_url`**         → URL to the official documentation.  
- **`kirei_project_name`**     → Name of the project.  
- **`kirei_kit_version`**      → Version of the currently installed kit.  

### 2. Core Directories
- **`kirei_dir`**              → Root directory of KireiSakura-Kit.  
- **`kirei_core_dir`**         → Directory containing core scripts.  
- **`kirei_loader`**           → Path to the main entry script.  
- **`kirei_module_dir`**       → Directory containing additional modules.  
- **`kirei_assets_dir`**       → Directory for assets like icons and themes.  

### 3. Runtime & Logging
- **`kirei_cache_dir`**        → Directory for caching temporary files.  
- **`kirei_log_file`**         → Path to the log file for debugging and tracking.  
- **`kirei_loaded_modules`**   → _Array_ containing list of loaded modules.  



---

