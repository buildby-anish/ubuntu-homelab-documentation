# 18 — Command Reference

## Ubuntu

```bash
sudo apt update
sudo apt full-upgrade
hostnamectl
ip addr
lsblk
df -h
free -h
systemctl --failed
journalctl -p 3 -xb
```

## SSH

```bash
ssh user@server
ssh-keygen
```

## Docker

```bash
docker ps
docker ps -a
docker images
docker volume ls
docker network ls
docker stats
docker logs -f <container>
docker exec -it <container> sh
docker restart <container>
docker stop <container>
docker start <container>
docker pull <image>
docker image prune
```

## Compose

```bash
docker compose up -d
docker compose down
docker compose ps
docker compose logs -f
docker compose pull
docker compose up -d
docker compose config
```

## Tailscale

```bash
tailscale status
tailscale ip
tailscale ping <machine>
sudo tailscale up
sudo tailscale down
```

## Git

```bash
git status
git add .
git commit -m "Update server documentation"
git pull
git push
git log --oneline --decorate --graph -20
```
