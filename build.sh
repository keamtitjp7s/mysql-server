#!/usr/bin/env bash
# User-friendly build wrapper for mysql-server
# Supports common presets: minimal, debug, release, full
# Works across Linux, macOS, and Windows (with CMake/Visual Studio)

set -euo pipefail

PRESET="full"
BUILD_DIR="build"
JOBS=$(nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 4)

usage() {
    cat << USAGE
Usage: $(basename "$0") [OPTIONS] [preset]

Presets:
  minimal    Minimal server build (core only, fast)
  debug      Debug build with assertions and debug symbols
  release    Optimized release build (default: full)
  full       Full-featured release build (default)

Options:
  -h, --help        Show this help
  -b, --build-dir   Build directory (default: build)
  -j, --jobs        Parallel jobs (default: ${JOBS})
  --clean           Clean build directory first
  --components      Build only modular components/libmysql (easier embedding)
USAGE
    exit 0
}

COMPONENTS_ONLY=0
CLEAN=0
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help) usage ;;
        -b|--build-dir) BUILD_DIR="$2"; shift 2 ;;
        -j|--jobs) JOBS="$2"; shift 2 ;;
        --clean) CLEAN=1; shift ;;
        --components) COMPONENTS_ONLY=1; shift ;;
        minimal|debug|release|full) PRESET="$1"; shift ;;
        *) echo "Unknown option: $1"; usage; exit 1 ;;
    esac
done

echo "========================================"
echo "MySQL Server User-Friendly Build Wrapper"
echo "========================================"
echo "Preset:     ${PRESET}"
echo "Build dir:  ${BUILD_DIR}"
echo "Jobs:       ${JOBS}"
echo "Platform:   $(uname -s) $(uname -m)"

# Cross-platform checks
if ! command -v cmake &>/dev/null; then
    echo "ERROR: cmake not found. Please install CMake (>=3.5.1)."
    exit 1
fi

CMAKE_VERSION=$(cmake --version | head -n1 | awk '{print $3}')
echo "CMake:      ${CMAKE_VERSION}"

if [[ "${CLEAN}" -eq 1 && -d "${BUILD_DIR}" ]]; then
    echo "Cleaning build directory..."
    rm -rf "${BUILD_DIR}"
fi

mkdir -p "${BUILD_DIR}"

# Configure based on preset
CMAKE_ARGS=(
    -DCMAKE_BUILD_TYPE=Release
    -DWITH_SSL=system
)

case ${PRESET} in
    minimal)
        CMAKE_ARGS+=(
            -DWITH_DEBUG=OFF
            -DWITH_EMBEDDED_SERVER=OFF
            -DWITH_INNOBASE_STORAGE_ENGINE=ON
            -DWITH_ARCHIVE_STORAGE_ENGINE=OFF
            -DWITH_BLACKHOLE_STORAGE_ENGINE=OFF
            -DWITH_EXAMPLE_STORAGE_ENGINE=OFF
            -DWITH_NDBCLUSTER_STORAGE_ENGINE=OFF
        )
        ;;
    debug)
        CMAKE_ARGS+=(
            -DCMAKE_BUILD_TYPE=Debug
            -DWITH_DEBUG=ON
            -DWITH_VALGRIND=ON
        )
        ;;
    release)
        CMAKE_ARGS+=(
            -DCMAKE_BUILD_TYPE=RelWithDebInfo
            -DWITH_DEBUG=OFF
        )
        ;;
    full)
        CMAKE_ARGS+=(
            -DCMAKE_BUILD_TYPE=RelWithDebInfo
            -DWITH_SSL=system
            -DWITH_ARCHIVE_STORAGE_ENGINE=ON
            -DWITH_BLACKHOLE_STORAGE_ENGINE=ON
            -DWITH_EXAMPLE_STORAGE_ENGINE=ON
            -DWITH_NDBCLUSTER_STORAGE_ENGINE=OFF
        )
        ;;
esac

if [[ ${COMPONENTS_ONLY} -eq 1 ]]; then
    echo "Components-only mode: building libmysql and modular libraries for embedding."
    CMAKE_ARGS+=(
        -DWITH_SERVER=OFF
        -DWITH_NDBCLUSTER=OFF
        -DWITH_UNIT_TESTS=OFF
    )
fi

echo ""
echo "Running CMake with preset: ${PRESET}"
echo "Args: ${CMAKE_ARGS[*]}"
echo ""

cmake -S . -B "${BUILD_DIR}" "${CMAKE_ARGS[@]}"

echo ""
echo "Building with ${JOBS} parallel jobs..."
cmake --build "${BUILD_DIR}" --parallel "${JOBS}"

echo ""
echo "Build complete. Artifacts in: ${BUILD_DIR}/"
