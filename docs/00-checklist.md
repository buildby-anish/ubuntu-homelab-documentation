# Homelab Build & Deployment Checklist

Use this end-to-end interactive checklist when setting up a fresh homelab server or doing a health audit.

---

## Phase 1 — Hardware & Base OS Installation ([Guide 02](02-ubuntu-server.md))

- [ ] **Hardware Prepared:** Verified CPU, RAM, disk space, and reliable wired Ethernet connection.
- [ ] **Backup Existing Data:** Confirmed no critical files remain on the target installation drive.
- [ ] **ISO Downloaded:** Downloaded latest Ubuntu Server 24.04 or 22.04 LTS from [releases.ubuntu.com](https://releases.ubuntu.com/).
- [ ] **Bootable USB Created:** Flashed ISO using balenaEtcher, Rufus, or Raspberry Pi Imager.
- [ ] **Base OS Installed:** Installed Ubuntu Server with standard disk partition or expanded LVM logical volume (`lvextend`).
- [ ] **System Updated:** Ran `sudo apt update && sudo apt full-upgrade -y` and rebooted.
- [ ] **Static IP / DHCP Reservation:** Reserved IP address for the server in router settings.
- [ ] **Timezone Configured:** Set correct timezone via `sudo timedatectl set-timezone <YOUR-TIMEZONE>`.
- [ ] **System Inventory Recorded:** Documented hostname, MAC address, LAN IP, and disk layout.

---

## Phase 2 — Security & Server Hardening ([Guide 03](03-hardening.md))

- [ ] **Dedicated Admin User:** Created a non-root administrative user with `sudo` privileges.
- [ ] **SSH Key Pair Generated:** Created an `ed25519` key pair on client machine (`ssh-keygen -t ed25519`).
- [ ] **Public Key Installed:** Transferred key to server using `ssh-copy-id username@server-ip`.
- [ ] **SSH Key Access Tested:** Verified login with key in a separate terminal window before disabling passwords.
- [ ] **Password Auth Disabled:** Set `PasswordAuthentication no` and `PermitRootLogin no` in `/etc/ssh/sshd_config`.
- [ ] **UFW Firewall Enabled:** Configured baseline firewall rules (`allow OpenSSH`, `enable`).
- [ ] **Unattended Upgrades Configured:** Enabled automatic security updates (`unattended-upgrades`).

---

## Phase 3 — Container Runtime Engine ([Guide 04](04-docker.md) & [Guide 05](05-compose.md))

- [ ] **Official Docker Repository Added:** Configured official Docker apt GPG keys and sources list.
- [ ] **Docker Engine & Plugins Installed:** Installed `docker-ce`, `docker-ce-cli`, `containerd.io`, and `docker-compose-plugin`.
- [ ] **Non-Root Docker Access:** Added user to `docker` group (`sudo usermod -aG docker $USER`).
- [ ] **Hello-World Verified:** Ran `docker run --rm hello-world` successfully without `sudo`.
- [ ] **Log Rotation Configured:** Set `/etc/docker/daemon.json` with max log sizes to prevent full disk crashes.
- [ ] **Storage Hierarchy Created:** Initialized `/srv/docker/appdata`, `/srv/docker/compose`, and `/srv/backups`.

---

## Phase 4 — Visual Management & Private VPN ([Guide 06](06-casaos.md) & [Guide 07](07-tailscale.md))

- [ ] **(Optional) CasaOS Installed:** Installed CasaOS dashboard (`curl -fsSL https://get.casaos.io | sudo bash`).
- [ ] **CasaOS Account Secured:** Created strong admin username and password on the web UI (`http://<SERVER-IP>`).
- [ ] **Tailscale Installed:** Installed Tailscale client (`curl -fsSL https://tailscale.com/install.sh | sh`).
- [ ] **Tailscale Authenticated:** Connected machine to tailnet (`sudo tailscale up`).
- [ ] **Remote Connectivity Verified:** Successfully connected via Tailscale IP/MagicDNS from a phone or laptop outside home Wi-Fi.
- [ ] **(Optional) Tailscale SSH Enabled:** Enabled zero-config SSH through Tailscale (`sudo tailscale set --ssh`).

---

## Phase 5 — Networking, DNS & Public Ingress ([Guide 08](08-cloudflare-tunnel.md) – [Guide 10](10-dns.md))

- [ ] **DNS Scheme Planned:** Defined internal hostnames (MagicDNS) vs public hostnames.
- [ ] **Cloudflare Tunnel Configured (Optional):** Created tunnel in Cloudflare Zero Trust dashboard.
- [ ] **Cloudflared Compose Stack Deployed:** Ran `cloudflared` container with tunnel token stored in `.env`.
- [ ] **Public Hostnames Routed:** Linked public domain routes (e.g., `app.domain.com`) to internal container ports.
- [ ] **Reverse Proxy Configured (Optional):** Deployed Caddy or Nginx Proxy Manager for internal HTTPS/routing.
- [ ] **No Unsafe Open Ports:** Verified database ports (5432, 3306, 6379) and admin panels are NOT exposed publicly.

---

## Phase 6 — Storage, Monitoring & Automated Backups ([Guide 11](11-storage-backups.md) & [Guide 12](12-monitoring.md))

- [ ] **External Disks Mounted:** Added external storage drives to `/etc/fstab` using persistent UUIDs.
- [ ] **Monitoring Stack Deployed:** Started Uptime Kuma (`docker compose -f docker/monitoring-compose.example.yml up -d`).
- [ ] **Notification Alerts Set Up:** Connected Uptime Kuma to Telegram, Discord, Pushover, or email alerts.
- [ ] **Automated Backup Script Configured:** Created cron job to backup `/srv/docker` configs and database dumps.
- [ ] **Restore Drill Conducted:** Tested restoring an application from backup files to verify data integrity.

---

## Phase 7 — Repository & Secret Hygiene ([Guide 16](16-security-checklist.md))

- [ ] **Environment Template Created:** Ensured `docker/.env.example` has all required variable placeholders.
- [ ] **Real Secrets Excluded:** Checked `.gitignore` to ensure `.env`, private keys, and tokens are ignored.
- [ ] **Git History Clean:** Verified with `git status` that no secret files are staged before pushing to GitHub.
- [ ] **Disaster Recovery Plan Tested:** Reviewed [Guide 19 (Disaster Recovery)](19-disaster-recovery.md).
