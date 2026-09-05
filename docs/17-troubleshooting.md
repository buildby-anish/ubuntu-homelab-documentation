# 17 — Troubleshooting

## Docker is not running

```bash
sudo systemctl status docker
sudo systemctl restart docker
journalctl -u docker --no-pager -n 100
```

## Container keeps restarting

```bash
docker ps -a
docker logs <container>
docker inspect <container>
```

## Port already in use

```bash
sudo ss -lntup
docker ps
```

Find the process using a port:

```bash
sudo lsof -i :8080
```

## Tailscale not connected

```bash
tailscale status
tailscale ip
sudo systemctl status tailscaled
sudo tailscale up
```

If the TUN module is missing:

```bash
sudo modprobe tun
```

## DNS problem

```bash
resolvectl status
resolvectl query example.com
ping -c 3 1.1.1.1
ping -c 3 example.com
```

## Disk full

```bash
df -h
docker system df
sudo du -xh /var | sort -h | tail -n 30
```

Be careful with destructive Docker cleanup commands.

## Memory pressure

```bash
free -h
docker stats
ps aux --sort=-%mem | head
```

## Compose problem

```bash
docker compose config
docker compose ps
docker compose logs
```
