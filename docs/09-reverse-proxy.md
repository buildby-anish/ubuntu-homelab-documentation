# 09 — Reverse Proxy

A reverse proxy receives HTTP/HTTPS requests and routes them to internal services.

Common options include:

- Caddy
- Traefik
- Nginx Proxy Manager
- Nginx

Choose one rather than deploying multiple proxies unless you have a deliberate architecture.

## Example routing

```text
https://app.example.com
        |
   Reverse Proxy
        |
   app:3000

https://api.example.com
        |
   Reverse Proxy
        |
   api:8000
```

## Recommended practice

- terminate TLS at the proxy or Cloudflare
- keep application containers on private Docker networks
- expose only the proxy's required ports
- use authentication on admin applications
- keep proxy configuration in Git
- keep certificates/credentials out of Git

## Avoid

Do not publish:

```text
5432 PostgreSQL
3306 MySQL
6379 Redis
2375 Docker API
22 SSH
8006 Proxmox
```

to the Internet unless there is an exceptional, explicitly secured requirement.
