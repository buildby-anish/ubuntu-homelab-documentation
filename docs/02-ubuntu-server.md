# 02 — Ubuntu Server Installation

## Official links

- Installation guide: https://ubuntu.com/server/docs/tutorial/basic-installation/
- Ubuntu Server documentation: https://ubuntu.com/server/docs/
- Ubuntu Server installer guide: https://ubuntu.com/server/docs/how-to/installation/
- Ubuntu releases: https://releases.ubuntu.com/

## 1. Download the ISO

Download the appropriate Ubuntu Server LTS ISO for the machine architecture.

For a normal Intel/AMD server, use amd64.

Verify the checksum when possible.

## 2. Create a bootable USB

Use a trusted imaging tool such as:

- Rufus — Windows
- balenaEtcher — Windows/macOS/Linux
- `dd` — Linux/macOS, only when you know the target disk

## 3. Install

Boot from USB and follow the Ubuntu Server installer.

Recommended baseline:

- language: your preference
- keyboard: correct layout
- network: DHCP initially, static/reservation later if desired
- storage: dedicated server disk
- hostname: meaningful name
- user: non-root administrative user
- OpenSSH server: enable if remote SSH is required

Ubuntu's installer can configure SSH during installation.

## 4. First boot

```bash
sudo apt update
sudo apt full-upgrade -y
sudo reboot
```

## 5. Identify the machine

```bash
hostnamectl
ip addr
lsblk
df -h
free -h
uname -a
```

## 6. Install common tools

```bash
sudo apt install -y \
  curl \
  wget \
  git \
  ca-certificates \
  unzip \
  zip \
  htop \
  vim \
  nano \
  jq \
  tree \
  net-tools \
  lsof
```

## 7. Set timezone

Example:

```bash
timedatectl
sudo timedatectl set-timezone Asia/Kolkata
```

Replace the timezone if needed.

## 8. Static IP / DHCP reservation

Prefer a DHCP reservation on the router for a homelab unless you have a reason to configure a static address inside Ubuntu.

Record:

```text
Hostname: <CHANGE-ME>
LAN IP: <CHANGE-ME>
Gateway: <CHANGE-ME>
DNS: <CHANGE-ME>
```
