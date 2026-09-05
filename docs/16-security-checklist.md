# 16 — Security Checklist

## Host

- [ ] Ubuntu fully updated
- [ ] Normal user + sudo
- [ ] SSH keys configured
- [ ] Root SSH login disabled
- [ ] Password SSH disabled only after key testing
- [ ] Firewall configured
- [ ] Time synchronization active
- [ ] Backups configured

## Docker

- [ ] Docker installed from official source
- [ ] Images come from trusted publishers
- [ ] Containers run with minimum required privileges
- [ ] No unnecessary host mounts
- [ ] No unnecessary `privileged: true`
- [ ] Docker socket access is restricted
- [ ] Secrets are not embedded in Compose files

## Network

- [ ] Management interfaces are private
- [ ] Tailscale enabled for remote administration
- [ ] Public services are intentionally selected
- [ ] No accidental database exposure
- [ ] No public Docker daemon
- [ ] Cloudflare tunnel tokens are protected

## Git

Never commit:

- passwords
- API keys
- SSH private keys
- Tailscale auth keys
- Cloudflare tunnel tokens
- database credentials
- `.env` containing secrets

## Before publishing a repository

Run:

```bash
git status
git diff --cached
```

Search for obvious secrets before push.
