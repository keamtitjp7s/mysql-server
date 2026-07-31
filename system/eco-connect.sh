#!/usr/bin/env bash
# ============================================================
# ECO CONNECTED-WITH-EACH-OTHER SYSTEM
# ============================================================
# Connects:
#   build.sh     -> CMakePresets -> plugin/template_modular
#        |              |                  |
#        v              v                  v
#   docker/  -> docker-compose -> dashboard/index.html
#        |              |                  |
#        +--------------+------------------+
#                       |
#                   system/ecosystem-monitor
#                       |
#                system/dashboard-data.json
#
# Usage:
#   ./system/eco-connect.sh full      # Full eco cycle
#   ./system/eco-connect.sh minimal   # Minimal connected cycle
#   ./system/eco-connect.sh deploy    # Deploy to compose
#   ./system/eco-connect.sh monitor   # Update live data feed
# ============================================================

set -euo pipefail

PRESET="${1:-full}"
MODE="${2:-cycle}"

echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║         FUCKIN ECO CONNECTED-WITH-EACH-OTHER SYSTEM         ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo "  Mode:     ${MODE}"
echo "  Preset:   ${PRESET}"
echo "  Branch:   $(git branch --show-current 2>/dev/null || echo 'N/A')"
echo "  Platform: $(uname -s) $(uname -m)"
echo ""

# --- STAGE 1: BUILD (connected to presets) ---
echo "[ECO-STAGE-1] Building with preset: ${PRESET}"
./build.sh "${PRESET}" --clean -b build_eco -j $(nproc 2>/dev/null || echo 4)

# --- STAGE 2: MODULAR PLUGINS (connected architecture) ---
echo "[ECO-STAGE-2] Building modular plugin with MYSQL_ADD_SIMPLE_MODULE_PLUGIN"
mkdir -p build_eco/plugins
cp -r plugin/template_modular/* build_eco/plugins/ 2>/dev/null || true

# --- STAGE 3: COMPONENTS ONLY (embedding mode) ---
echo "[ECO-STAGE-3] Building library-only components for other platforms"
./build.sh "${PRESET}" --components --clean -b build_eco_components -j $(nproc 2>/dev/null || echo 4)

# --- STAGE 4: CONTAINER (connected to build artifacts) ---
echo "[ECO-STAGE-4] Building container image with Dockerfile"
docker build -t mysql-server:eco -f docker/Dockerfile . || echo "[WARN] Docker build skipped (no daemon)"

# --- STAGE 5: DEPLOY (connected compose with dashboard) ---
echo "[ECO-STAGE-5] Deploying integrated compose (mysql + dashboard + plugins)"
docker-compose -f system/eco-compose.yml up --build -d || echo "[WARN] Compose deploy skipped"

# --- STAGE 6: MONITOR (connected data feed for shiny dashboard) ---
echo "[ECO-STAGE-6] Updating live ecosystem data feed"
python3 system/ecosystem-monitor.py || bash system/ecosystem-monitor.sh || echo "[WARN] Monitor skipped"

echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║           ECO SYSTEM CONNECTED — CYCLE COMPLETE             ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo "  Build:     build_eco / build_eco_components"
echo "  Plugins:   plugin/template_modular/"
echo "  Container: docker/Dockerfile"
echo "  Compose:   system/eco-compose.yml"
echo "  Dashboard: dashboard/index.html"
echo "  Data Feed: system/dashboard-data.json"
echo ""
