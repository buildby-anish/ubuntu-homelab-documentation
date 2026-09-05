# 12 — Monitoring and Updates

## Basic monitoring

```bash
htop
free -h
df -h
lsblk
uptime
docker stats
```

## Useful monitoring containers

Optional:

- Uptime Kuma — service availability
- Netdata — system/container monitoring
- Prometheus — metrics collection
- Grafana — visualization
- Dozzle — Docker log viewer

Do not install all of them automatically. Pick the smallest stack that meets the requirement.

## Update strategy

Ubuntu:

```bash
sudo apt update
sudo apt full-upgrade
```

Docker images:

```bash
docker compose pull
docker compose up -d
```

Before major upgrades:

1. verify backups
2. read release notes
3. update one stack at a time
4. verify health
5. keep rollback information

## Automatic container updates

Tools such as Watchtower can automate image updates, but automatic updates can introduce breaking changes.

For important services, controlled updates are usually safer.
