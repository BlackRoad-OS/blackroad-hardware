# blackroad-hardware

> **The authoritative network map for all BlackRoad OS infrastructure.**
>
> Any AI agent working in BlackRoad should read this repo first to understand every device on the network.

---

## Device Fleet (22 devices)

### Compute Nodes (Raspberry Pi + Mac)

| Name | IP | Tailscale | Hardware | Role | Status |
|------|-----|-----------|----------|------|--------|
| **alexandria** | 192.168.4.28 | — | Mac M1 | Command center | Online |
| **cecilia** | 192.168.4.89 | 100.72.180.98 | Pi 5 + Hailo-8 + 500GB NVMe | Primary AI agent (CECE OS) | Online |
| **octavia** | 192.168.4.38 | 100.66.235.47 | Pi 5 | Primary compute | Online |
| **alice** | 192.168.4.49 | 100.77.210.18 | Pi 4 | Worker / coordinator | Online |
| **lucidia** | 192.168.4.81 | 100.83.149.86 | Pi 5 + Pironman + 1TB NVMe | AI inference | Offline |
| **aria** | 192.168.4.82 | 100.109.14.17 | Pi 5 | Data science / harmony | Offline |

### Cloud Nodes (DigitalOcean)

| Name | Public IP | Tailscale | Role | Status |
|------|-----------|-----------|------|--------|
| **anastasia** | 174.138.44.45 | 100.94.33.37 | Edge compute (Shellfish) | Online |
| **gematria** | 159.65.43.12 | 100.108.132.8 | Cloud oracle / API | Online |

### Media & Entertainment

| Name | IP | Hardware | Location | Status |
|------|-----|----------|----------|--------|
| **pandora** | 192.168.4.26 | 65" Roku TV (65R4CX) | Living Room | Online |
| **calliope** | 192.168.4.33 | Roku Streaming Stick Plus | Bedroom | Online |
| **cortana** | 192.168.4.90 | Xbox / Surface | — | Sleeping |

### Mobile Devices

| Name | IP | Hardware | Status |
|------|-----|----------|--------|
| **athena** | 192.168.4.27 | iPhone/iPad (AirPlay) | Online |
| **phantom** | 192.168.4.88 | Phone (privacy MAC) | Online |
| **specter** | 192.168.4.92 | Phone (privacy MAC) | Online |

### USB Peripherals (attached to alexandria)

| Name | Hardware | Vendor | Status |
|------|----------|--------|--------|
| **siren** | Bouffalo BL808 RISC-V | Sipeed | Mass-storage mode |
| **lyra** | USB MIDI interface | Kalezo | Online |
| **wavecube** | ESP32 + touchscreen | QinHeng CH340 | Disconnected |

### IoT & Unknown

| Name | IP | Vendor | Description | Status |
|------|-----|--------|-------------|--------|
| **ember** | 192.168.4.22 | AltoBeam | Smart home IoT | Online |
| **wraith** | 192.168.4.44 | Private | Silent, no open ports | Online |
| **vesper** | 192.168.4.45 | Private | Silent, no open ports | Online |

---

## Network Topology

```
                         INTERNET
                            │
                    ┌───────▼───────┐
                    │   Cloudflare   │  CDN, DNS, Tunnel
                    │   (QUIC)       │  tunnel: blackroad
                    └───────┬───────┘
                            │
          ┌─────────────────┼─────────────────┐
          │                 │                 │
   ┌──────▼──────┐  ┌──────▼──────┐  ┌───────▼──────┐
   │  anastasia  │  │  gematria   │  │   meridian   │
   │ 174.138.44  │  │ 159.65.43   │  │ 192.168.4.1  │
   │  DO droplet │  │  DO droplet │  │    Router     │
   └─────────────┘  └─────────────┘  └───────┬──────┘
                                              │
                              ┌────────────┬──┴──┬────────────┐
                              │            │     │            │
                       ┌──────▼──┐  ┌──────▼─┐ ┌─▼──────┐ ┌──▼──────┐
                       │alexandria│  │cecilia │ │octavia │ │ alice   │
                       │  .28    │  │  .89   │ │  .38   │ │  .49    │
                       │  Mac M1 │  │Pi5+H8  │ │  Pi 5  │ │  Pi 4   │
                       └────┬────┘  └────────┘ └────────┘ └─────────┘
                            │
                     ┌──────┼──────┐
                     │      │      │
                  [siren] [lyra] [wavecube]
                   USB     USB     USB
```

### Tailscale Mesh (7 nodes)

All compute and cloud nodes connected via Tailscale for remote access:

```
  cecilia ──── 100.72.180.98
  octavia ──── 100.66.235.47
    alice ──── 100.77.210.18
  lucidia ──── 100.83.149.86
     aria ──── 100.109.14.17
anastasia ──── 100.94.33.37   (DigitalOcean)
 gematria ──── 100.108.132.8  (DigitalOcean)
```

### Cloudflare Tunnel

| Property | Value |
|----------|-------|
| Tunnel ID | `52915859-da18-4aa6-add5-7bd9fcac2e0b` |
| Protocol | QUIC |
| Running on | cecilia (192.168.4.89) |
| Edge | dfw08 (Dallas) |
| Routes | `agent.blackroad.ai` → :8080, `api.blackroad.ai` → :3000 |

---

## Agent Assignments

| Device | Named Agent | Specialization |
|--------|-------------|----------------|
| cecilia | CECE | CECE OS, 68 sovereign apps, Hailo-8 edge AI |
| octavia | OCTAVIA | ML acceleration, 22,500 agent capacity |
| alice | ALICE | Agent coordination, distributed systems |
| lucidia | LUCIDIA | Multi-agent orchestration, NLU |
| aria | ARIA | ML pipelines, data science |
| anastasia | SHELLFISH | Edge compute, failover |
| alexandria | — | Human orchestrator (Alexa) |

### Total AI Compute

| Metric | Value |
|--------|-------|
| Total agent capacity | 30,000 |
| AI research agents | 12,592 |
| Code deploy agents | 8,407 |
| Infrastructure agents | 5,401 |
| Monitoring agents | 3,600 |
| Edge AI (Hailo-8) | 26 TOPS |

---

## How to Connect

```bash
# Local SSH
ssh pi@192.168.4.89        # cecilia
ssh pi@192.168.4.38        # octavia
ssh alice@192.168.4.49     # alice

# Tailscale (remote)
ssh pi@100.72.180.98       # cecilia
ssh pi@100.66.235.47       # octavia

# Cloud
ssh root@174.138.44.45     # anastasia
ssh root@159.65.43.12      # gematria

# Health check
./scripts/discover.sh
```

---

## File Index

| File | Description |
|------|-------------|
| `registry.json` | Master device registry (22 devices, full specs) |
| `network.json` | Network topology, Tailscale mesh, tunnel config |
| `agents.json` | Agent-to-device mapping, AI models, capacity |
| `docs/TOPOLOGY.md` | Visual network diagrams |
| `docs/CONNECTIVITY.md` | Connection guide (SSH, Tailscale, USB) |
| `scripts/discover.sh` | Network discovery and health check |
| `CLAUDE.md` | AI agent guidance |

---

**Proprietary. (c) 2025-2026 BlackRoad OS, Inc. All rights reserved.**
