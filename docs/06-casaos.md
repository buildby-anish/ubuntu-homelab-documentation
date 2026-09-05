# 06 — CasaOS: Visual Web Dashboard & Management

CasaOS is a lightweight, open-source dashboard designed by IceWhale that provides a user-friendly web interface on top of your Docker Engine. It gives your homelab an "app-store" feel while retaining the full power of native Linux and Docker underneath.

> **Official Website:** [https://casaos.io/](https://casaos.io/)  
> **Official GitHub:** [https://github.com/IceWhaleTech/CasaOS](https://github.com/IceWhaleTech/CasaOS)

---

## 1. Why Use CasaOS?

- **Visual Dashboard:** View CPU, RAM, disk space, and network throughput at a glance in your web browser.
- **One-Click App Store:** Install dozens of popular apps (Plex, Nextcloud, Home Assistant, Pi-hole, Jellyfin, Vaultwarden) with pre-configured settings.
- **Docker Compose Import:** Paste any standard `docker-compose.yml` file into the UI to deploy custom stacks visually.
- **Web File Manager:** Browse, upload, download, and edit files on your server without needing command-line SFTP.
- **Storage Drive Manager:** Easily format, mount, and manage internal or USB external hard drives.

---

## 2. Installation on Ubuntu Server

CasaOS runs directly on top of Ubuntu and integrates seamlessly with the official Docker Engine installed in [Guide 04](04-docker.md).

Run the official installation script:

```bash
curl -fsSL https://get.casaos.io | sudo bash
```

The script will automatically detect your Ubuntu environment, configure systemd services, and start the web dashboard.

---

## 3. Initial Setup Walkthrough

1. Open your web browser on your laptop or phone (connected to the same local network).
2. Navigate to your server's IP address:
   ```text
   http://192.168.1.100
   ```
   *(Replace with your actual server IP, or find it using `ip -br addr`)*
3. **Welcome Wizard:** Click **Start**.
4. **Create Admin Account:** Choose a strong administrator username and password. This account controls access to your server dashboard.

---

## 4. Key Features & How to Use Them

### A. Installing Apps via the App Store
1. Click the **App Store** icon on the CasaOS home screen.
2. Search for an app (e.g., *Jellyfin*, *Vaultwarden*, *AdGuard Home*).
3. Click **Install**. CasaOS will automatically pull the container image, configure volumes, and start the service.
4. Once installed, a clickable shortcut appears on your dashboard.

### B. Installing Custom Docker Compose Stacks
If an app is not in the CasaOS store, you can install any Compose file:
1. In the App Store, click **Custom Install** (top right).
2. Click **Import** (top right icon) and paste your `docker-compose.yml` content.
3. CasaOS will parse the ports, environment variables, and volumes automatically.
4. Click **Submit** to launch the container.

### C. Mounting External Hard Drives
1. Plug your USB drive or SATA hard drive into the server.
2. In CasaOS, click on **Storage Manager** (top-left drive widget).
3. Click **Create Storage** or **Format**, select your drive, and assign a friendly storage label.

---

## 5. CasaOS & Native Docker Coexistence

CasaOS is **not** a restrictive proprietary OS; it is simply a web GUI running alongside your Docker Engine.

```text
┌──────────────────────────────────────────────────────────┐
│                      Ubuntu Server                       │
│  ┌────────────────────────────────────────────────────┐  │
│  │                   Docker Engine                    │  │
│  │   ┌───────────────┐  ┌──────────────┐  ┌─────────┐ │  │
│  │   │ Apps deployed │  │ Apps started │  │ CasaOS  │ │  │
│  │   │  via CasaOS   │  │ via Compose  │  │ Core UI │ │  │
│  │   └───────────────┘  └──────────────┘  └─────────┘ │  │
│  └────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────┘
```

- Any container launched via standard `docker compose up -d` in your terminal will still show up and be monitored on the CasaOS dashboard.
- If you ever decide to uninstall or stop CasaOS, your underlying Docker containers and data will remain completely intact.

---

## 6. Security Best Practices for CasaOS

- **Do NOT Expose CasaOS Publicly:** The CasaOS dashboard gives full administrative control over your server. **Never** expose port 80 to the public internet via router port-forwarding.
- **Use Tailscale for Remote Dashboard Access:** When you are away from home, connect to Tailscale to securely access your CasaOS dashboard at `http://<tailscale-ip>` (see [Guide 07](07-tailscale.md)).

---

## 7. Useful CasaOS Management Commands

```bash
# Check CasaOS service status
sudo systemctl status casaos

# Restart CasaOS services
sudo systemctl restart casaos

# View CasaOS service logs for debugging
journalctl -u casaos -e --no-pager

# Uninstall CasaOS (if ever needed - keeps your Docker data safe)
# curl -fsSL https://get.casaos.io/uninstall.sh | sudo bash
```

👉 **Next Step:** Proceed to [07 — Tailscale VPN Guide](07-tailscale.md) to set up secure remote access from anywhere!
