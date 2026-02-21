# Network Topology

## Physical Layout

```
                              INTERNET
                                 │
                    ┌────────────▼────────────┐
                    │     Cloudflare Edge      │
                    │  CDN · DNS · WAF · Tunnel│
                    └────────────┬────────────┘
                                 │
            ┌────────────────────┼────────────────────┐
            │                    │                    │
     ┌──────▼──────┐     ┌──────▼──────┐     ┌──────▼──────┐
     │  anastasia  │     │  gematria   │     │  meridian   │
     │ DO Droplet  │     │ DO Droplet  │     │  Xfinity    │
     │ 174.138.44  │     │ 159.65.43   │     │  Gateway    │
     │ edge-compute│     │cloud-oracle │     │ 192.168.4.1 │
     └─────────────┘     └─────────────┘     └──────┬──────┘
                                                     │
                                              ┌──────▼──────┐
                                              │   LAN Switch │
                                              │192.168.4.0/24│
                                              └──────┬──────┘
                          ┌──────────┬───────────────┼───────────────┬──────────┐
                          │          │               │               │          │
                   ┌──────▼──┐ ┌─────▼────┐  ┌──────▼──────┐ ┌─────▼────┐ ┌───▼────┐
                   │alexandria│ │ cecilia  │  │  octavia    │ │  alice   │ │  aria  │
                   │  .28    │ │  .89     │  │  .38        │ │  .49     │ │  .82   │
                   │ Mac M1  │ │Pi5+Hailo │  │  Pi 5       │ │  Pi 4    │ │  Pi 5  │
                   │ CMD CTR │ │ CECE OS  │  │  COMPUTE    │ │  WORKER  │ │HARMONY │
                   └────┬────┘ └──────────┘  └─────────────┘ └──────────┘ └────────┘
                        │
                 ┌──────┼──────┐
                 │      │      │
              [siren] [lyra] [wavecube]
              RISC-V   MIDI   ESP32
```

## Tailscale Mesh Overlay

```
                    ┌─────────────────────────┐
                    │    Tailscale Control     │
                    │      Coordination        │
                    └────────────┬────────────┘
                                 │
         ┌───────────┬───────────┼───────────┬───────────┐
         │           │           │           │           │
    ┌────▼────┐ ┌────▼────┐ ┌───▼────┐ ┌────▼────┐ ┌───▼─────┐
    │cecilia  │ │octavia  │ │ alice  │ │lucidia  │ │  aria   │
    │100.72.  │ │100.66.  │ │100.77. │ │100.83.  │ │100.109. │
    │180.98   │ │235.47   │ │210.18  │ │149.86   │ │14.17    │
    └─────────┘ └─────────┘ └────────┘ └─────────┘ └─────────┘
         │           │
    ┌────▼────┐ ┌────▼────┐
    │anastasia│ │gematria │
    │100.94.  │ │100.108. │
    │33.37    │ │132.8    │
    │DO NYC   │ │DO NYC   │
    └─────────┘ └─────────┘
```

## Subnet Map (192.168.4.0/24)

```
  .1   meridian     (Router)
  .22  ember        (IoT)
  .26  pandora      (TV)
  .27  athena       (Mobile)
  .28  alexandria   (Mac M1)
  .33  calliope     (Streaming)
  .38  octavia      (Pi 5)
  .44  wraith       (Unknown)
  .45  vesper       (Unknown)
  .49  alice        (Pi 4)
  .81  lucidia      (Pi 5)
  .82  aria         (Pi 5)
  .88  phantom      (Mobile)
  .89  cecilia      (Pi 5)
  .90  cortana      (Console)
  .92  specter      (Mobile)
```

## Device Categories

```
  Compute (6)   ████████████████████  alexandria, cecilia, octavia, alice, lucidia, aria
  Cloud (2)     ██████                anastasia, gematria
  Media (3)     █████████             pandora, calliope, cortana
  Mobile (3)    █████████             athena, phantom, specter
  USB (3)       █████████             siren, lyra, wavecube
  IoT (1)       ███                   ember
  Unknown (2)   ██████                wraith, vesper
  Router (1)    ███                   meridian
  Other (1)     ███                   (reserved)
```
