# User-Friendly Build & Integration Guide

## Quick Start

This wrapper (`build.sh`) makes mysql-server easier to build and embed across platforms and structures.

```bash
# Full release build
./build.sh full

# Minimal core server (fast, small footprint)
./build.sh minimal

# Debug build with assertions
./build.sh debug

# Only modular libraries (for embedding in other platforms)
./build.sh full --components
```

## Cross-Platform Support

- Linux (GNU/Linux): `nproc` for parallel jobs
- macOS: `sysctl -n hw.ncpu` for parallel jobs
- Windows: Use `cmake --build` directly; script detects CMake version

## Embedding / Modular Integration (`--components`)

To integrate mysql-server components into other platforms or structures (e.g., embedded systems, custom frameworks, or plugin architectures):

```bash
./build.sh release --components --clean
```

This disables the server binary (`-DWITH_SERVER=OFF`) and builds only the libraries and components, making it easier to link into other applications.

## Options

| Option | Description |
|--------|-------------|
| `minimal` | Core server only |
| `debug` | Debug + assertions |
| `release` | Optimized (`RelWithDebInfo`) |
| `full` | Full-featured release |
| `--clean` | Clean build directory first |
| `--components` | Build only libraries/components |
| `-b <dir>` | Custom build directory |
| `-j <n>` | Parallel build jobs |

## Why This Helps

- **User-friendly**: Single command with named presets instead of long CMake flags.
- **Cross-platform**: Auto-detects OS, CPU count, and CMake.
- **Modular / structural**: `--components` enables easy embedding into other platforms or frameworks without pulling in the full server.
