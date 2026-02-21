# CLAUDE.md — blackroad-hardware

**This is the source of truth for BlackRoad's physical and cloud hardware fleet.**

## What This Repo Is

The authoritative network map for all BlackRoad infrastructure. If you're an AI agent working in BlackRoad, read `registry.json` to understand every device, `network.json` for topology, and `agents.json` for who runs where.

## Key Files

| File | Contains |
|------|----------|
| `registry.json` | All 22 devices: IPs, MACs, hardware specs, roles, status |
| `network.json` | Subnet config, Tailscale mesh, Cloudflare tunnel, DNS |
| `agents.json` | Agent-to-device mapping, AI models per node, capacity |

## How to Read registry.json

Each device has a unique name (e.g., `cecilia`, `octavia`, `alexandria`). Look up by name to find:
- `ip` — local LAN address (192.168.4.x) or public IP for cloud nodes
- `tailscale` — mesh VPN address (100.x.x.x) for remote access
- `hardware` — physical specs
- `role` — what the device does in the fleet
- `status` — online, offline, sleeping, or disconnected

## When to Update This Repo

- New device joins the network
- Device IP or role changes
- Agent assignment changes
- Tailscale mesh membership changes
- Cloud infrastructure added/removed

## Quick Commands

```bash
# SSH to a Pi
ssh pi@192.168.4.89        # cecilia
ssh pi@192.168.4.38        # octavia
ssh alice@192.168.4.49     # alice

# Via Tailscale (remote)
ssh pi@100.72.180.98       # cecilia-ts
ssh pi@100.66.235.47       # octavia-ts

# Health check all devices
./scripts/discover.sh

# Ping a specific device
ping 192.168.4.89
```

## Proprietary

All content is the exclusive property of BlackRoad OS, Inc.
