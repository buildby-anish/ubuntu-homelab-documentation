# 15 — Container Catalog

This is a recommended catalog, not a claim that every container is already installed on the server.

## Core

| Component | Purpose | Required |
|---|---|---|
| Docker Engine | Container runtime | Yes for Docker architecture |
| Docker Compose | Multi-container management | Strongly recommended |
| CasaOS | Web management UI | Optional |
| Tailscale | Private VPN | Strongly recommended |
| Cloudflared | Public ingress without inbound ports | Optional |

## Management

| Container | Purpose |
|---|---|
| Portainer | Docker management UI |
| Dozzle | Docker logs |
| Uptime Kuma | Uptime monitoring |

## Networking

| Component | Purpose |
|---|---|
| Tailscale | Private encrypted network |
| Cloudflare Tunnel | Public application ingress |
| Caddy | Reverse proxy/TLS |
| Traefik | Dynamic reverse proxy |

## Data

| Container | Purpose |
|---|---|
| PostgreSQL | Relational database |
| MariaDB | Relational database |
| Redis | Cache/message broker |
| MinIO | S3-compatible object storage |

Only deploy the databases actually required by your applications.

## Monitoring

| Container | Purpose |
|---|---|
| Prometheus | Metrics |
| Grafana | Dashboards |
| Netdata | Host/container monitoring |

## Security rule

Every additional container increases:

- attack surface
- update requirements
- storage usage
- operational complexity

Start small and add components when there is a concrete requirement.
