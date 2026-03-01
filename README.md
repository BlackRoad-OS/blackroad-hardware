<div align="center">

# BlackRoad Hardware

**Canonical Fleet Registry · Network Topology · Device Management**

[![CI](https://github.com/BlackRoad-OS-Inc/blackroad-hardware/actions/workflows/ci.yml/badge.svg)](https://github.com/BlackRoad-OS-Inc/blackroad-hardware/actions/workflows/ci.yml)
[![Fleet](https://img.shields.io/badge/fleet-22_devices-blue)](fleet-registry.yaml)
[![AI Compute](https://img.shields.io/badge/AI_TOPS-67.8_confirmed-green)](#ai-accelerators)
[![Network](https://img.shields.io/badge/mesh-WireGuard_hub--spoke-orange)](#network-topology)
[![License](https://img.shields.io/badge/license-proprietary-red)](LICENSE)

*Single source of truth for all physical and cloud infrastructure powering the BlackRoad OS platform.*

</div>

---

## Table of Contents

- [Overview](#overview)
- [Fleet Summary](#fleet-summary)
  - [Production Pi Cluster](#production-pi-cluster)
  - [Cloud Compute](#cloud-compute)
  - [XR Devices](#xr-devices)
  - [AI Accelerators](#ai-accelerators)
- [Network Topology](#network-topology)
- [Quick Start](#quick-start)
- [Repository Structure](#repository-structure)
- [Document Index](#document-index)
  - [Device Documentation](#device-documentation)
  - [Network & Infrastructure](#network--infrastructure)
  - [Operations & Scripts](#operations--scripts)
  - [Data Registries](#data-registries)
  - [Project Documentation](#project-documentation)
  - [Governance & Process](#governance--process)
- [BlackRoad OS Ecosystem](#blackroad-os-ecosystem)
- [E2E Verification Status](#e2e-verification-status)
- [Contributing](#contributing)

---

## Overview

This repository is the authoritative registry for the entire BlackRoad OS hardware fleet — **22 registered devices** across **7 tiers** of infrastructure, from Raspberry Pi production clusters to DigitalOcean cloud droplets, AI accelerators, XR headsets, IoT sensors, and consumer endpoints.

All device manifests, network topology, IP assignments, service maps, and fleet management scripts are maintained here. Data in this registry is verified against live SSH probes, ARP tables, and ping sweeps.

| Metric | Value |
|--------|-------|
| **Total Devices** | 22 registered + 4 unidentified |
| **Production Compute Nodes** | 8 Raspberry Pi |
| **Cloud Droplets** | 2 (DigitalOcean) |
| **Confirmed AI Compute** | 67.8 TOPS (2× Hailo-8 + M1 Neural Engine) |
| **Network Mesh** | WireGuard hub-and-spoke via Shellfish |
| **Ingress** | Cloudflare Tunnel (QUIC) — all `blackroad.io` subdomains |
| **Agent Capacity** | 30,000 across Pi cluster |
| **Fleet Registry Version** | 2.2.0 |

---

## Fleet Summary

### Production Pi Cluster

The always-on backbone of BlackRoad infrastructure. All nodes run Ollama, Cloudflared, and Docker.

| Node | Board | IP | Storage | Accelerator | Role | Status |
|------|-------|----|---------|-------------|------|--------|
| **cecilia** | Pi 5 8GB | 192.168.4.89 | 457GB NVMe (15%) | Hailo-8 26 TOPS | Primary AI host | ✅ Active |
| **lucidia** | Pi 5 8GB | 192.168.4.81 | 119G SD + 1TB NVMe (1%) | Hailo-8 26 TOPS | NATS bus, LLM inference | ✅ Active |
| **octavia** | Pi 5 8GB | 192.168.4.38 | 238GB SD (34%) | — | AI inference, services | ✅ Active |
| **aria** | Pi 5 8GB | 192.168.4.82 | 29GB SD (74%) | — | API services, compute | ✅ Active |
| **anastasia** | Pi 5 8GB | 192.168.4.33 | — | — | AI inference secondary | ⚠️ SSH closed |
| **cordelia** | Pi 5 8GB | 192.168.4.27 | — | — | Orchestration | ⚠️ SSH closed |
| **alice** | Pi 400 4GB | 192.168.4.49 | 15GB SD (71%) | — | Gateway, development | ✅ Active |
| **olympia** | Pi 4B 4GB | — | — | — | KVM console | 🔴 Offline |

### Cloud Compute

| Node | Provider | Public IP | Storage | Role | Status |
|------|----------|-----------|---------|------|--------|
| **codex-infinity** | DigitalOcean | 159.65.43.12 | 78GB SSD (27%) | Codex server, oracle | ✅ Active |
| **shellfish** | DigitalOcean | 174.138.44.45 | 25GB SSD (57%) | WireGuard hub, edge compute | ✅ Active |

### XR Devices

| Node | Model | Role | Status |
|------|-------|------|--------|
| **andromeda** | Meta Quest 2 | XR interface, spatial agent | ⏳ Setup pending |

### AI Accelerators

| Accelerator | Node | TOPS | Interface | Status |
|-------------|------|------|-----------|--------|
| Hailo-8 M.2 | Cecilia | 26 | PCIe M.2 | ✅ Confirmed (`/dev/hailo0`) |
| Hailo-8 M.2 | Lucidia | 26 | PCIe M.2 | ✅ Confirmed (`hailort.service`) |
| Apple M1 Neural Engine | Alexandria | 15.8 | Onboard | ✅ Active |
| Jetson Orin Nano GPU | — | 40 | Onboard | ⏳ Pending deployment |
| **Total Confirmed** | | **67.8** | | |
| **Total Potential** | | **~134** | | *If all modules installed* |

---

## Network Topology

```
                            INTERNET
                               │
                       ┌───────▼───────┐
                       │  Cloudflare   │  *.blackroad.io
                       │ Tunnel (QUIC) │
                       └───────┬───────┘
                               │
            ┌──────────────────┼──────────────────┐
            │                  │                   │
     ┌──────▼──────┐   ┌──────▼──────┐    ┌──────▼──────┐
     │  Shellfish  │   │   Codex-∞   │    │  TP-Link    │
     │  WG Hub     │   │  159.65.43  │    │  Router     │
     │ 174.138.44  │   └─────────────┘    │  .4.1       │
     │ 10.8.0.1    │                      └──────┬──────┘
     └──────┬──────┘                             │
            │ WireGuard                          │ LAN 192.168.4.0/24
            │ 10.8.0.0/24                        │
     ┌──────┼──────┬──────┬──────┐    ┌──────────┼──────────┐
     │      │      │      │      │    │          │          │
  Cecilia Lucidia Alice  Aria  Inf  Octavia  Cordelia  + IoT
  .0.3    .0.4    .0.6   .0.7  .0.8  (pending)  (pending)
```

| Layer | Technology | Details |
|-------|-----------|---------|
| **VPN Mesh** | WireGuard | Hub-and-spoke, Shellfish as hub (10.8.0.0/24) |
| **Ingress** | Cloudflare Tunnel | QUIC protocol, 5 active tunnels |
| **DNS** | Cloudflare | All `blackroad.io` subdomains proxied |
| **LAN** | 192.168.4.0/24 | TP-Link router, Gigabit switch backbone |

> See [`network/topology.md`](network/topology.md) for the full verified network map and [`network/services-map.md`](network/services-map.md) for per-node port listings.

---

## Quick Start

```bash
# Clone the repository
git clone https://github.com/BlackRoad-OS-Inc/blackroad-hardware.git
cd blackroad-hardware

# Check fleet health
./scripts/fleet-health-check.sh

# Run hardware inventory
./scripts/hardware-inventory.sh

# Discover devices on the network
./scripts/discover.sh

# Manage Meta Quest 2 (andromeda)
./scripts/quest-adb.sh devices           # Detect Quest
./scripts/quest-adb.sh wifi-enable       # Enable WiFi ADB
./scripts/quest-adb.sh status            # Hardware info
./scripts/quest-adb.sh bootstrap-agents  # Install BlackRoad agents
```

---

## Repository Structure

```
blackroad-hardware/
│
├── fleet-registry.yaml          # Source of truth — all 22 devices (YAML)
├── registry.json                # Device registry with MACs, specs, roles (JSON)
├── network.json                 # Network topology, Cloudflare tunnel, WireGuard mesh
│
├── devices/                     # Per-device-type documentation
│   ├── raspberry-pi.md          #   Pi cluster (8 nodes) — live verified
│   ├── cloud-compute.md         #   DigitalOcean droplets (2 nodes)
│   ├── edge-compute.md          #   Jetson Orin Nano + RISC-V
│   ├── xr-headsets.md           #   Meta Quest 2 (andromeda)
│   ├── consumer-devices.md      #   Roku, Xbox, iPhone, MacBooks
│   ├── iot-sensors.md           #   ESP32 LoRa, environmental sensors
│   ├── microcontrollers.md      #   MCU array (ESP32, BL808, RP2040)
│   └── nodes.yaml               #   Machine-readable node definitions
│
├── accelerators/                # AI/GPU accelerator documentation
│   └── ai-compute.md           #   Hailo-8, M1 NE, Jetson — TOPS budget
│
├── network/                     # Network infrastructure
│   ├── topology.md              #   Full LAN/WAN/WireGuard topology
│   └── services-map.md          #   Per-node service + port inventory
│
├── docs/                        # Operational documentation
│   ├── CONNECTIVITY.md          #   SSH, Ollama, USB, Cloudflare access guide
│   └── TOPOLOGY.md              #   Network topology reference
│
├── projects/                    # Hardware project builds
│   └── wavecube/                #   DLP projector hack (Pi Zero + ESP32)
│
├── scripts/                     # Fleet management automation
│   ├── fleet-health-check.sh    #   Ping + SSH health probe
│   ├── hardware-inventory.sh    #   Collect specs from all nodes
│   ├── discover.sh              #   Network device discovery
│   ├── quest-adb.sh             #   Meta Quest 2 ADB manager
│   └── quest-bootstrap.sh       #   Quest agent bootstrap
│
├── HARDWARE_BACKEND_MAP.md      # Full live-verified backend map (all nodes)
├── FLEET_FILESYSTEM_MAP.md      # Per-node filesystem + storage analysis
├── FILESYSTEM_MAP.md            # Alexandria (Mac) filesystem + ownership
├── CHANGELOG.md                 # Version history
├── CONTRIBUTING.md              # Contribution guidelines
├── CLAUDE.md                    # AI agent instructions for this repo
└── LICENSE                      # Proprietary — BlackRoad OS, Inc.
```

---

## Document Index

Complete cross-reference of all documentation in this repository. Use this index to navigate directly to the information you need.

### Device Documentation

| Document | Path | Description |
|----------|------|-------------|
| Pi Cluster Guide | [`devices/raspberry-pi.md`](devices/raspberry-pi.md) | All 8 Pi nodes — specs, services, IPs, errata |
| Cloud Compute Guide | [`devices/cloud-compute.md`](devices/cloud-compute.md) | DigitalOcean droplets — Codex-Infinity, Shellfish |
| Edge Compute Guide | [`devices/edge-compute.md`](devices/edge-compute.md) | Jetson Orin Nano, RISC-V devices |
| XR Headsets Guide | [`devices/xr-headsets.md`](devices/xr-headsets.md) | Meta Quest 2 setup, ADB, Termux bootstrap |
| Consumer Devices | [`devices/consumer-devices.md`](devices/consumer-devices.md) | Roku, Xbox, iPhone, MacBook inventory |
| IoT Sensors | [`devices/iot-sensors.md`](devices/iot-sensors.md) | ESP32 LoRa, environmental monitoring |
| Microcontrollers | [`devices/microcontrollers.md`](devices/microcontrollers.md) | MCU array — ESP32, BL808, RP2040 |
| Node Definitions | [`devices/nodes.yaml`](devices/nodes.yaml) | Machine-readable node specs |

### Network & Infrastructure

| Document | Path | Description |
|----------|------|-------------|
| Network Topology | [`network/topology.md`](network/topology.md) | Full LAN, WireGuard mesh, ARP map, DNS |
| Services Map | [`network/services-map.md`](network/services-map.md) | Per-node listening ports and services |
| Connectivity Guide | [`docs/CONNECTIVITY.md`](docs/CONNECTIVITY.md) | SSH access, Ollama endpoints, USB devices |
| Topology Reference | [`docs/TOPOLOGY.md`](docs/TOPOLOGY.md) | Network topology diagrams |
| Network Config (JSON) | [`network.json`](network.json) | LAN, WireGuard, Cloudflare tunnel config |

### Operations & Scripts

| Script | Path | Description |
|--------|------|-------------|
| Fleet Health Check | [`scripts/fleet-health-check.sh`](scripts/fleet-health-check.sh) | Ping + SSH probe all nodes |
| Hardware Inventory | [`scripts/hardware-inventory.sh`](scripts/hardware-inventory.sh) | Collect specs from fleet |
| Network Discovery | [`scripts/discover.sh`](scripts/discover.sh) | ARP/ping sweep for device discovery |
| Quest ADB Manager | [`scripts/quest-adb.sh`](scripts/quest-adb.sh) | Meta Quest 2 ADB operations |
| Quest Bootstrap | [`scripts/quest-bootstrap.sh`](scripts/quest-bootstrap.sh) | Install BlackRoad agents on Quest |

### Data Registries

| File | Path | Format | Description |
|------|------|--------|-------------|
| Fleet Registry | [`fleet-registry.yaml`](fleet-registry.yaml) | YAML | **Source of truth** — all 22 devices, full specs |
| Device Registry | [`registry.json`](registry.json) | JSON | Legacy registry — IPs, MACs, hardware, roles |
| Network Config | [`network.json`](network.json) | JSON | Subnet, WireGuard mesh, Cloudflare tunnel |

### Project Documentation

| Project | Path | Description |
|---------|------|-------------|
| WaveCube Projector | [`projects/wavecube/`](projects/wavecube/) | DLP2000 projector build (Pi Zero + ESP32) |

### Governance & Process

| Document | Path | Description |
|----------|------|-------------|
| Changelog | [`CHANGELOG.md`](CHANGELOG.md) | Version history (semver) |
| Contributing Guide | [`CONTRIBUTING.md`](CONTRIBUTING.md) | Branch naming, commit style, PR requirements |
| AI Agent Guide | [`CLAUDE.md`](CLAUDE.md) | Instructions for AI agents working in this repo |
| Code Owners | [`.github/CODEOWNERS`](.github/CODEOWNERS) | Code ownership assignments |
| PR Template | [`.github/PULL_REQUEST_TEMPLATE.md`](.github/PULL_REQUEST_TEMPLATE.md) | Pull request template |
| Backend Map | [`HARDWARE_BACKEND_MAP.md`](HARDWARE_BACKEND_MAP.md) | Full live-verified hardware backend map |
| Fleet Filesystem Map | [`FLEET_FILESYSTEM_MAP.md`](FLEET_FILESYSTEM_MAP.md) | Per-node filesystem and storage analysis |
| Mac Filesystem Map | [`FILESYSTEM_MAP.md`](FILESYSTEM_MAP.md) | Alexandria (Mac) filesystem + ownership |
| License | [`LICENSE`](LICENSE) | Proprietary — BlackRoad OS, Inc. |

---

## BlackRoad OS Ecosystem

This repository is one component of the BlackRoad OS platform. The hardware fleet documented here supports the full ecosystem of services, APIs, and applications.

| Layer | Component | Integration Point |
|-------|-----------|-------------------|
| **Infrastructure** | `blackroad-hardware` (this repo) | Fleet registry, network topology |
| **Platform** | `blackroad-infra` | Deployment, orchestration, CI/CD |
| **Services** | API + Web Services | Hosted across Pi cluster and cloud droplets |
| **Payments** | Stripe Integration | Payment processing via cloud endpoints |
| **Packages** | npm Registry | Shared packages published to npm |
| **Agents** | 30,000-agent mesh | Distributed across fleet nodes |
| **Ingress** | Cloudflare | CDN, DDoS protection, tunnel routing |
| **Observability** | InfluxDB + Loki + MinIO | Metrics, logs, object storage on Cecilia |

### Integration Endpoints

| Service | Endpoint | Node |
|---------|----------|------|
| API Gateway | `api.blackroad.io` | Cecilia (via Cloudflare Tunnel) |
| Agent Interface | `agents.blackroad.io` | Cecilia |
| Dashboard | `dashboard.blackroad.io` | Shellfish |
| Status | `status.blackroad.io` | Cloudflare |
| Documentation | `docs.blackroad.io` | Cloudflare |
| Monitoring | `monitoring.blackroad.io` | Cecilia |

---

## E2E Verification Status

All fleet data is verified end-to-end against live infrastructure. The following table summarizes the verification status of each system layer.

| Layer | Method | Last Verified | Status |
|-------|--------|---------------|--------|
| **Device Connectivity** | SSH probe + ping sweep | 2026-02-21 | ✅ Verified |
| **Network Topology** | ARP table + port scan | 2026-02-21 | ✅ Verified |
| **Service Health** | `ss -tlnp` via SSH | 2026-02-21 | ✅ Verified |
| **AI Accelerators** | `/dev/hailo0` + `hailort.service` | 2026-02-21 | ✅ Verified |
| **DNS Resolution** | `dig +short` all subdomains | 2026-02-21 | ✅ Verified |
| **Cloudflare Tunnels** | `cloudflared.service` status | 2026-02-21 | ✅ Verified (5/5 active) |
| **WireGuard Mesh** | `wg show` on hub + spokes | 2026-02-21 | ✅ Verified (6/8 active) |
| **Storage** | `df -h` via SSH | 2026-02-21 | ✅ Verified |
| **CI Pipeline** | GitHub Actions | Continuous | ✅ Passing |

### Verification Scripts

```bash
# Full fleet health check (ping + SSH)
./scripts/fleet-health-check.sh

# Network discovery (ARP + ping sweep)
./scripts/discover.sh

# Hardware inventory (specs collection)
./scripts/hardware-inventory.sh
```

> **Verification methodology:** All device data is probed via live SSH connections, ARP table inspection, and port scanning. Documentation flagged as "Live Verified" has been confirmed against running systems. See [`HARDWARE_BACKEND_MAP.md`](HARDWARE_BACKEND_MAP.md) for full verification details and data sources.

---

## Contributing

See [`CONTRIBUTING.md`](CONTRIBUTING.md) for branch naming conventions, commit style, and PR requirements.

All contributions are proprietary work-for-hire owned exclusively by BlackRoad OS, Inc.

---

<div align="center">

© 2024–2026 **BlackRoad OS, Inc.** — All rights reserved. Proprietary and confidential.

[Fleet Registry](fleet-registry.yaml) · [Network Config](network.json) · [Device Registry](registry.json) · [Changelog](CHANGELOG.md)

</div>
