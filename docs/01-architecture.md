# 01 — Homelab Architecture & Design Principles

## Overview & Homelab Philosophy

The goal of this architecture is to build a **rock-solid, easy-to-maintain, and secure** self-hosted environment. Every component is intentionally chosen to provide maximum convenience while keeping security risks minimal.

```text
┌─────────────────────────────────────────────────────────────────────────────────────────┐
│                                     THE BIG PICTURE                                     │
├─────────────────────────────────────────────────────────────────────────────────────────┤
│                                                                                         │
│  [ You on the go ] (Phone/Laptop)             [ Public Visitors / Family ]              │
│          │                                                  │                           │
│          ▼ (Encrypted WireGuard)                            ▼ (HTTPS via Cloudflare)    │
│  ┌───────────────────────┐                        ┌───────────────────────┐             │
│  │     Tailscale VPN     │                        │   Cloudflare Tunnel   │             │
│  │   (Private Access)    │                        │    (Public Access)    │             │
│  └───────────┬───────────┘                        └───────────┬───────────┘             │
│              │                                                │                         │
│              └───────────────────────┬────────────────────────┘                         │
│                                      │                                                  │
│                                      ▼                                                  │
│                        ┌───────────────────────────┐                                    │
│                        │       Ubuntu Server       │                                    │
│                        │     (Base Host / VM)      │                                    │
│                        └─────────────┬─────────────┘                                    │
│                                      │                                                  │
│                        ┌─────────────▼─────────────┐                                    │
│                        │   Docker Engine & Compose │                                    │
│                        │   (Isolated Container OS) │                                    │
│                        └─────────────┬─────────────┘                                    │
│                                      │                                                  │
│       ┌──────────────────────────────┼──────────────────────────────┐                   │
│       │                              │                              │                   │
│ ┌─────▼──────┐                 ┌─────▼──────┐                 ┌─────▼──────┐            │
│ │   CasaOS   │                 │ App Stacks │                 │ Databases  │            │
│ │ Dashboard  │                 │  (Plex,    │                 │(Postgres,  │            │
│ │  (Web UI)  │                 │ Nextcloud) │                 │   Redis)   │            │
│ └────────────┘                 └────────────┘                 └────────────┘            │
└─────────────────────────────────────────────────────────────────────────────────────────┘
```

---

## Core Layers Explained

1. **Operating System Layer (Ubuntu Server LTS):** Provides hardware driver management, system kernel updates, and long-term stability without graphical desktop bloat.
2. **Container Runtime Layer (Docker & Compose):** Every application runs in its own isolated filesystem. This means upgrading an app never breaks another app or the host operating system.
3. **Visual Management Layer (CasaOS):** A web interface on port 80/browser that gives you a visual dashboard of system health, disk space, and an easy one-click app store.
4. **Private Access Layer (Tailscale):** Encrypted private network that lets you securely reach your server, CasaOS, and admin tools from anywhere without opening any router ports.
5. **Public Ingress Layer (Cloudflare Tunnel):** Securely exposes specific public-facing web applications to the world with automated DDoS protection and SSL encryption without port forwarding.
6. **Reverse Proxy Layer (Caddy / Nginx Proxy Manager):** Routes web traffic between domain names (e.g. `media.lan` or `app.example.com`) and specific internal Docker container ports.

---

## Access Comparison: When to Use What

| Feature | Tailscale VPN | Cloudflare Tunnel | Reverse Proxy (Caddy / NPM) |
|---|---|---|---|
| **Audience** | Just you & trusted family | The entire public internet | Local home network or proxy target |
| **Client Requirement** | Must install Tailscale app | Any standard web browser | Any standard web browser |
| **Router Ports Open** | **0 ports open** | **0 ports open** | Ports 80 & 443 (if port-forwarding) |
| **Best For** | SSH, CasaOS, Portainer, Databases, Admin Panels | Personal blogs, public APIs, portfolio sites | Local domain routing, SSL termination |
| **Security Risk** | Minimal (Zero public exposure) | Medium (Protected by Cloudflare WAF/Access) | High if directly exposed to router WAN |

---

## Private vs. Public Service Classification

### 🔒 Strictly Private (Tailscale Only — NEVER Expose to Public Internet)
These services should only ever be accessible via your home LAN or private Tailscale VPN:
- **SSH (Port 22):** Remote command line shell.
- **CasaOS Dashboard (Port 80):** Server control interface.
- **Portainer (Port 9000 / 9443):** Docker container management.
- **Databases:** PostgreSQL (5432), MariaDB/MySQL (3306), Redis (6379), MongoDB (27017).
- **Proxmox Web GUI (Port 8006):** Hypervisor management.
- **Docker Daemon Socket / API (Port 2375 / 2376).**

### 🌐 Publicly Publishable (via Cloudflare Tunnel or Reverse Proxy)
Only publish these services if you need public or family access without requiring Tailscale:
- Personal static website / portfolio
- Self-hosted file drop or Nextcloud public share links
- Public status page (e.g., Uptime Kuma status badge)
- Webhooks for external automations (e.g., GitHub webhooks, Home Assistant integrations)

---

## Standard Port Inventory Reference

Homelab applications typically listen on the following default ports. Avoid conflicts by choosing unique host ports:

| Service | Default Port | Category | Recommended Exposure |
|---|:---:|---|---|
| **CasaOS Web UI** | `80` / `81` | Management | Local / Tailscale |
| **SSH** | `22` | Host Admin | Local / Tailscale |
| **Uptime Kuma** | `3001` | Monitoring | Local / Tailscale (or Cloudflare Status) |
| **Portainer** | `9443` | Docker Admin | Local / Tailscale |
| **Nginx Proxy Manager** | `81` (Admin) / `80` & `443` (Proxy) | Ingress | Admin: Private / 80,443: Local or Public |
| **Caddy** | `80` & `443` | Ingress | Local or Public |
| **Nextcloud** | `8080` | Cloud Storage | Local / Tailscale or Cloudflare Tunnel |
| **Jellyfin / Plex** | `8096` / `32400` | Media Streaming | Local / Tailscale |
| **Vaultwarden** | `8000` | Password Manager | Local / Tailscale or Cloudflare Tunnel |
| **Pi-hole / AdGuard** | `53` (DNS) / `80` / `8080` (Admin) | Local DNS | Local Network Only |
| **Proxmox VE** | `8006` | Hypervisor Admin | Local / Tailscale Only |

---

## Architectural Decision: Bare-Metal Ubuntu vs. Proxmox VE

Choose the foundation that best matches your goals:

### Choose Bare-Metal Ubuntu Server if:
- You have a mini PC or single computer dedicated primarily to Docker containers.
- You want simple setup and zero virtualization overhead.
- You want easy hardware access (e.g. Intel QuickSync hardware transcoding for Plex/Jellyfin or USB devices).

### Choose Proxmox VE if:
- You have 16GB+ RAM and want to run multiple independent operating systems (e.g., Ubuntu Docker VM + Home Assistant OS VM + TrueNAS VM).
- You want instant VM snapshots before trying risky system upgrades.
- You enjoy experimenting with virtualization, VLANs, and clustering.
