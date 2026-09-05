# 05 — Docker Compose Best Practices & Stack Organization

Docker Compose lets you define and run multi-container applications using readable YAML configuration files. Instead of memorizing long `docker run` terminal commands with dozens of flags, you describe your entire infrastructure in `docker-compose.yml` files.

> **Official Docker Compose Documentation:** [https://docs.docker.com/compose/](https://docs.docker.com/compose/)

---

## 1. Recommended Homelab Directory Layout

To keep your server organized, establish a clean directory structure under `/srv/docker` or `~/homelab`:

```text
/srv/docker/
├── appdata/                       ← Persistent container data (mapped via bind mounts)
│   ├── uptime-kuma/
│   ├── nextcloud/
│   └── postgres/
├── compose/                       ← Your version-controlled Docker Compose files
│   ├── monitoring/
│   │   └── docker-compose.yml
│   ├── reverse-proxy/
│   │   └── docker-compose.yml
│   ├── cloudflare/
│   │   └── docker-compose.yml
│   └── apps/
│       └── docker-compose.yml
├── .env.example                   ← Environment template tracked in Git
└── .env                           ← Real secrets (NEVER tracked in Git)
```

Create this base hierarchy with:
```bash
sudo mkdir -p /srv/docker/{appdata,compose,backups}
sudo chown -R $USER:$USER /srv/docker
```

---

## 2. Anatomy of a Clean `docker-compose.yml`

Here is a breakdown of a production-ready Compose service definition:

```yaml
services:
  web-app:
    # 1. Container image from Docker Hub (specify a stable version tag rather than 'latest')
    image: nginx:1.27-alpine

    # 2. Friendly container name for easy identification in 'docker ps'
    container_name: web-app

    # 3. Always restart container if it crashes or the server reboots
    restart: unless-stopped

    # 4. Port mapping: HOST_PORT:CONTAINER_PORT
    ports:
      - "8080:80"

    # 5. Environment variables (interpolated from .env file)
    environment:
      - TZ=${TZ:-UTC}
      - APP_ENV=production

    # 6. Persistent storage (bind mount or named volume)
    volumes:
      - /srv/docker/appdata/web-app/html:/usr/share/nginx/html:ro

    # 7. Isolated container network
    networks:
      - frontend-net

networks:
  frontend-net:
    driver: bridge
```

---

## 3. Storage: Named Volumes vs. Host Bind Mounts

| Type | Syntax | Best Use Case | Backup Ease |
|---|---|---|---|
| **Host Bind Mount** | `/srv/docker/appdata/app:/data` | App configuration files, media folders, databases | ⭐⭐⭐⭐⭐ Easiest (plain files on your disk) |
| **Named Volume** | `my_volume:/data` | High-performance I/O where direct host file access isn't required | ⭐⭐⭐ Managed by Docker engine |

**Recommendation for Homelabs:** Use **Host Bind Mounts** (`/srv/docker/appdata/<app-name>`) whenever possible. This makes backing up, inspecting, or migrating container data to a new server straightforward.

---

## 4. Isolating Databases with Private Networks

Never expose database ports (e.g., PostgreSQL `5432` or MySQL `3306`) to the host network unless another computer specifically needs access. Keep them on an internal Docker network:

```yaml
services:
  app:
    image: my-app:latest
    container_name: my-app
    restart: unless-stopped
    ports:
      - "3000:3000"
    environment:
      - DB_HOST=db  # Connects directly using the service name 'db'!
      - DB_PASSWORD=${POSTGRES_PASSWORD}
    networks:
      - app-network

  db:
    image: postgres:16-alpine
    container_name: my-app-db
    restart: unless-stopped
    # NOTICE: No 'ports:' section! DB is only reachable by containers on 'app-network'
    environment:
      - POSTGRES_DB=appdb
      - POSTGRES_USER=appuser
      - POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
    volumes:
      - /srv/docker/appdata/app-db:/var/lib/postgresql/data
    networks:
      - app-network

networks:
  app-network:
    driver: bridge
```

---

## 5. Working with Environment Variables (`.env`)

Docker Compose automatically reads a file named `.env` in the same directory where `docker compose` is executed.

1. Create a `.env.example` file committed to Git:
   ```dotenv
   TZ=UTC
   POSTGRES_PASSWORD=CHANGE_ME
   ```
2. Copy it to `.env` on your server:
   ```bash
   cp .env.example .env
   nano .env # Set your real secure passwords
   ```

---

## 6. Docker Compose Lifecycle Commands

Run these commands inside the directory containing your `docker-compose.yml`:

```bash
# Start all containers in background (detached mode)
docker compose up -d

# Check status of containers in this stack
docker compose ps

# View and follow real-time logs for all services in this stack
docker compose logs -f

# View logs for a specific service
docker compose logs -f web-app

# Stop and remove containers, networks created by this stack (volumes are kept safe)
docker compose down

# Pull latest container images and recreate updated containers
docker compose pull && docker compose up -d

# Validate compose file syntax without starting containers
docker compose config
```

👉 **Next Step:** Proceed to [06 — CasaOS Management Guide](06-casaos.md) for a visual web dashboard!
