# 10 — DNS and Service Naming

## Public DNS

For public services:

```text
app.example.com
api.example.com
status.example.com
```

Point DNS to your chosen public access layer, such as Cloudflare Tunnel.

## Private DNS

For private services, Tailscale MagicDNS can provide convenient machine naming inside the tailnet.

Example conceptual model:

```text
server-name.tailnet-name.ts.net
```

Use the Tailscale admin console to configure the tailnet and DNS behavior.

## Local DNS

Optional tools:

- Pi-hole
- AdGuard Home
- router DNS
- Unbound

Do not deploy multiple DNS resolvers without understanding which one is authoritative for clients.

## Record inventory

Maintain a table like:

| Service | Hostname | Public? | Access |
|---|---|---:|---|
| SSH | server | No | Tailscale |
| CasaOS | casaos | No | Tailscale |
| Grafana | grafana | No | Tailscale |
| Main app | app.example.com | Yes | Cloudflare |
| API | api.example.com | Depends | Cloudflare/Tailscale |
