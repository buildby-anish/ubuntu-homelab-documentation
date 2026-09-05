# 04 — Docker Engine

## Official documentation

https://docs.docker.com/engine/install/ubuntu/

Docker recommends installing Docker Engine from its official apt repository for a normal server installation.

## Install prerequisites

```bash
sudo apt update
sudo apt install -y ca-certificates curl
```

## Add Docker's official GPG key

```bash
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
  -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
```

## Add Docker repository

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

Then:

```bash
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

## Verify

```bash
sudo systemctl status docker
sudo docker run hello-world
docker compose version
```

## Optional non-root Docker usage

Docker's `docker` group effectively grants root-level control of the host. Only add trusted users.

```bash
sudo usermod -aG docker $USER
newgrp docker
docker run hello-world
```

## Important firewall note

Published Docker ports can interact with firewall rules differently from ordinary host services. Review Docker's firewall guidance before assuming UFW alone protects every container.

## Useful commands

```bash
docker ps
docker ps -a
docker images
docker volume ls
docker network ls
docker stats
docker logs <container>
docker inspect <container>
```
