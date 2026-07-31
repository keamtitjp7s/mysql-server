# FUCKIN ECO CONNECTED-WITH-EACH-OTHER SYSTEM

This is the master integration layer that connects everything we've built into a single, self-referential, user-friendly, cross-platform, container-ready, modular, shiny ecosystem.

## What It Connects

```
┌─────────────────────────────────────────────────────────────────┐
│                        ECO SYSTEM CORE                          │
│                                                                 │
│   build.sh ──────> build_eco ──────> docker/Dockerfile         │
│      │                 │                  │                     │
│      │                 │                  v                     │
│      │                 │           system/eco-compose.yml        │
│      │                 │                  │                     │
│      v                 v                  v                     │
│ CMakePresets.json  plugin/template_modular  dashboard/index.html│
│      │                 │                  │                     │
│      │                 │                  v                     │
│      │                 │           system/dashboard-data.json   │
│      │                 │                  │                     │
│      └─────────────────┴──────────────────┘                     │
│                           │                                     │
│                           v                                     │
│                    system/eco-connect.sh                          │
└─────────────────────────────────────────────────────────────────┘
```

## The 6 Stages of Eco Connection

### 1. Build (`build.sh`)
Runs named presets (`minimal`, `debug`, `release`, `full`) with clean builds in `build_eco`.

### 2. Modular Plugins (`plugin/template_modular/`)
Builds with `MYSQL_ADD_SIMPLE_MODULE_PLUGIN()` — clean, embedded-ready plugins.

### 3. Components Only (`build.sh --components`)
Produces library-only artifacts for embedding in other platforms/structures.

### 4. Container (`docker/Dockerfile`)
Multi-stage build produces lean `mysql-server:eco` image.

### 5. Deploy (`system/eco-compose.yml`)
Integrates mysql-eco, dashboard-eco (nginx serving shiny UI), and plugin-monitor.

### 6. Monitor (`system/ecosystem-monitor.sh` / `.py`)
Writes live JSON feed (`system/dashboard-data.json`) that connects build status, container health, plugin status, preset info, and platform info.

## Usage

```bash
# Full eco cycle
./system/eco-connect.sh full cycle

# Minimal eco cycle
./system/eco-connect.sh minimal cycle

# Just deploy
./system/eco-connect.sh full deploy

# Just monitor (updates dashboard feed)
./system/eco-connect.sh full monitor
```

## Integration Points

- **Dashboard**: Open `dashboard/index.html` or visit `http://localhost:8080` (via compose) to see live data.
- **K8s**: Manifests in `k8s/` deploy the same image produced by `eco-connect.sh`.
- **Plugins**: Template module links into `plugin/template_modular/` and builds automatically during the eco cycle.
- **Data Feed**: `system/dashboard-data.json` is continuously updated by the monitor, making the dashboard live.

## Why This Is Fuckin Eco

- **Self-referencing**: The build script references the presets, which reference the plugins, which reference the container, which serves the dashboard that displays the build status.
- **Cross-platform**: Works on Linux, macOS, Windows (build wrapper detects OS; Docker provides portability; K8s provides orchestration).
- **Modular**: Every piece (plugin, container, dashboard, monitor) can be replaced or used independently.
- **Shiny**: The dashboard uses modern glassmorphism, gradients, animations, and real data.
- **Connected**: Nothing exists in isolation. `eco-connect.sh` ties it all together in one command.

## Quick Commands Reference

| Action | Command |
|--------|---------|
| Full eco cycle | `./system/eco-connect.sh full cycle` |
| Minimal cycle | `./system/eco-connect.sh minimal cycle` |
| Deploy compose | `docker-compose -f system/eco-compose.yml up -d` |
| Monitor feed | `./system/ecosystem-monitor.sh` |
| View dashboard | Open `dashboard/index.html` |
| Build wrapper | `./build.sh full` |
| Component build | `./build.sh full --components` |
