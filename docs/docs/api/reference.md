---
title: Methods Reference
icon: material/pickaxe
---

<h1 align="center"><b>Available Methods</b></h1>

# INI Parser Design (Following `configparser` Standards)

## Core Functionalities

### 1. Read INI Files
- **Command:** `ini.read <file>`
- Reads and parses an INI file into memory.
- Stores data in an associative array (`INI_DATA`) if called form another ini method. else store in a associative array as same name as the filename without the .ini extension.
- Parses `[parser]` section for flags (e.g., `raw_mode = true`).

### 2. Retrieve Values
- **Command:** `ini.get <file> <section.key> [--raw]`
- Supports:
  - **Variable expansion:** Expands `${key}` (same section) and `${section.key}` (cross-section).
  - **Recursive expansion:** Expands up to 5 levels deep. can be adjusted using `[parser] expansion_limit=N` option.
  - **Raw mode:**
    - `--raw` flag for per-query raw output.
    - `[parser] raw_mode = true` to set global raw mode.

### 3. Set Values
- **Command:** `ini.set <file> <section.key> <value>`
- Overwrites existing values.
- Creates a new key if not found.

---

## Additional Features

### Handling Environment Variables  
- No automatic expansion.
- Expansion can be enabled using `--env` or `[parser] expand_env = true`.

### Case Sensitivity  
- Default: **Case-insensitive** (like `configparser`).
- Configurable via `[parser] case_sensitive = true`.

### Defaults Section  
- `[DEFAULT]` values act as fallback for missing keys.

### Strict Key-Value Rules  
- By default, **keys without values** throw an error.
- `[parser] allow_empty_keys = true` allows empty values.

### Multi-line Support  
- Indented lines are treated as continuations.

### Duplicate Keys  
- Logs a warning but overwrites previous values.

### Inline Comments  
- Supports `key = value # comment`.

### Empty Sections  
- Allowed but logs a warning.



