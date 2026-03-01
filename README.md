# blackroad-hardware

> Authoritative hardware fleet registry, network topology, device manifests, and management tooling for the BlackRoad OS production infrastructure.

[![CI](https://github.com/BlackRoad-OS/blackroad-hardware/actions/workflows/ci.yml/badge.svg)](https://github.com/BlackRoad-OS/blackroad-hardware/actions/workflows/ci.yml)
[![npm](https://img.shields.io/npm/v/@blackroad/hardware-registry)](https://www.npmjs.com/package/@blackroad/hardware-registry)
[![License: Proprietary](https://img.shields.io/badge/license-Proprietary-red.svg)](LICENSE)

---

## Table of Contents

1. [Overview](#overview)
2. [Repository Structure](#repository-structure)
3. [Fleet Summary](#fleet-summary)
   - [Production Pi Cluster](#production-pi-cluster)
   - [Cloud Nodes](#cloud-nodes)
   - [Edge & Accelerator Nodes](#edge--accelerator-nodes)
   - [XR Headsets](#xr-headsets)
   - [Key Fleet Metrics](#key-fleet-metrics)
4. [Network Topology](#network-topology)
5. [npm Integration](#npm-integration)
6. [Stripe Integration](#stripe-integration)
7. [E2E Testing](#e2e-testing)
8. [Quick Start](#quick-start)
9. [Key Files](#key-files)
10. [Contributing](#contributing)
11. [License](#license)

---

## Overview

`blackroad-hardware` is the single source of truth for all physical and cloud infrastructure in the BlackRoad OS fleet — Raspberry Pi compute cluster, DigitalOcean droplets, XR headsets, AI accelerators, MCU mesh array, and full network topology.

**22 registered devices** across 7 tiers. All data is verified against live SSH, ARP, and ping probes. This registry drives automation, provisioning, agent assignment, billing, and health monitoring across the entire BlackRoad OS platform.

---

## Repository Structure

```
blackroad-hardware/
├── fleet-registry.yaml       # Source of truth — all 22 devices (YAML, machine-readable)
├── registry.json             # Device registry (JSON, legacy + tooling)
├── network.json              # Network topology, IP assignments, Cloudflare tunnel config
├── agents.json               # Agent-to-device mapping, AI model assignments, capacity
├── devices/                  # Per-device-type documentation
│   ├── raspberry-pi.md       # Pi cluster setup, services, and SSH guide
│   ├── edge-compute.md       # Jetson Orin Nano + RISC-V (siren)
│   ├── cloud-compute.md      # DigitalOcean droplets
│   ├── xr-headsets.md        # Meta Quest 2 (andromeda) — ADB, Termux, agents
│   ├── consumer-devices.md   # MacBooks, iPhone, Roku, Xbox
│   ├── iot-sensors.md        # IoT sensor array
│   └── microcontrollers.md   # ESP32 LoRa mesh (21-node MCU array)
├── accelerators/             # AI accelerator configs (Hailo-8, M1 Neural Engine)
│   └── ai-compute.md
├── network/                  # Network diagrams and WireGuard configs
│   ├── topology.md           # Live-verified physical + Tailscale topology
│   └── services-map.md       # Port/service map per device (live SSH probe)
├── docs/                     # Hardware documentation
│   ├── TOPOLOGY.md           # Full device-to-device connection tree
│   └── CONNECTIVITY.md       # WireGuard, Tailscale, Cloudflare tunnel setup
├── projects/                 # Embedded hardware projects
│   └── wavecube/             # WaveQube DLP projector hack (Pi Zero 2W + DLP2000)
├── scripts/                  # Fleet management scripts
│   ├── fleet-health-check.sh # Ping/SSH health sweep across all nodes
│   ├── hardware-inventory.sh # Pull specs from live devices
│   └── quest-adb.sh          # Meta Quest 2 (andromeda) ADB manager
├── HARDWARE_BACKEND_MAP.md   # Live-verified backend map with errata
├── FLEET_FILESYSTEM_MAP.md   # Full filesystem layout per device
├── FILESYSTEM_MAP.md         # Alexandria (Mac) filesystem and ownership map
├── CHANGELOG.md              # Version history
└── CONTRIBUTING.md           # Contribution guidelines
```

---

## Fleet Summary

### Production Pi Cluster

| Name | IP (LAN) | IP (Tailscale) | Role | Accelerator | Status |
|------|----------|----------------|------|-------------|--------|
| cecilia | 192.168.4.89 | 100.72.180.98 | Primary AI host, orchestration | Hailo-8 26 TOPS, 457GB NVMe | **Active** |
| octavia | 192.168.4.38 | 100.66.235.47 | AI inference, auth, DNS | Pironman case | **Active** |
| lucidia | 192.168.4.81 | 100.83.149.86 | NATS bus, LLM inference | Hailo-8, 1TB NVMe | **Active** |
| aria | 192.168.4.82 | 100.109.14.17 | API services, compute | — | **Active** |
| anastasia | 192.168.4.33 | — | AI inference secondary | — | SSH closed |
| cordelia | 192.168.4.27 | — | Orchestration | — | SSH closed |
| alice | 192.168.4.49 | 100.77.210.18 | Gateway, development | Pi 400 | **Active** |
| olympia | — | — | KVM console | Pi 4B | Offline |

### Cloud Nodes

| Name | Public IP | Provider | Role | Status |
|------|-----------|----------|------|--------|
| codex-infinity (gematria) | 159.65.43.12 | DigitalOcean nyc1 | Codex server, oracle | **Active** |
| shellfish (anastasia) | 174.138.44.45 | DigitalOcean nyc1 | WireGuard hub, cloud infra | **Active** |

### Edge & Accelerator Nodes

| Name | Type | Accelerator | Status |
|------|------|-------------|--------|
| jetson-agent | Jetson Orin Nano 8GB | 40 TOPS GPU | Pending deployment |
| siren | Sipeed BL808 RISC-V | — | Active (USB, alexandria) |
| alexandria | MacBook Pro M1 8GB | M1 Neural Engine 15.8 TOPS | Active |

### XR Headsets

| Name | Model | Role | Status |
|------|-------|------|--------|
| andromeda | Meta Quest 2 | XR interface, spatial agent | Setup pending |

### Key Fleet Metrics

| Metric | Value |
|--------|-------|
| Total registered devices | 22 |
| Confirmed AI TOPS | 67.8 (2× Hailo-8 + M1 NE) |
| Potential AI TOPS (full build-out) | 134 |
| Agent capacity | 30,000 (across Pi cluster) |
| Network | 192.168.4.0/24 LAN + 7-node Tailscale mesh |
| Cloudflare tunnel | QUIC, Dallas edge (dfw08) |
| Observability stack | PostgreSQL · InfluxDB · MinIO · Loki · Prometheus |

---

## Network Topology

```
INTERNET
    │
 Cloudflare (QUIC tunnel → cecilia :80/443)
    │
TP-Link Router (192.168.4.1)
    │
TP-Link TL-SG105 Gigabit Switch
    ├── cecilia   .89  — Primary AI / Cece OS / Hailo-8
    ├── octavia   .38  — Compute / Auth / DNS
    ├── lucidia   .81  — NATS / LLM / Hailo-8
    ├── aria      .82  — API services
    └── alice     .49  — Gateway / development

Tailscale Mesh (7 nodes)
    ├── cecilia   100.72.180.98
    ├── octavia   100.66.235.47
    ├── lucidia   100.83.149.86
    ├── aria      100.109.14.17
    ├── alice     100.77.210.18
    ├── shellfish 100.94.33.37   (DigitalOcean)
    └── gematria  100.108.132.8  (DigitalOcean)
```

Public API routes via Cloudflare tunnel (on cecilia):

| Hostname | Backend |
|----------|---------|
| `agent.blackroad.ai` | `localhost:8080` |
| `api.blackroad.ai` | `localhost:3000` |

See [`network/topology.md`](network/topology.md) and [`network/services-map.md`](network/services-map.md) for the full live-verified port and service map.

---

## npm Integration

The BlackRoad hardware registry is available as an npm package for use in Node.js services, CI pipelines, and agent tooling.

**Package:** [`@blackroad/hardware-registry`](https://www.npmjs.com/package/@blackroad/hardware-registry)

```bash
npm install @blackroad/hardware-registry
```

**Usage:**

```js
const { getDevice, listFleet } = require('@blackroad/hardware-registry');

// Look up a device by name
const cecilia = getDevice('cecilia');
console.log(cecilia.ip_local);   // '192.168.4.89'
console.log(cecilia.accelerator); // 'Hailo-8 M.2 26 TOPS'

// List all active production devices
const active = listFleet({ tier: 'production', status: 'active' });
```

The package exposes the `fleet-registry.yaml` and `network.json` data as typed JavaScript/TypeScript objects. It is used by:

- `@blackroad/agent-runtime` — to resolve device targets for agent dispatch
- `@blackroad/api` — to populate fleet dashboards and health endpoints
- CI/CD pipelines — for infrastructure validation and deployment targeting

> **Note:** The npm package is published from this repository. Update `fleet-registry.yaml` and bump the version in `CHANGELOG.md` when device data changes.

---

## Stripe Integration

BlackRoad OS uses Stripe for subscription billing, metered API usage, and hardware provisioning fees.

**Relevant billing touchpoints in the hardware fleet:**

| Event | Stripe Integration |
|-------|--------------------|
| New device registered | Triggers provisioning webhook → Stripe metered billing item |
| Agent capacity allocated | Billed per 1,000-agent-slot blocks via Stripe usage records |
| Cloud node (DigitalOcean) spin-up | Cost passed through via Stripe invoice line item |
| XR device activation | One-time activation fee via Stripe Checkout |

**Environment variables required** (set in deployment secrets, never in this repo):

```
STRIPE_SECRET_KEY=sk_live_...         # Server-side only — never commit
STRIPE_WEBHOOK_SECRET=whsec_...       # Webhook signature verification
STRIPE_PRICE_ID_AGENT_SLOT=price_...  # Metered agent capacity price
```

> **Security:** No Stripe keys or secrets are stored in this repository. All billing logic lives in [`blackroad-api`](https://github.com/BlackRoad-OS/blackroad-api). This registry only provides device metadata consumed by the billing service.

See the `api.blackroad.ai` service on cecilia (`:3000`) for the billing integration endpoint.

---

## E2E Testing

End-to-end tests validate the live fleet registry, network reachability, and API surface.

### Running E2E Tests

```bash
# Full fleet health check (ping + SSH probe)
./scripts/fleet-health-check.sh

# Hardware inventory (pulls live specs via SSH)
./scripts/hardware-inventory.sh

# Meta Quest 2 ADB end-to-end
./scripts/quest-adb.sh devices          # detect connected headset
./scripts/quest-adb.sh status           # pull hardware info
./scripts/quest-adb.sh wifi-enable      # enable WiFi ADB
./scripts/quest-adb.sh bootstrap-agents # install BlackRoad agent APK
```

### CI Pipeline

The CI workflow (`.github/workflows/ci.yml`) runs on every push and pull request to `main`:

| Step | Description |
|------|-------------|
| Secrets check | Scans all `.py`, `.ts`, `.js` files for hardcoded `PRIVATE_KEY`, `SECRET_KEY`, `API_KEY` |
| Markdown validation | Validates all `.md` files are well-formed |

### Integration Test Checklist

Before merging any change to `fleet-registry.yaml` or `network.json`:

- [ ] `./scripts/fleet-health-check.sh` passes for all active nodes
- [ ] `./scripts/hardware-inventory.sh` returns expected specs
- [ ] Cloudflare tunnel routes respond (`curl https://api.blackroad.ai/health`)
- [ ] Tailscale mesh connectivity verified (`tailscale status`)
- [ ] npm package builds without error (`npm run build` in package root)
- [ ] Stripe webhook test event fires correctly (use Stripe CLI: `stripe trigger customer.subscription.created`)

---

## Quick Start

```bash
# Clone the registry
git clone https://github.com/BlackRoad-OS/blackroad-hardware.git
cd blackroad-hardware

# Check fleet health
./scripts/fleet-health-check.sh

# Pull live hardware inventory
./scripts/hardware-inventory.sh

# SSH to a Pi node
ssh pi@192.168.4.89        # cecilia
ssh pi@192.168.4.38        # octavia
ssh alice@192.168.4.49     # alice

# Via Tailscale (remote access)
ssh pi@100.72.180.98       # cecilia
ssh pi@100.66.235.47       # octavia

# Manage Meta Quest 2 (andromeda)
./scripts/quest-adb.sh devices
./scripts/quest-adb.sh bootstrap-agents
```

---

## Key Files

| File | Description |
|------|-------------|
| [`fleet-registry.yaml`](fleet-registry.yaml) | All 22 devices — specs, IPs, roles, services, accelerators |
| [`registry.json`](registry.json) | JSON device registry (consumed by npm package and API) |
| [`network.json`](network.json) | Full network topology, Tailscale mesh, Cloudflare tunnel |
| [`agents.json`](agents.json) | Agent-to-device assignments, AI model per node, capacity |
| [`HARDWARE_BACKEND_MAP.md`](HARDWARE_BACKEND_MAP.md) | Live-verified backend map with errata |
| [`devices/raspberry-pi.md`](devices/raspberry-pi.md) | Pi cluster services, setup, and SSH guide |
| [`devices/xr-headsets.md`](devices/xr-headsets.md) | Quest 2 setup, ADB guide, Termux agent bootstrap |
| [`network/services-map.md`](network/services-map.md) | Port/service map per device (live SSH probe) |
| [`network/topology.md`](network/topology.md) | Full physical + Tailscale topology diagram |

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for branch naming conventions, commit style, and pull request requirements.

All contributions are proprietary work-for-hire owned exclusively by BlackRoad OS, Inc.

---

## License

© BlackRoad OS, Inc. — All rights reserved. Proprietary. Unauthorized use, reproduction, or distribution is strictly prohibited.
