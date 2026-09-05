# 01 — Architecture

## Goal

Build a maintainable self-hosted server where:

- Ubuntu provides the operating-system layer.
- Docker provides application isolation.
- Docker Compose provides repeatable multi-container deployment.
- CasaOS provides a friendly management interface for Docker applications.
- Tailscale provides private VPN access without exposing management ports.
- Cloudflare Tunnel can publish selected web applications without opening inbound ports.
- A reverse proxy can provide consistent hostnames/TLS when needed.
- Proxmox is an alternative bare-metal base when virtualization is required.
- Tailwind CSS is used inside web applications; it is not a server-management dependency.

## Network model

### Private services

Prefer Tailscale for:

- SSH
- CasaOS
- Docker management
- Proxmox management
- databases
- dashboards
- internal APIs
- admin panels

### Public services

Use Cloudflare Tunnel or another carefully configured reverse proxy for applications that genuinely need public access.

Avoid exposing these directly to the Internet:

- Docker daemon
- SSH on a public interface
- CasaOS admin panel
- Portainer
- database ports
- Proxmox GUI

## Example service naming

```text
server.example.com
casaos.example.internal
grafana.example.internal
portainer.example.internal
app.example.com
api.example.com
```

Use your own domain and internal naming scheme.

## Proxmox decision

Use Proxmox when you need:

- multiple VMs/LXC containers
- snapshots
- isolated operating systems
- virtual networking
- homelab experimentation
- easier VM lifecycle management

Use Ubuntu directly when you want:

- lower complexity
- maximum simplicity
- a single Docker host
- fewer virtualization layers
