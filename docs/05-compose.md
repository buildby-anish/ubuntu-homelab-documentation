# 05 — Docker Compose

## Official documentation

https://docs.docker.com/compose/

Compose lets you describe multi-container applications declaratively.

## Recommended structure

```text
docker/
├── stacks/
│   ├── reverse-proxy/
│   ├── monitoring/
│   ├── vpn/
│   ├── cloudflare/
│   └── apps/
├── .env.example
└── README.md
```

## Basic Compose file

```yaml
services:
  example:
    image: nginx:alpine
    container_name: example
    restart: unless-stopped
    ports:
      - "8080:80"
```

Start:

```bash
docker compose up -d
```

Check:

```bash
docker compose ps
docker compose logs -f
```

Stop:

```bash
docker compose down
```

Update:

```bash
docker compose pull
docker compose up -d
```

## Environment variables

Use:

```text
.env.example
```

Commit the example:

```dotenv
TZ=Asia/Kolkata
DOMAIN=example.com
```

Keep the real `.env` untracked.

## Volumes

Prefer named volumes or explicit bind mounts for persistent data.

Example:

```yaml
volumes:
  app_data:
```

## Networks

Create separate networks when useful:

```yaml
networks:
  proxy:
  internal:
```

Keep databases on internal networks where possible.
