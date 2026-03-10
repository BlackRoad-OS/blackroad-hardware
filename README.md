# BlackRoad Hardware

> The AI-powered compute fleet behind BlackRoad OS — live, distributed, and always on.

[![CI](https://github.com/BlackRoad-OS/blackroad-hardware/actions/workflows/ci.yml/badge.svg)](https://github.com/BlackRoad-OS/blackroad-hardware/actions/workflows/ci.yml)
[![License: Proprietary](https://img.shields.io/badge/license-Proprietary-red.svg)](LICENSE)

---

## 🚀 Live Portals — Click to Explore

Everything runs live. No setup required. Just click.

| What you get | Link |
|---|---|
| 🌐 **Main Site** | [blackroad.io](https://blackroad.io) |
| 📡 **API** | [api.blackroad.io](https://api.blackroad.io) |
| 🤖 **Agents** | [agents.blackroad.io](https://agents.blackroad.io) |
| 📊 **Dashboard** | [dashboard.blackroad.io](https://dashboard.blackroad.io) |
| ✅ **Status** | [status.blackroad.io](https://status.blackroad.io) |
| 📖 **Docs** | [docs.blackroad.io](https://docs.blackroad.io) |
| 📈 **Monitoring** | [monitoring.blackroad.io](https://monitoring.blackroad.io) |

---

## ✨ What Is This?

BlackRoad runs on a fleet of real computers — Raspberry Pis, cloud servers, an AI accelerator, and more — all connected and managed from this registry.

Think of it as the **control room** for everything BlackRoad runs on.

- **22 devices** registered and tracked
- **67.8 TOPS** of AI compute (two Hailo-8 chips + Apple M1 Neural Engine)
- **30,000 agent capacity** across the Pi cluster
- **Always-on** via Cloudflare + WireGuard mesh

---

## 🖥️ The Fleet at a Glance

### Raspberry Pi Cluster (home base)

| Name | What it does |
|------|-------------|
| **cecilia** | Main AI brain — runs Hailo-8 accelerator + orchestration |
| **octavia** | AI inference, auth, DNS |
| **lucidia** | Message bus (NATS), LLM inference, Hailo-8 |
| **aria** | API services and compute |
| **alice** | Gateway and development node |

### Cloud Nodes

| Name | Where | What it does |
|------|-------|-------------|
| **codex-infinity** | DigitalOcean NYC | Codex server, oracle |
| **shellfish** | DigitalOcean NYC | WireGuard hub, cloud infra |

### AI Accelerators

| Device | Chip | Performance |
|--------|------|------------|
| cecilia | Hailo-8 M.2 | 26 TOPS |
| lucidia | Hailo-8 M.2 | 26 TOPS |
| alexandria | Apple M1 Neural Engine | 15.8 TOPS |

### Also in the fleet

- **Meta Quest 2** (andromeda) — XR interface and spatial agent
- **Jetson Orin Nano** — 40 TOPS edge GPU
- **21-node ESP32 LoRa mesh** — IoT sensor array

---

## 🌐 How the Network Works

All public traffic goes through Cloudflare — no direct access to the home network.

```
You → Cloudflare → Tunnel → Pi Cluster (your home)
```

Internal nodes talk to each other over WireGuard (encrypted, zero overhead).

See [`network/topology.md`](network/topology.md) for the full diagram.

---

## 📁 Key Files

| File | What's in it |
|------|-------------|
| [`fleet-registry.yaml`](fleet-registry.yaml) | Every device — specs, IPs, roles |
| [`network.json`](network.json) | Network topology and Cloudflare config |
| [`agents.json`](agents.json) | Which AI models run where |
| [`network/services-map.md`](network/services-map.md) | Every port and service, live-verified |
| [`network/topology.md`](network/topology.md) | Visual network diagram |
| [`devices/raspberry-pi.md`](devices/raspberry-pi.md) | Pi cluster details |
| [`devices/xr-headsets.md`](devices/xr-headsets.md) | Meta Quest 2 setup |
| [`accelerators/ai-compute.md`](accelerators/ai-compute.md) | Hailo-8 and AI accelerator docs |

---

## 🔧 For Developers

<details>
<summary>SSH into the fleet</summary>

```bash
ssh pi@192.168.4.89        # cecilia
ssh pi@192.168.4.38        # octavia
ssh alice@192.168.4.49     # alice
```

</details>

<details>
<summary>Fleet health check</summary>

```bash
./scripts/fleet-health-check.sh
```

</details>

<details>
<summary>npm package</summary>

```bash
npm install @blackroad/hardware-registry
```

```js
const { getDevice, listFleet } = require('@blackroad/hardware-registry');
const cecilia = getDevice('cecilia');
console.log(cecilia.ip_local);   // '192.168.4.89'
```

</details>

<details>
<summary>Repository structure</summary>

```
blackroad-hardware/
├── fleet-registry.yaml       # All 22 devices (source of truth)
├── registry.json             # JSON device registry
├── network.json              # Network topology
├── agents.json               # Agent-to-device mapping
├── devices/                  # Per-device-type docs
├── accelerators/             # AI accelerator configs
├── network/                  # Network diagrams
├── docs/                     # Hardware documentation
├── projects/wavecube/        # WaveQube DLP projector
└── scripts/                  # Fleet management scripts
```

</details>

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for branch naming, commit style, and PR requirements.

All contributions are proprietary work-for-hire owned exclusively by BlackRoad OS, Inc.

---

## License

© BlackRoad OS, Inc. — All rights reserved. Proprietary. Unauthorized use, reproduction, or distribution is strictly prohibited.

