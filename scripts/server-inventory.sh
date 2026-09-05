#!/usr/bin/env bash
set -e

echo "===== HOST ====="
hostnamectl
echo

echo "===== KERNEL ====="
uname -a
echo

echo "===== CPU ====="
lscpu | sed -n '1,20p'
echo

echo "===== MEMORY ====="
free -h
echo

echo "===== DISKS ====="
lsblk
echo

echo "===== FILESYSTEM ====="
df -h
echo

echo "===== NETWORK ====="
ip -br addr
echo

echo "===== DOCKER ====="
docker --version || true
docker compose version || true
docker ps || true
echo

echo "===== TAILSCALE ====="
tailscale status || true
tailscale ip || true
