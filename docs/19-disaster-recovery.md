# 19 — Disaster Recovery

## Recovery order

1. Restore physical/virtual host.
2. Install Ubuntu or restore VM.
3. Restore network access.
4. Install Docker.
5. Install Tailscale.
6. Restore Git repository.
7. Restore Compose files and `.env` secrets from secure storage.
8. Restore persistent volumes/data.
9. Start infrastructure containers.
10. Start application containers.
11. Verify DNS.
12. Verify external/public services.
13. Verify backups again.

## Minimum Git repository contents

Git should contain:

```text
compose/
configuration templates/
scripts/
documentation/
.env.example
```

It should not contain:

```text
real .env
database dumps containing secrets
private keys
tokens
credentials
large mutable application data
```

## Recovery test

At least once, perform a clean recovery to a VM or spare disk.

Document:

- time required
- missing dependencies
- manual steps
- credentials required
- services that failed
- improvements needed
