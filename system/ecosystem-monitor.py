#!/usr/bin/env python3
"""Ecosystem Monitor — Python version for dashboard data feed."""
import json
import os
import time
from datetime import datetime

DATA_FILE = "system/dashboard-data.json"

preset = os.environ.get("PRESET", "full")
branch = os.popen("git branch --show-current 2>/dev/null || echo unknown").read().strip()
platform = f"{os.uname().sysname} {os.uname().machine}"

container_status = "stopped"
try:
    import subprocess
    result = subprocess.run(["docker", "ps", "--format", "{{.Names}}"], capture_output=True, text=True)
    if "mysql-eco-core" in result.stdout:
        container_status = "running"
except Exception:
    pass

plugin_status = "ready" if os.path.exists("plugin/template_modular/CMakeLists.txt") else "missing"
build_artifacts = "none"
if os.path.exists("build_eco"):
    build_artifacts = f"{len([f for f in os.listdir('build_eco') if os.path.isfile(os.path.join('build_eco', f))])} artifacts"

data = {
    "system": "eco-connected",
    "timestamp": int(time.time()),
    "preset": preset,
    "branch": branch,
    "platform": platform,
    "build_artifacts": build_artifacts,
    "container_status": container_status,
    "plugin_status": plugin_status,
    "components_only": False,
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
    ],
    "last_updated": datetime.utcnow().isoformat() + "Z"
}

os.makedirs("system", exist_ok=True)
with open(DATA_FILE, "w") as f:
    json.dump(data, f, indent=2)

print(f"[ECO-MONITOR] Updated {DATA_FILE}")
print(f"  Container: {container_status}")
print(f"  Plugin: {plugin_status}")
