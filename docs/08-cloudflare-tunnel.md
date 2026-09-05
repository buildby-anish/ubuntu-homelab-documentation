# 08 — Cloudflare Tunnel

## Purpose

Cloudflare Tunnel provides an outbound connection from your server to Cloudflare so selected web services can be published without directly exposing the origin server with an inbound public port.

Official docs:

https://developers.cloudflare.com/tunnel/

## When to use it

Use Cloudflare Tunnel for:

- public websites
- public APIs
- selected web applications
- services protected by Cloudflare Access/Zero Trust

Do not use it as a replacement for Tailscale when the service should remain private.

## Basic architecture

```text
Public user
    |
Cloudflare
    |
Cloudflare Tunnel
    |
cloudflared
    |
Docker network
    |
Application
```

## Prerequisites

- Cloudflare account
- domain managed by Cloudflare for published hostname use
- server/VM with outbound Internet connectivity
- `cloudflared`

## Docker example

The exact token/command should be obtained from your Cloudflare dashboard rather than committed to Git.

Example template:

```yaml
services:
  cloudflared:
    image: cloudflare/cloudflared:latest
    container_name: cloudflared
    restart: unless-stopped
    command: tunnel --no-autoupdate run --token ${CLOUDFLARE_TUNNEL_TOKEN}
    environment:
      - CLOUDFLARE_TUNNEL_TOKEN=${CLOUDFLARE_TUNNEL_TOKEN}
```

Put the token in `.env`, never in Git.

## Security

Treat the tunnel token as a secret. Anyone who obtains it may be able to operate the tunnel depending on its permissions.

Prefer Cloudflare Access/MFA for sensitive public applications.
