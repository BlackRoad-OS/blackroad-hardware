# Connectivity Guide

How to connect to every device in the BlackRoad fleet.

---

## SSH Access (Raspberry Pis)

### Local Network (192.168.4.x)

```bash
ssh pi@192.168.4.89        # cecilia  (Pi 5 + Hailo-8)
ssh pi@192.168.4.38        # octavia  (Pi 5)
ssh alice@192.168.4.49     # alice    (Pi 4) — note: user is "alice"
ssh pi@192.168.4.81        # lucidia  (Pi 5 + Pironman)
ssh pi@192.168.4.82        # aria     (Pi 5)
```

### Tailscale (Remote Access)

Use these IPs when not on the local network:

```bash
ssh pi@100.72.180.98       # cecilia
ssh pi@100.66.235.47       # octavia
ssh alice@100.77.210.18    # alice
ssh pi@100.83.149.86       # lucidia
ssh pi@100.109.14.17       # aria
```

### Cloud Nodes

```bash
ssh root@174.138.44.45     # anastasia (DigitalOcean)
ssh root@159.65.43.12      # gematria  (DigitalOcean)

# Via Tailscale
ssh root@100.94.33.37      # anastasia
ssh root@100.108.132.8     # gematria
```

### SSH Config Shortcuts

Add to `~/.ssh/config` for convenience:

```
Host cecilia
    HostName 192.168.4.89
    User pi

Host cecilia-ts
    HostName 100.72.180.98
    User pi

Host octavia
    HostName 192.168.4.38
    User pi

Host octavia-ts
    HostName 100.66.235.47
    User pi

Host alice
    HostName 192.168.4.49
    User alice

Host alice-ts
    HostName 100.77.210.18
    User alice

Host lucidia
    HostName 192.168.4.81
    User pi

Host aria
    HostName 192.168.4.82
    User pi

Host anastasia
    HostName 174.138.44.45
    User root

Host gematria
    HostName 159.65.43.12
    User root
```

---

## Roku Devices (ECP API)

Both Roku devices expose the External Control Protocol on port 8060.

```bash
# Pandora (Living Room TV)
curl http://192.168.4.26:8060/query/device-info

# Calliope (Bedroom Stick)
curl http://192.168.4.33:8060/query/device-info

# List installed apps
curl http://192.168.4.26:8060/query/apps

# Launch an app (e.g., Netflix = 12)
curl -X POST http://192.168.4.26:8060/launch/12
```

---

## USB Devices (via alexandria)

USB peripherals are attached to the Mac M1 workstation.

### Siren (Sipeed BL808 RISC-V)

```bash
# Serial connection (2Mbaud)
screen /dev/tty.usbmodem* 2000000

# Check USB device
system_profiler SPUSBDataType | grep -A5 "Sipeed"
```

### Lyra (MIDI Interface)

```bash
# List MIDI devices (macOS)
system_profiler SPUSBDataType | grep -A5 "Kalezo"
```

### WaveCube (ESP32)

```bash
# Serial connection (115200 baud)
screen /dev/tty.usbserial* 115200

# Check USB device
system_profiler SPUSBDataType | grep -A5 "CH340"
```

---

## Mobile Devices

### Athena (iPhone/iPad)

- AirPlay: port 7000
- lockdownd: port 62078

---

## Cloudflare Tunnel

The tunnel runs on **cecilia** and exposes local services to the internet:

```bash
# Check tunnel status (on cecilia)
ssh pi@192.168.4.89 "cloudflared tunnel info blackroad"

# Routes
# agent.blackroad.ai  → localhost:8080
# api.blackroad.ai    → localhost:3000
```

---

## Health Check

Run the discover script to ping all registered devices:

```bash
./scripts/discover.sh
```
