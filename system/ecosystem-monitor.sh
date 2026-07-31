#!/usr/bin/env bash
# Ecosystem Monitor — writes live feed for shiny dashboard
# Connects: build.sh, docker-compose, plugin status, preset info

DATA_FILE="system/dashboard-data.json"
mkdir -p system

PRESET="${PRESET:-full}"
BUILD_DIR="build_eco"
CONTAINER_STATUS="unknown"
PLUGIN_STATUS="unknown"

# Check container status
if docker ps --format "{{.Names}}" | grep -q "mysql-eco-core"; then
    CONTAINER_STATUS="running"
else
    CONTAINER_STATUS="stopped"
fi

# Check plugin build
if [ -f "plugin/template_modular/CMakeLists.txt" ]; then
    PLUGIN_STATUS="ready"
fi

# Check build artifacts
BUILD_ARTIFACTS="none"
if [ -d "${BUILD_DIR}" ]; then
    COUNT=$(find "${BUILD_DIR}" -name "mysqld" 2>/dev/null | wc -l)
    BUILD_ARTIFACTS="${COUNT} artifacts"
fi

cat > "${DATA_FILE}" <<EOF
{
  "system": "eco-connected",
  "timestamp": $(date +%s),
  "preset": "${PRESET}",
  "branch": "$(git branch --show-current 2>/dev/null || echo 'unknown')",
  "platform": "$(uname -s) $(uname -m)",
  "build_artifacts": "${BUILD_ARTIFACTS}",
  "container_status": "${CONTAINER_STATUS}",
  "plugin_status": "${PLUGIN_STATUS}",
  "components_only": false,
  "dashboard_url": "http://localhost:8080",
  "modules": [
    "build_wrapper",
    "cmake_presets",
    "modular_plugins",
    "container_stack",
    "dashboard_ui"
  ],
  "connections": [
    "build.sh -> docker-compose -> dashboard",
    "plugin/template_modular -> k8s/deployment.yaml",
    "CMakePresets.json -> build_eco"
  ]
}
EOF

echo "[ECO-MONITOR] Data feed updated: ${DATA_FILE}"
echo "  Container: ${CONTAINER_STATUS}"
echo "  Plugin: ${PLUGIN_STATUS}"
echo "  Preset: ${PRESET}"
