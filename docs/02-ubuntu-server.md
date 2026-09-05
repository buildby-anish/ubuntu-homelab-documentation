# 02 — Ubuntu Server Installation & Initial Setup

A complete, beginner-friendly guide to installing Ubuntu Server 24.04 or 22.04 LTS on bare metal or inside a VM.

---

## 1. Prerequisites & Official Links

- **Official ISO Download:** [releases.ubuntu.com](https://releases.ubuntu.com/) (Download **Ubuntu Server 24.04 LTS** or **22.04 LTS** - `amd64` for Intel/AMD PCs, `arm64` for Raspberry Pi / Apple Silicon).
- **USB Flash Drive:** 4GB or larger (will be wiped completely).
- **Flashing Utility:** [balenaEtcher](https://etcher.balena.io/) (Cross-platform) or [Rufus](https://rufus.ie/) (Windows).
- **Target Hardware:** Target PC connected to your router via Ethernet cable, with a keyboard and monitor connected.

---

## 2. Prepare the Bootable USB

1. Download the **Ubuntu Server LTS ISO** file.
2. Insert your USB flash drive into your client computer.
3. Open **balenaEtcher**:
   - Click **Flash from file** and select the downloaded ISO.
   - Click **Select target** and choose your USB drive.
   - Click **Flash!** and wait for verification to complete.

---

## 3. BIOS / UEFI Configuration (Crucial Homelab Settings)

Before booting the installer, power on your target PC and tap the BIOS key (`F2`, `F10`, `F12`, `Del`, or `Esc` depending on manufacturer):

1. **Enable Virtualization:** Turn on `Intel VT-x` / `Intel Virtualization Technology` or `AMD-V` / `SVM Mode`.
2. **AC Power Loss Recovery:** Set **Restore on AC / Power Loss** to `Power On` or `Last State` so your homelab automatically boots back up after a power outage.
3. **Boot Priority:** Set the USB drive as the primary boot device.
4. Save changes and reboot into the Ubuntu installer.

---

## 4. Step-by-Step Installation Walkthrough

When the server boots from the USB, follow these installer prompts:

```text
1. Welcome / Language:        Choose English (or your preferred language) -> Continue.
2. Installer Update:          Select "Update to the new installer" if prompted.
3. Keyboard Configuration:    Select your keyboard layout (e.g., English US).
4. Type of Install:           Choose "Ubuntu Server" (standard).
5. Network Connections:       Accept default DHCP for now (we recommend setting a DHCP reservation on your router later).
6. Configure Proxy:           Leave blank unless your network requires a proxy.
7. Ubuntu Archive Mirror:     Keep default mirror (or closest geographic mirror).
8. Guided Storage Config:     [IMPORTANT] Keep "Use an entire disk" checked.
                              Uncheck "Set up this disk as an LVM group" for simplest single partition, 
                              OR if using LVM, see the LVM sizing callout below!
9. Profile Setup:
     • Your name:             Your name (e.g., John Doe)
     • Your server's name:    Meaningful hostname (e.g., homelab, ubuntu-server)
     • Pick a username:       Non-root admin user (e.g., sysadmin or your username)
     • Choose a password:     Strong, memorable password
10. Ubuntu Pro:               Skip for now.
11. SSH Setup:                [IMPORTANT] Check "[X] Install OpenSSH server".
12. Featured Server Snaps:    Do not select any snaps here (we will install Docker cleanly from official repos).
13. Install Complete:         Select "Reboot Now" and remove the USB drive when prompted.
```

> [!IMPORTANT]
> **Ubuntu LVM Disk Allocation Warning:**
> By default, the Ubuntu installer often assigns only **100GB** or **50%** of your total disk size to the root logical volume (`/`), leaving the rest unallocated!
> To give Ubuntu access to the entire disk, run this command after logging in:
> ```bash
> sudo lvextend -l +100%FREE /dev/mapper/ubuntu--vg-ubuntu--lv
> sudo resize2fs /dev/mapper/ubuntu--vg-ubuntu--lv
> df -h / # Verify your root partition now shows full disk capacity
> ```

---

## 5. First Boot & System Upgrade

Log in with the username and password created during installation. Immediately update all base system packages to ensure security patches are applied:

```bash
sudo apt update && sudo apt full-upgrade -y
sudo reboot
```

---

## 6. Install Essential Homelab CLI Utilities

Install helpful diagnostic, network, and file management tools:

```bash
sudo apt install -y \
  curl \
  wget \
  git \
  ca-certificates \
  unzip \
  zip \
  htop \
  btop \
  vim \
  nano \
  jq \
  tree \
  net-tools \
  lsof \
  ufw \
  ncdu \
  dnsutils
```

---

## 7. Configure Timezone and Localization

Ensure your server logs and scheduled cron tasks reflect your actual local time:

```bash
# Check current timezone and clock sync status
timedatectl

# List available timezones (press 'q' to exit list)
timedatectl list-timezones | grep -i "america\|europe\|asia\|london"

# Set your timezone (Example: Asia/Kolkata or America/New_York)
sudo timedatectl set-timezone Asia/Kolkata

# Verify system time
timedatectl
```

---

## 8. Network Setup: Setting a Static IP or DHCP Reservation

A server needs a consistent IP address so other devices can reliably connect to it.

### Recommended Method: DHCP Reservation on Your Home Router
1. Log into your home router's admin panel (typically `192.168.1.1` or `192.168.0.1`).
2. Find the **DHCP Reservation** / **Static Lease** table.
3. Locate your server's MAC address and assign a permanent LAN IP (e.g., `192.168.1.100`).

### Alternative Method: Static IP via Netplan (Inside Ubuntu)
Find your active network interface name:
```bash
ip -br addr
# Look for an interface like 'eth0', 'eno1', or 'enp3s0'
```

If configuring static IP directly, edit `/etc/netplan/50-cloud-init.yaml` or `/etc/netplan/00-installer-config.yaml`:

```yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    enp3s0: # Replace with your interface name
      dhcp4: no
      addresses:
        - 192.168.1.100/24
      routes:
        - to: default
          via: 192.168.1.1 # Your router IP
      nameservers:
        addresses:
          - 1.1.1.1
          - 8.8.8.8
```
Apply the netplan configuration:
```bash
sudo netplan apply
```

---

## 9. Verification & System Inventory Record

Verify your fresh server is healthy and record its details:

```bash
# Check hostname, IP, and disk space
hostnamectl
ip -br addr
df -h /
free -h
```

**Fill in your server inventory:**
```text
Hostname:     <CHANGE-ME> (e.g., homelab-server)
LAN IP:       <CHANGE-ME> (e.g., 192.168.1.100)
Gateway / Router: <CHANGE-ME> (e.g., 192.168.1.1)
DNS Servers:  1.1.1.1, 8.8.8.8
Architecture: x86_64 / amd64
Admin User:   <CHANGE-ME> (e.g., sysadmin)
```

👉 **Next Step:** Proceed to [03 — Base Server Hardening](03-hardening.md) to secure SSH and set up your firewall!
