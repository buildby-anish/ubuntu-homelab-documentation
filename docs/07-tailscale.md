# 07 — Tailscale VPN / Private Network

## Official documentation

- Linux install: https://tailscale.com/docs/install/linux
- General install: https://tailscale.com/docs/install
- Docker: https://tailscale.com/docs/features/containers/docker
- Containers and virtualization: https://tailscale.com/docs/containers-and-virtualization

Tailscale creates a private encrypted network called a tailnet. It is ideal for remote administration without opening management ports to the public Internet.

## Install on Ubuntu

```bash
curl -fsSL https://tailscale.com/install.sh | sh
```

Then:

```bash
sudo tailscale up
```

Authenticate using the URL displayed by the command.

## Verify

```bash
tailscale status
tailscale ip
```

## Tailscale SSH

If desired:

```bash
sudo tailscale set --ssh
```

This can allow SSH access through the tailnet without exposing SSH publicly.

## Recommended server use

Use Tailscale for:

```text
Laptop
   |
Internet
   |
Tailscale
   |
Server
  |- SSH
  |- CasaOS
  |- Docker management
  |- monitoring
  |- internal apps
```

## Tailscale inside Docker

Tailscale also provides a Docker integration for giving individual containers tailnet connectivity.

Use this when a particular application should have its own Tailscale identity/network path.

Official guide:
https://tailscale.com/docs/features/containers/docker

## Auth keys

If using a Tailscale auth key for automation:

- never commit it
- store it in a secret manager or protected environment variable
- use narrowly scoped/ephemeral keys when appropriate
- rotate/revoke compromised keys immediately

## Key expiry

Tailscale supports disabling key expiry for trusted always-on servers, but this reduces a security safeguard. Only use it when the operational benefit is worth the risk.
