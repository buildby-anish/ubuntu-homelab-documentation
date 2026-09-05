# 04 — Docker Engine Installation & Host Configuration

Docker is the foundation of your homelab. It allows you to run dozens of self-hosted apps in isolated containers with zero dependency conflicts.

> **Official Docker Documentation:** [https://docs.docker.com/engine/install/ubuntu/](https://docs.docker.com/engine/install/ubuntu/)

---

## 1. Why Use Docker's Official Repository?

While Ubuntu includes a version of Docker via `apt install docker.io` or `snap`, the **official Docker repository** guarantees:
- The latest stable Docker Engine and Compose V2 releases.
- Native systemd integration and official security patches.
- Compatibility with modern container images and CasaOS.

---

## 2. Step-by-Step Installation

### Step A: Clean Up Old Conflicting Packages (if any)
```bash
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg -y; done
```

### Step B: Set Up Docker's Official GPG Key
```bash
sudo apt update
sudo apt install -y ca-certificates curl

# Create keyrings directory with proper permissions
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
```

### Step C: Add the Docker Repository to APT Sources
```bash
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF
```

### Step D: Install Docker Engine, CLI, and Compose Plugin
```bash
sudo apt update
sudo apt install -y \
  docker-ce \
  docker-ce-cli \
  containerd.io \
  docker-buildx-plugin \
  docker-compose-plugin
```

---

## 3. Manage Docker as a Non-Root User

By default, Docker requires `sudo`. To run Docker commands without typing `sudo` every time, add your user to the `docker` group:

```bash
# Add current user to the docker group
sudo usermod -aG docker $USER

# Apply group changes to current session (or log out and log back in)
newgrp docker
```

---

## 4. Crucial Homelab Optimization: Prevent Log Files From Filling Your Disk

By default, Docker stores infinite container logs on your SSD until the disk becomes completely full. Configure Docker's daemon to automatically rotate and cap log sizes:

Create or edit `/etc/docker/daemon.json`:
```bash
sudo nano /etc/docker/daemon.json
```

Add the following JSON configuration:
```json
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "20m",
    "max-file": "3"
  }
}
```
*This ensures no single container can produce more than 60MB of logs (3 files × 20MB).*

Restart Docker to apply the setting:
```bash
sudo systemctl restart docker
```

---

## 5. Verify Installation

Run the test container to confirm everything is operational:

```bash
# 1. Verify Docker Engine service is active
sudo systemctl status docker

# 2. Check Docker and Compose versions
docker --version
docker compose version

# 3. Run test container without sudo
docker run --rm hello-world
```

If you see `Hello from Docker! This message shows that your installation appears to be working correctly.`, your Docker installation is successful!

---

## 6. ⚠️ Important Security Note: Docker and the UFW Firewall

> [!WARNING]
> **How Docker Interacts with Firewalls:**
> When you publish a port using standard Docker syntax (e.g., `-p 8080:80`), Docker modifies Linux `iptables` rules directly. This means **Docker published ports can bypass standard UFW firewall rules by default**!
> 
> **Best Practices for Safe Container Publishing:**
> 1. **Local / Private Only:** If a service should only be accessible locally or through a reverse proxy on the same server, bind to localhost:
>    ```yaml
>    ports:
>      - "127.0.0.1:8080:80"
>    ```
> 2. **Tailscale Private Access:** Keep sensitive containers on private Docker networks or access them through your Tailscale IP rather than exposing them on `0.0.0.0`.

---

## 7. Essential Daily Docker Commands

| Command | What it does |
|---|---|
| `docker ps` | List running containers |
| `docker ps -a` | List all containers (including stopped ones) |
| `docker logs -f <container_name>` | Stream real-time logs from a container |
| `docker stats` | Live resource usage monitor (CPU, RAM, Network I/O) |
| `docker restart <container_name>` | Restart a container |
| `docker exec -it <container_name> /bin/sh` | Open an interactive terminal shell inside a container |
| `docker system df` | View disk space used by containers, images, and volumes |
| `docker image prune -a` | Delete unused container images to free disk space |

👉 **Next Step:** Proceed to [05 — Docker Compose Guide](05-compose.md) to learn how to organize your container stacks!
