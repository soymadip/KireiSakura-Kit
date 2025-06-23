---
title: Logging
icon: simple/googledocs
description: "Overview of KireiSakura-Kit's logging functionality, example usage."
---

# Logging Module

KireiSakura-Kit provides a powerful logging system that allows you to display formatted messages with different severity levels and automatically logs them to a file.

## Features

- **Multiple log levels** (info, success, warning, error)
- **Colorized output** with bold Unicode symbols for better readability
- **Automatic log file** generation for permanent record
- **Consistent formatting** across the entire framework

## Usage

The logging module provides several aliases for easy use:

| Alias | Description |
|-------|-------------|
| `log` | General informational message |
| `log.info` | Informational message |
| `log.success` | Success message (task completed) |
| `log.warn` | Warning message (potential issue) |
| `log.error` | Error message (operation failed) |
| `log.nyi` | "Not Yet Implemented" error message |

## Examples

```bash
# Simple informational message
log "This is a general information message"
log.info "This is an information message"

# Success message
log.success "Operation completed successfully"

# Warning message
log.warn "This action may cause problems"

# Error message
log.error "Failed to perform the operation"

# Not yet implemented
log.nyi
```

## Log Format

Each log message is displayed in the terminal with:

- A colored unicode symbol indicating the log level
- The message text in a color corresponding to its severity

Additionally, all messages are logged to the log file (`$K_LOG_FILE`) in the format:
```
[YYYY.MM.DD HH:MM:SS] [log_level] message
```

## Log Levels and Symbols

| Level | Symbol | Color | Usage |
|-------|--------|-------|-------|
| info | ℹ | Lavender | General information |
| success | ✓ | Green | Successful operations |
| warn | ⚠ | Yellow | Warnings or important notes |
| error | ✗ | Red | Errors or failures |
| default | ➤ | Blue | Default fallback |
