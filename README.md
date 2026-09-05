# Ubuntu Homelab / Self-Hosted Server Documentation

![Platform](https://img.shields.io/badge/platform-Ubuntu%20Server-E95420?logo=ubuntu&logoColor=white)
![Docker](https://img.shields.io/badge/container-Docker%20%2F%20Compose-2496ED?logo=docker&logoColor=white)
![Tailscale](https://img.shields.io/badge/VPN-Tailscale-242938?logo=tailscale&logoColor=white)
![License](https://img.shields.io/badge/license-MIT-green)
![Status](https://img.shields.io/badge/status-active-brightgreen)

A complete, copy-paste-ready, consumer-friendly documentation set for building a self-hosted Ubuntu server: Docker, Docker Compose, CasaOS, Tailscale, optional Proxmox virtualization, Tailwind CSS, and secure remote/public connectivity via Cloudflare Tunnel.

Written so a new machine can go from a blank Ubuntu install to a hardened, monitored, backed-up homelab by working through the numbered guides in `docs/`.

> **⚠️ Before you start:** This repository is a documentation and deployment **reference**, not a finished server. Replace every value marked `<CHANGE-ME>` before using it. **Never commit** passwords, API tokens, Tailscale auth keys, Cloudflare tokens, SSH private keys, `.env` files containing secrets, or any other credentials — see [Secret policy](#secret-policy).

---

## Table of contents

- [Who this is for](#who-this-is-for)
- [Key concepts in plain English](#key-concepts-in-plain-english)
- [Hardware sizing guide](#hardware-sizing-guide)
- [Repository structure](#repository-structure)
- [Prerequisites](#prerequisites)
- [Architecture](#architecture)
- [Recommended layering](#recommended-layering)
- [Setup roadmap & step-by-step phases](#setup-roadmap--step-by-step-phases)
- [Documentation index](#documentation-index)
- [Quick start](#quick-start)
- [Getting this repo onto your server / GitHub](#getting-this-repo-onto-your-server--github)
- [Official documentation](#official-documentation)
- [Secret policy](#secret-policy)
- [Contributing](#contributing)
- [License](#license)

---

## Who this is for

Anyone setting up (or documenting) a personal Linux server: homelab hobbyists, students self-hosting a few apps, media hoarders, or developers who want a repeatable, version-controlled record of how their server is configured. No prior Docker or Linux sysadmin experience is assumed — each guide breaks down concepts in plain terms and provides the exact copy-paste commands to run.

---

## Key concepts in plain English

If you are new to self-hosting, here is what each technology does in your homelab:

| Technology | What it is | Why you want it |
|---|---|---|
| **Ubuntu Server** | A free, enterprise-grade Linux operating system without a resource-heavy desktop GUI. | Rock-solid foundation that runs 24/7 using minimal RAM and CPU. |
| **Docker & Compose** | A system to package and run software inside isolated containers using simple config files (`docker-compose.yml`). | Install apps (Plex, Nextcloud, Uptime Kuma) without messing up your host operating system or dealing with conflicting dependencies. |
| **CasaOS** | A clean, modern web dashboard for managing your server and Docker apps. | Gives you an App Store feel, file manager, and system resource graphs from your browser without needing terminal commands for daily tasks. |
| **Tailscale** | A zero-config private mesh VPN based on WireGuard. | Access your server, files, and apps from your phone or laptop anywhere in the world securely **without port-forwarding or exposing anything to hackers**. |
| **Cloudflare Tunnel** | An encrypted outbound connection that exposes selected web apps to the public internet. | Host a public website or blog securely behind Cloudflare's DDoS protection without opening firewall ports on your home router. |
| **Proxmox VE** | A bare-metal virtualization platform (optional). | Turn a single physical machine into multiple independent virtual machines (VMs) and lightweight containers (LXCs) with instant snapshots and backups. |

---

## Hardware sizing guide

You do not need enterprise rack servers to run a fantastic homelab. Here are typical hardware tiers:

```text
┌──────────────────────────────────────────────────────────────────────────────────┐
│  Tier 1: Starter / Mini PC ($80 - $200)                                          │
│  • Examples: Beelink, Intel N100/N95, Used Dell OptiPlex Micro / Lenovo Tiny     │
│  • Specs: 4 cores, 8GB-16GB RAM, 256GB-512GB NVMe SSD (10-15W power draw)       │
│  • Great for: Docker, CasaOS, Tailscale, Pi-hole, Uptime Kuma, Home Assistant    │
├──────────────────────────────────────────────────────────────────────────────────┤
│  Tier 2: Mid-Range All-Rounder ($200 - $500)                                     │
│  • Examples: Custom Mini-ITX build, Minisforum, HP EliteDesk SFF (Intel i5/AMD)  │
│  • Specs: 6-8 cores, 16GB-32GB RAM, 1TB NVMe + SATA HDDs for bulk media         │
│  • Great for: Proxmox VMs, Jellyfin/Plex transcoding, Nextcloud, lightweight AI   │
├──────────────────────────────────────────────────────────────────────────────────┤
│  Tier 3: Power User / Storage Heavy ($500+)                                      │
│  • Examples: Custom tower with multiple 3.5" drive bays, used enterprise gear    │
│  • Specs: 8+ cores, 64GB+ RAM, ZFS storage pool with multiple HDDs               │
│  • Great for: Multi-VM Proxmox clusters, large NAS arrays, LLMs, heavy databases │
└──────────────────────────────────────────────────────────────────────────────────┘
```

> [!TIP]
> **Power Efficiency Tip:** Mini PCs with Intel N100 or 8th-gen+ Intel Core processors consume very little power (under 15 Watts at idle) and feature Intel QuickSync for hardware-accelerated video streaming.

---

## Repository structure

```text
ubuntu-homelab-documentation/
├── README.md                  ← you are here (high-level overview & quick start)
├── LICENSE                    ← MIT License
├── .gitignore                 ← keeps secrets and local data out of Git
├── docs/                      ← numbered step-by-step guides, read in order
│   ├── README.md              ← documentation index with time estimates
│   ├── 00-checklist.md        ← interactive pre-flight and deployment checklist
│   ├── 01-architecture.md     ← network model, layering decisions, service naming
│   ├── 02-ubuntu-server.md    ← step-by-step base OS installation & disk sizing
│   ├── 03-hardening.md        ← users, SSH keys, UFW firewall, automatic updates
│   ├── 04-docker.md           ← installing and configuring Docker Engine & daemon
│   ├── 05-compose.md          ← Docker Compose directory layout and best practices
│   ├── 06-casaos.md           ← installing and using the CasaOS web management UI
│   ├── 07-tailscale.md        ← private VPN access, MagicDNS, and Tailscale SSH
│   ├── 08-cloudflare-tunnel.md← publishing selected public apps securely
│   ├── 09-reverse-proxy.md    ← Caddy, Nginx Proxy Manager, and TLS termination
│   ├── 10-dns.md              ← local DNS (Pi-hole), MagicDNS, and public DNS
│   ├── 11-storage-backups.md  ← persistent storage structure and 3-2-1 backup strategy
│   ├── 12-monitoring.md       ← Uptime Kuma, system health, and update workflows
│   ├── 13-proxmox.md          ← optional bare-metal hypervisor installation & VMs
│   ├── 14-tailwind.md         ← Tailwind CSS frontend styling for hosted web apps
│   ├── 15-container-catalog.md← reference catalog of popular homelab containers
│   ├── 16-security-checklist.md← pre-flight security and leak-prevention audit
│   ├── 17-troubleshooting.md  ← common issues, diagnostic commands, and fixes
│   ├── 18-commands.md         ← organized copy-paste terminal cheat sheet
│   └── 19-disaster-recovery.md← 30-minute full recovery runbook
├── docker/                    ← ready-to-copy Compose stacks
│   ├── .env.example           ← template — copy to .env, never commit .env
│   ├── cloudflare-compose.yml ← Cloudflare Tunnel compose stack
│   ├── tailscale-compose.example.yml ← Tailscale container compose stack
│   └── monitoring-compose.example.yml ← Uptime Kuma monitoring stack
└── scripts/
    └── server-inventory.sh    ← dumps host/Docker/Tailscale info for support/debugging
```

---

## Prerequisites

- **A target machine:** Physical PC/laptop/server or VM capable of running **Ubuntu Server 24.04 / 22.04 LTS** (x86_64 / amd64 or ARM64).
- **A USB flash drive (4GB+):** For flashing the Ubuntu installer image.
- **Local network access:** Ethernet cable to your router (preferred) or Wi-Fi, plus a keyboard and display for initial setup.
- **Client computer:** Your regular Mac, Windows, or Linux laptop for SSH and web dashboard access.
- **Git host account:** A free account on GitHub/GitLab to version-control your server configuration.
- **Optional accounts:**
  - [Tailscale](https://tailscale.com) (free tier allows up to 100 devices and 3 users).
  - [Cloudflare](https://cloudflare.com) (free account + custom domain if you wish to host public services via Cloudflare Tunnel).

---

## Architecture

```text
                                  ┌────────────────────────┐
                                  │        Internet        │
                                  └───────────┬────────────┘
                                              │
                         ┌────────────────────┴───────────────────┐
                         │                                        │
           ┌─────────────▼────────────┐             ┌─────────────▼────────────┐
           │    Cloudflare Tunnel     │             │      Tailscale Mesh      │
           │ (Public Encrypted Ingress│             │  (Private Encrypted VPN  │
           │   No open inbound ports) │             │    Zero open ports)      │
           └─────────────┬────────────┘             └─────────────┬────────────┘
                         │                                        │
                         └────────────────────┬───────────────────┘
                                              │
                                    ┌─────────▼──────────┐
                                    │    Host Machine    │
                                    │   (Ubuntu Server)  │
                                    └─────────┬──────────┘
                                              │
                         ┌────────────────────┴───────────────────┐
                         │                                        │
           ┌─────────────▼────────────┐             ┌─────────────▼────────────┐
           │    CasaOS Web Manager    │             │   Docker Engine Runtime  │
           │  (UI Dashboard on :80)   │             │  (Isolated Containers)   │
           └─────────────┬────────────┘             └─────────────┬────────────┘
                         │                                        │
      ┌──────────────────┴────────────────────────────────────────┴──────────────────┐
      │                                                                              │
┌─────▼───────┐        ┌─────────────┐        ┌──────────────┐        ┌──────────────▼─────┐
│  Reverse    │        │ Application │        │  Monitoring  │        │ Isolated Database  │
│  Proxy      │        │ Containers  │        │ (Uptime Kuma)│        │ (PostgreSQL/Redis) │
│(Caddy/NPM)  │        │ (Nextcloud) │        │              │        │ (Internal network) │
└─────────────┘        └─────────────┘        └──────────────┘        └────────────────────┘
```

---

## Recommended layering

Choose **one** of these base architectures depending on your needs:

### Option A — Ubuntu directly on bare metal (Recommended for Beginners & Single-Server Homelabs)
Use this when your machine is dedicated to running Docker containers and self-hosted apps.

$$\text{Hardware} \longrightarrow \text{Ubuntu Server} \longrightarrow \text{Docker Engine} \longrightarrow \text{CasaOS / Apps} \longrightarrow \text{Tailscale / Cloudflare}$$

- **Pros:** Lowest RAM/CPU overhead, simplest setup, easiest hardware passthrough (GPU/Intel QuickSync).
- **Cons:** Running a second full OS requires rebuilding or nested virtualization.

### Option B — Proxmox VE as the bare-metal hypervisor (For Multi-OS & Lab Experimenters)
Use this when you want to run multiple independent VMs (e.g., Ubuntu Docker VM, Home Assistant OS VM, TrueNAS VM, Windows test VM).

$$\text{Hardware} \longrightarrow \text{Proxmox VE} \longrightarrow \text{Ubuntu VM(s)} \longrightarrow \text{Docker / CasaOS} \longrightarrow \text{Apps}$$

- **Pros:** Full VM isolation, instant snapshots before updates, web-based VM management.
- **Cons:** Slight RAM/CPU overhead, additional virtualization layer to configure.

> [!IMPORTANT]
> Do **not** install Proxmox on top of an existing Ubuntu desktop/server install. Proxmox VE is installed directly onto bare metal via its own official ISO.

---

## Setup roadmap & step-by-step phases

Follow this simple phased order to build your homelab from scratch:

```text
Phase 1: Hardware & OS Install       → [docs/02-ubuntu-server.md]
   │  Flash ISO, install Ubuntu Server, size NVMe LVM disk, get IP address.
   ▼
Phase 2: Security & Hardening        → [docs/03-hardening.md]
   │  Create non-root sudo user, setup SSH key login, enable UFW firewall.
   ▼
Phase 3: Docker & Compose Engine     → [docs/04-docker.md] & [docs/05-compose.md]
   │  Install official Docker Engine, configure /srv/docker storage structure.
   ▼
Phase 4: Management UI & Private VPN → [docs/06-casaos.md] & [docs/07-tailscale.md]
   │  Install CasaOS dashboard, connect Tailscale for secure remote access.
   ▼
Phase 5: Public Access & Networking  → [docs/08-cloudflare-tunnel.md] & [docs/09-reverse-proxy.md]
   │  (Optional) Connect Cloudflare Tunnel for public services with custom domain.
   ▼
Phase 6: Apps, Monitoring & Backups  → [docs/11-storage-backups.md] & [docs/12-monitoring.md]
      Deploy your favorite apps, configure automated backups & uptime alerts!
```

---

## Documentation index

Start at `00` and work down for a first build, or jump straight to any page as a reference. See the full table with descriptions and time estimates in [`docs/README.md`](docs/README.md).

1. [Architecture](docs/01-architecture.md) · 2. [Ubuntu Server](docs/02-ubuntu-server.md) · 3. [Hardening](docs/03-hardening.md) · 4. [Docker Engine](docs/04-docker.md) · 5. [Docker Compose](docs/05-compose.md)
6. [CasaOS](docs/06-casaos.md) · 7. [Tailscale VPN](docs/07-tailscale.md) · 8. [Cloudflare Tunnel](docs/08-cloudflare-tunnel.md) · 9. [Reverse proxy](docs/09-reverse-proxy.md) · 10. [DNS](docs/10-dns.md)
11. [Storage & backups](docs/11-storage-backups.md) · 12. [Monitoring](docs/12-monitoring.md) · 13. [Proxmox VE](docs/13-proxmox.md) · 14. [Tailwind CSS](docs/14-tailwind.md) · 15. [Container catalog](docs/15-container-catalog.md)
16. [Security checklist](docs/16-security-checklist.md) · 17. [Troubleshooting](docs/17-troubleshooting.md) · 18. [Command reference](docs/18-commands.md) · 19. [Disaster recovery](docs/19-disaster-recovery.md)

---

## Quick start

Here is the condensed sequence of commands to get an Ubuntu server updated, containerized, and secured with Tailscale:

### 1. Update the base system and install essentials
```bash
sudo apt update && sudo apt full-upgrade -y
sudo apt install -y curl wget git ca-certificates unzip htop vim ufw jq tree
```

### 2. Install official Docker Engine & Compose
```bash
# Add Docker GPG key
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add repository
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

# Install packages
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Allow current user to run Docker without sudo
sudo usermod -aG docker $USER
```

### 3. Verify Docker
```bash
docker --version
docker compose version
sudo docker run --rm hello-world
```

### 4. Install Tailscale for secure remote access
```bash
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up
tailscale status
tailscale ip
```

### 5. (Optional) Install CasaOS Web Management Dashboard
```bash
curl -fsSL https://get.casaos.io | sudo bash
```
Open your browser and navigate to `http://<YOUR-SERVER-IP>` to complete the welcome wizard.

---

## Getting this repo onto your server / GitHub

### Option A — Clone this repo onto your server (Recommended if you have a GitHub copy)
```bash
git clone https://github.com/<USERNAME>/<REPOSITORY>.git ~/ubuntu-homelab
cd ~/ubuntu-homelab
cp docker/.env.example docker/.env   # Edit docker/.env with your real values (nano docker/.env)
```

### Option B — Publish this folder to a new private GitHub repo:
```bash
cd ubuntu-homelab-documentation
git init
git add .
git status                          # Confirm NO .env or secret files are staged!
git commit -m "Initial commit: Ubuntu homelab documentation"
git branch -M main
git remote add origin https://github.com/<USERNAME>/<REPOSITORY>.git
git push -u origin main
```

### Keeping it updated as your setup evolves:
```bash
git add .
git commit -m "Describe what changed, e.g. add monitoring stack"
git push
```

---

## Official documentation

- **Ubuntu Server:** [https://ubuntu.com/server/docs/](https://ubuntu.com/server/docs/)
- **Ubuntu Installation Tutorial:** [https://ubuntu.com/server/docs/tutorial/basic-installation/](https://ubuntu.com/server/docs/tutorial/basic-installation/)
- **Docker Engine on Ubuntu:** [https://docs.docker.com/engine/install/ubuntu/](https://docs.docker.com/engine/install/ubuntu/)
- **Docker Compose:** [https://docs.docker.com/compose/](https://docs.docker.com/compose/)
- **Tailscale Linux:** [https://tailscale.com/docs/install/linux](https://tailscale.com/docs/install/linux)
- **Tailscale Docker:** [https://tailscale.com/docs/features/containers/docker](https://tailscale.com/docs/features/containers/docker)
- **Cloudflare Tunnel:** [https://developers.cloudflare.com/tunnel/](https://developers.cloudflare.com/tunnel/)
- **Proxmox VE Getting Started:** [https://www.proxmox.com/en/products/proxmox-virtual-environment/get-started](https://www.proxmox.com/en/products/proxmox-virtual-environment/get-started)
- **CasaOS:** [https://casaos.io/](https://casaos.io/)
- **Tailwind CSS CLI:** [https://tailwindcss.com/docs/installation/tailwind-cli](https://tailwindcss.com/docs/installation/tailwind-cli)

---

## Secret policy

The repository is designed to store configuration **templates**, never sensitive credentials.

```text
Ignored from Git (via .gitignore):
├── .env
├── *.pem / *.key / *.crt
├── id_rsa / id_ed25519
├── tailscale-authkey*
├── cloudflare-token*
└── secrets/
```

- Always use `.env.example` as a template and keep the active `.env` file untracked.
- If you accidentally commit a credential or token to Git, **rotate and revoke it immediately** at the provider. Simply deleting it in a subsequent commit leaves the credential exposed in your Git history.

---

## Contributing

This started as a personal homelab reference, but improvements, new container templates, and doc fixes are welcome!

1. Fork the repo and create your feature branch: `git checkout -b fix/clearer-ufw-guide`
2. Make your improvements and verify that no real secrets or internal hostnames are staged
3. Open a Pull Request describing your changes and testing notes

---

## License

Released under the [MIT License](LICENSE) — use, modify, and share freely with no warranty.
