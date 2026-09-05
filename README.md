# Ubuntu Homelab / Self-Hosted Server Documentation

![Platform](https://img.shields.io/badge/platform-Ubuntu%20Server-E95420?logo=ubuntu&logoColor=white)
![Docker](https://img.shields.io/badge/container-Docker%20%2F%20Compose-2496ED?logo=docker&logoColor=white)
![Tailscale](https://img.shields.io/badge/VPN-Tailscale-242938?logo=tailscale&logoColor=white)
![License](https://img.shields.io/badge/license-MIT-green)
![Status](https://img.shields.io/badge/status-active-brightgreen)

A complete, copy-paste-ready documentation set for building a self-hosted Ubuntu server: Docker, Docker Compose, CasaOS, Tailscale, optional Proxmox virtualization, Tailwind CSS, and secure remote/public connectivity via Cloudflare Tunnel.

Written so a new machine can go from a blank Ubuntu install to a hardened, monitored, backed-up homelab by working through the numbered guides in `docs/`.

> **⚠️ Before you start:** This repository is a documentation and deployment **reference**, not a finished server. Replace every value marked `<CHANGE-ME>` before using it. **Never commit** passwords, API tokens, Tailscale auth keys, Cloudflare tokens, SSH private keys, `.env` files containing secrets, or any other credentials — see [Secret policy](#secret-policy).

## Table of contents

- [Who this is for](#who-this-is-for)
- [Repository structure](#repository-structure)
- [Prerequisites](#prerequisites)
- [Architecture](#architecture)
- [Recommended layering](#recommended-layering)
- [Documentation index](#documentation-index)
- [Quick start](#quick-start)
- [Getting this repo onto your server / GitHub](#getting-this-repo-onto-your-server--github)
- [Official documentation](#official-documentation)
- [Secret policy](#secret-policy)
- [Contributing](#contributing)
- [License](#license)

## Who this is for

Anyone setting up (or documenting) a personal Linux server: homelab hobbyists, students self-hosting a few apps, or anyone who wants a repeatable, version-controlled record of how their server is configured. No prior Docker/Linux-admin experience is assumed — each guide includes the exact commands to run.

## Repository structure

```text
ubuntu-homelab-documentation/
├── README.md                  ← you are here
├── LICENSE
├── .gitignore                 ← keeps secrets and local data out of Git
├── docs/                      ← numbered guides, read in order
│   ├── README.md              ← documentation index
│   └── 00-checklist.md … 19-disaster-recovery.md
├── docker/                    ← ready-to-copy Compose stacks
│   ├── .env.example           ← template — copy to .env, never commit .env
│   ├── cloudflare-compose.yml
│   ├── tailscale-compose.example.yml
│   └── monitoring-compose.example.yml
└── scripts/
    └── server-inventory.sh    ← dumps host/Docker/Tailscale info for support/debugging
```

## Prerequisites

- A machine (physical or VM) that can run **Ubuntu Server 22.04 LTS or newer**
- Local network access to it (keyboard/monitor, or SSH once installed)
- A GitHub (or other Git host) account, if you want to publish/version this repo
- Optional, only if you use those sections: a domain name (for Cloudflare Tunnel/DNS) and a Tailscale account (free tier is enough)

## Architecture

```text
                         Internet
                            |
                 +----------+-----------+
                 |                      |
          Cloudflare Tunnel          Tailscale
          (public services)       (private VPN)
                 |                      |
                 +----------+-----------+
                            |
                     Server / VM
                            |
              +-------------+-------------+
              |                           |
         CasaOS / Docker             Optional Proxmox
              |                     (bare-metal layer)
              |
       +------+------------------------------+
       |      |       |        |             |
    Proxy  Apps   Monitoring  DNS/VPN     Databases
       |
  Web services
       |
  Tailwind frontend / APIs
```

## Recommended layering

Choose **one** of these base architectures:

### Option A — Ubuntu directly on the machine
Use this when the machine is primarily a Docker/self-hosted server.

`Hardware -> Ubuntu Server -> Docker -> CasaOS/apps -> Tailscale/Cloudflare`

### Option B — Proxmox as the bare-metal hypervisor
Use this when you want multiple isolated VMs/LXCs.

`Hardware -> Proxmox VE -> Ubuntu VM(s) -> Docker/CasaOS -> Apps`

Do **not** install Proxmox on top of an Ubuntu installation unless you are intentionally following a supported advanced setup. Proxmox VE is normally installed as a bare-metal hypervisor.

## Documentation index

Start at `00` and work down for a first build, or jump straight to any page as a reference. See the full table with descriptions in [`docs/README.md`](docs/README.md).

1. [Architecture](docs/01-architecture.md) · 2. [Ubuntu Server](docs/02-ubuntu-server.md) · 3. [Hardening](docs/03-hardening.md) · 4. [Docker Engine](docs/04-docker.md) · 5. [Docker Compose](docs/05-compose.md)
6. [CasaOS](docs/06-casaos.md) · 7. [Tailscale VPN](docs/07-tailscale.md) · 8. [Cloudflare Tunnel](docs/08-cloudflare-tunnel.md) · 9. [Reverse proxy](docs/09-reverse-proxy.md) · 10. [DNS](docs/10-dns.md)
11. [Storage & backups](docs/11-storage-backups.md) · 12. [Monitoring](docs/12-monitoring.md) · 13. [Proxmox VE](docs/13-proxmox.md) · 14. [Tailwind CSS](docs/14-tailwind.md) · 15. [Container catalog](docs/15-container-catalog.md)
16. [Security checklist](docs/16-security-checklist.md) · 17. [Troubleshooting](docs/17-troubleshooting.md) · 18. [Command reference](docs/18-commands.md) · 19. [Disaster recovery](docs/19-disaster-recovery.md)

## Quick start

```bash
sudo apt update && sudo apt full-upgrade -y
sudo apt install -y curl git ca-certificates unzip htop vim ufw
```

Install Docker from the official repository, then verify:

```bash
docker --version
docker compose version
sudo systemctl status docker
```

Install Tailscale:

```bash
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up
tailscale status
tailscale ip
```

Then install/configure CasaOS if desired, deploy your Compose stacks, configure private access through Tailscale, and only publish services externally when there is a clear requirement.

## Getting this repo onto your server / GitHub

**Option A — clone this repo onto your server** (if you already pushed it to GitHub):

```bash
git clone https://github.com/<USERNAME>/<REPOSITORY>.git
cd <REPOSITORY>
cp docker/.env.example docker/.env   # then edit docker/.env with your real values
```

**Option B — publish this folder to a new GitHub repo for the first time:**

```bash
cd ubuntu-homelab-documentation
git init
git add .
git status                          # confirm no .env or secret files are staged
git commit -m "Initial commit: Ubuntu homelab documentation"
git branch -M main
git remote add origin https://github.com/<USERNAME>/<REPOSITORY>.git
git push -u origin main
```

**Keeping it updated as your setup evolves:**

```bash
git add .
git commit -m "Describe what changed, e.g. add monitoring stack"
git push
```

## Official documentation

- Ubuntu Server: https://ubuntu.com/server/docs/
- Ubuntu installation: https://ubuntu.com/server/docs/tutorial/basic-installation/
- Docker Engine: https://docs.docker.com/engine/install/ubuntu/
- Docker Compose: https://docs.docker.com/compose/
- Tailscale Linux: https://tailscale.com/docs/install/linux
- Tailscale Docker: https://tailscale.com/docs/features/containers/docker
- Cloudflare Tunnel: https://developers.cloudflare.com/tunnel/
- Proxmox VE: https://www.proxmox.com/en/products/proxmox-virtual-environment/get-started
- Tailwind CSS: https://tailwindcss.com/docs/installation/tailwind-cli
- CasaOS: https://casaos.io/

## Secret policy

The repository should contain templates, not credentials.

```text
.env
*.pem
*.key
id_rsa
id_ed25519
tailscale-authkey*
cloudflare-token*
secrets/
```

Use `.env.example` for documented variable names and keep the real `.env` out of Git.

If you ever commit a secret by mistake, rotate/revoke that credential immediately — removing it from a later commit does not remove it from Git history.

## Contributing

This started as one person's homelab reference, but fixes and additions are welcome:

1. Fork the repo and create a branch: `git checkout -b fix/typo-in-docker-doc`
2. Make your change and keep secrets/real hostnames out of it
3. Open a pull request describing what you changed and why

Small doc fixes, additional container recipes, and corrections to commands are all useful contributions.

## License

Released under the [MIT License](LICENSE) — use, modify, and share freely, with no warranty. Replace the copyright name in `LICENSE` with your own if you fork this.
