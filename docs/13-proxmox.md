# 13 — Proxmox VE

## Official links

- Getting started: https://www.proxmox.com/en/products/proxmox-virtual-environment/get-started
- Documentation: https://pve.proxmox.com/pve-docs/

## What Proxmox is

Proxmox VE is a bare-metal virtualization platform based on Debian Linux with support for:

- KVM virtual machines
- LXC containers
- web management
- storage
- networking
- backups
- clustering

## Important architecture choice

### If Proxmox is the base

```text
Hardware
  |
Proxmox VE
  |
  +-- Ubuntu VM
  |     |
  |     +-- Docker
  |           |
  |           +-- CasaOS/apps
  |
  +-- other VM/LXC
```

### If Ubuntu is the base

```text
Hardware
  |
Ubuntu Server
  |
Docker
  |
Apps
```

Do not mix these architectures casually.

## Installation

Download the Proxmox VE ISO from the official site and install it on dedicated hardware.

The bare-metal installer uses the selected disk and can erase existing data. Back up anything important first.

## First steps

After installation:

1. configure management networking
2. update the host
3. configure storage
4. configure backups
5. create VM/LXC
6. install Ubuntu VM if Docker is required
7. connect management access through Tailscale where appropriate

## Tailscale and Proxmox

Tailscale documents Proxmox-specific connectivity:

https://tailscale.com/docs/containers-and-virtualization

Keep the Proxmox management interface private.
