# 🐳 MySQL Server — Container Stack

> User-friendly · Cross-platform · Modular · **Shiny**

[![Docker Build](https://img.shields.io/badge/docker-build-blue?logo=docker&style=flat-square)](docker/Dockerfile)
[![K8s Ready](https://img.shields.io/badge/k8s-ready-326ce5?logo=kubernetes&style=flat-square)](k8s/)
[![CMake Presets](https://img.shields.io/badge/cmake-presets-green?logo=cmake&style=flat-square)](CMakePresets.json)

---

## Quick Start (Shiny Mode)

```bash
# Build & run locally
cd docker
docker-compose up --build

# Or deploy to Kubernetes
kubectl apply -f ../k8s/
```

## What's Inside

| Component | File | Purpose |
|-----------|------|---------|
| Multi-stage Dockerfile | `docker/Dockerfile` | Lean runtime image from full build |
| Compose orchestration | `docker/docker-compose.yml` | Persistent storage + health checks |
| K8s deployment | `k8s/deployment.yaml` | Replicas, probes, resource limits |
| K8s service | `k8s/service.yaml` | ClusterIP on port 3306 |
| ConfigMap | `k8s/configmap.yaml` | Config + init SQL |
| PVC | `k8s/pvc.yaml` | Persistent storage |

## Multi-Stage Build

The Dockerfile separates **builder** (full build with `build.sh`) from **runtime** (only `mysqld`, libraries, and config). The result is a clean, portable image that works on any platform supporting the container runtime.

## Modular Integration

Use `--components` to build only libraries for embedding:

```bash
./build.sh full --components
```

Then link against the produced `libmysqlclient.so` or load `plugin/*.so` modules in your own container or platform.

## Shiny Dashboard

Open `dashboard/index.html` in your browser for a modern, interactive status view of the container stack, build presets, and plugin architecture.
