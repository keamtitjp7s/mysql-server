# Modular Plugin Architecture

This directory contains templates and documentation for building plugins that are easy to implement on other platforms or integrate into different structures.

## Template Plugin (`template_modular/`)

A minimal, clean plugin designed for:
- **MODULE_ONLY** builds (shared library, no server dependency)
- Cross-platform compatibility (Linux, macOS, Windows)
- Easy embedding into custom frameworks or embedded systems

### Quick Build

```bash
# Build with preset (includes components mode)
cmake --preset linux-components-only
cmake --build --preset linux-components-only

# Or use the user-friendly wrapper
./build.sh full --components
```

### Integration into Other Platforms

1. Copy `plugin/template_modular/` to your own repository.
2. Update `CMakeLists.txt` references.
3. Build with `MODULE_ONLY` so it produces `libtemplate_modular.so` (or `.dll`/`.dylib`).
4. Load dynamically or link statically into your platform.

### Plugin Types Supported

| Type | When to use |
|------|-------------|
| `MODULE_ONLY` | Shared library for embedding or external loading |
| `DEFAULT` | Built into mysqld by default |
| `STORAGE_ENGINE` | Storage engine plugins (`ha_*`) |
| `CLIENT_ONLY` | Client-side plugins |

### Architecture Improvements

- `CMakePresets.json` provides ready-to-use configurations for Linux, macOS, and Windows.
- `build.sh` provides named presets (`minimal`, `debug`, `release`, `full`) and `--components` for library-only builds.
- `plugin/template_modular/` provides a clean, minimal starting point.

## Cross-Platform CMake Presets

```bash
# Linux release
cmake --preset linux-release
cmake --build --preset linux-release

# Linux minimal (core only)
cmake --preset linux-minimal
cmake --build --preset linux-minimal

# MacOS release
cmake --preset macos-release
cmake --build --preset macos-release

# Windows (Visual Studio 2019)
cmake --preset windows-vs2019
cmake --build --preset windows-vs2019

# Components only (for embedding)
cmake --preset linux-components-only
cmake --build --preset linux-components-only
```

## Making Plugins More User-Friendly

Key changes made to improve usability:
1. **Simplified build wrapper** (`build.sh`) — single command with named presets.
2. **CMake presets** — no need to manually set `CMAKE_BUILD_TYPE`, generators, or flags.
3. **Template plugin** — minimal, well-documented code without server dependency.
4. **Simplified macro** (`MYSQL_ADD_SIMPLE_MODULE_PLUGIN`) for faster plugin development.

### Simplified Plugin Macro

For faster development, use the new `MYSQL_ADD_SIMPLE_MODULE_PLUGIN` macro in `cmake/plugin.cmake`:

```cmake
MYSQL_ADD_SIMPLE_MODULE_PLUGIN(my_plugin my_plugin.cc)
```

This automatically applies `MODULE_ONLY`, `VISIBILITY_HIDDEN`, and `NO_UNDEFINED`.
