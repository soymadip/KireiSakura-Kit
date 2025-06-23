# Logging Module Changelog

## Changes in Latest Update (June 2025)

### Removed Features

- **Removed `extra_info` parameter**: The logging function no longer accepts a third parameter for extra information. This was done to simplify the API and ensure consistent logging styles throughout the framework.

### Modified Components

1. **Updated `__logger()` function**:
   - Removed the `extra_info` parameter
   - Simplified the code structure by merging conditional logic
   - Maintained all logging levels and formatting

2. **Updated References**:
   - Fixed all references in `kimport.sh` (both in `lib` and `core` directories)
   - Updated code in `utils.sh` to remove third parameter usage
   - Updated code in `kde.sh` to reformat message instead of using extra_info

3. **Documentation**:
   - Created comprehensive documentation in `docs/docs/api/logging.md`
   - Added examples, usage tables, and format information

### Benefits of Changes

- **Simpler API**: The logging system now has a more consistent and straightforward interface.
- **Cleaner Code**: The implementation is now more maintainable with fewer code paths.
- **Consistent Styling**: All log messages now follow the same visual pattern with bold colored symbols.
- **Better Documentation**: The logging module is now properly documented with examples and usage guidelines.

### Migration Guide

For any code that previously used the extra_info parameter, reformat your messages as follows:

```bash
# Old style:
log.warn "Message" "EXTRA_INFO"

# New style:
log.warn "EXTRA_INFO: Message"
```
