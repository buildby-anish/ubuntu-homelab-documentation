# Server Build Checklist

## Phase 1 — Hardware/OS

- [ ] Hardware tested
- [ ] Backup existing data
- [ ] Ubuntu Server ISO downloaded
- [ ] USB installer created
- [ ] Ubuntu installed
- [ ] Hostname set
- [ ] LAN connectivity verified
- [ ] Timezone configured

## Phase 2 — Security

- [ ] User + sudo
- [ ] SSH keys
- [ ] SSH tested
- [ ] Firewall
- [ ] unattended-upgrades
- [ ] no public admin ports

## Phase 3 — Container runtime

- [ ] Docker Engine
- [ ] Docker Compose
- [ ] `hello-world`
- [ ] persistent storage structure

## Phase 4 — Management

- [ ] CasaOS (optional)
- [ ] Portainer (optional)
- [ ] Tailscale
- [ ] Tailscale access tested from another network

## Phase 5 — Connectivity

- [ ] DNS plan
- [ ] Cloudflare account/domain (if needed)
- [ ] Cloudflare Tunnel (if needed)
- [ ] Reverse proxy (if needed)
- [ ] TLS verified

## Phase 6 — Applications

- [ ] application containers
- [ ] database
- [ ] persistent volumes
- [ ] health checks
- [ ] backups
- [ ] restore test

## Phase 7 — Documentation

- [ ] architecture diagram updated
- [ ] IP/hostname inventory documented
- [ ] container inventory documented
- [ ] ports documented
- [ ] backup locations documented
- [ ] recovery procedure tested
- [ ] secrets excluded from Git
