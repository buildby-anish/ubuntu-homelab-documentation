# 03 — Base Server Hardening & SSH Security

Securing your server is one of the most critical steps before running Docker containers or services. Follow these actionable steps to protect your machine.

---

## 1. Verify / Create Non-Root Administrative User

Never run daily administration as the `root` user. Use a dedicated user with `sudo` rights.

### Check your current user:
```bash
whoami
id
# Confirm you belong to the 'sudo' group
```

### (If needed) Create a new admin user:
```bash
# Replace 'homelabadmin' with your chosen username
sudo adduser homelabadmin
sudo usermod -aG sudo homelabadmin
```

---

## 2. Set Up Modern SSH Key-Based Authentication

SSH keys are drastically more secure and convenient than passwords.

### Step A: Generate an SSH Key on your CLIENT Computer (Laptop/Mac/Windows)
Open a terminal (macOS/Linux) or PowerShell (Windows) on your **laptop/desktop**:

```bash
# Generate a modern, highly secure ED25519 SSH key
ssh-keygen -t ed25519 -C "homelab-key"

# Press Enter to accept default location (~/.ssh/id_ed25519)
# Optionally set a passphrase for added protection
```

### Step B: Copy your Public Key to the Server
From your **laptop/desktop**, run:

```bash
# Replace with your server's username and IP
ssh-copy-id homelabadmin@192.168.1.100
```

> [!TIP]
> **Windows PowerShell without ssh-copy-id:**
> If `ssh-copy-id` is not available on Windows, run this from PowerShell:
> ```powershell
> type $env:USERPROFILE\.ssh\id_ed25519.pub | ssh homelabadmin@192.168.1.100 "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 700 ~/.ssh && chmod 600 ~/.ssh/authorized_keys"
> ```

### Step C: Test Key Login
From your laptop, connect without typing your password:
```bash
ssh homelabadmin@192.168.1.100
```
If you log in successfully without being asked for your account password (or only prompted for your key passphrase), your key is working!

---

## 3. Harden the SSH Daemon Configuration

Once key-based SSH is verified, disable password authentication and root login.

Edit `/etc/ssh/sshd_config`:
```bash
sudo nano /etc/ssh/sshd_config
```

Make sure the following lines are set (uncomment them if prefixed with `#`):

```text
# Disable direct root login
PermitRootLogin no

# Disable password authentication (forces SSH keys)
PasswordAuthentication no
PermitEmptyPasswords no

# Disable legacy insecure authentication methods
KbdInteractiveAuthentication no
X11Forwarding no

# Set idle timeout (disconnects inactive sessions after 15 mins)
ClientAliveInterval 300
ClientAliveCountMax 3
```

### Validate and Restart SSH:
```bash
# 1. Check config file syntax for errors
sudo sshd -t

# 2. If no errors were reported, restart SSH service
sudo systemctl restart ssh
```

> [!CAUTION]
> **CRITICAL RULE:** Do NOT close your current active terminal session! Open a **brand-new terminal window** on your client computer and test logging in:
> ```bash
> ssh homelabadmin@192.168.1.100
> ```
> Only close your original session once you confirm the new session logs in cleanly.

---

## 4. Configure the UFW (Uncomplicated Firewall)

UFW acts as your host-level firewall.

### Step A: Set Default Policies
```bash
# Block all unsolicited incoming traffic by default
sudo ufw default deny incoming

# Allow all outgoing traffic (updates, downloads)
sudo ufw default allow outgoing
```

### Step B: Allow Essential Traffic (SSH)
```bash
# Allow SSH so you don't lock yourself out!
sudo ufw allow OpenSSH
```

### Step C: Enable and Verify UFW
```bash
sudo ufw enable
# Press 'y' when prompted

# Check firewall status
sudo ufw status verbose
```

**Expected output:**
```text
Status: active
Logging: on (low)
Default: deny (incoming), allow (outgoing), disabled (routed)
New profiles: skip

To                         Action      From
--                         ------      ----
22/tcp (OpenSSH)           ALLOW IN    Anywhere
22/tcp (OpenSSH (v6))      ALLOW IN    Anywhere (v6)
```

---

## 5. Enable Automatic Security Updates (Unattended Upgrades)

Ensure critical Linux kernel and security patches install automatically without manual intervention.

```bash
# Install unattended-upgrades
sudo apt install -y unattended-upgrades update-notifier-common

# Enable automatic security upgrades
sudo dpkg-reconfigure --priority=low unattended-upgrades
# Select <Yes> when prompted
```

Verify that the service is active:
```bash
sudo systemctl status unattended-upgrades
```

---

## 6. (Optional) Install Fail2ban for Brute-Force Protection

Fail2ban monitors system logs and temporarily bans IP addresses that show malicious signs (e.g., too many failed SSH login attempts).

```bash
sudo apt install -y fail2ban
sudo systemctl enable --now fail2ban
sudo fail2ban-client status
```

---

## Hardening Verification Summary

- [x] Dedicated admin user created with sudo privileges
- [x] SSH key login tested and working
- [x] Password authentication disabled in `sshd_config`
- [x] Direct root login disabled
- [x] UFW firewall active with `default deny incoming`
- [x] `unattended-upgrades` active for automated security patching

👉 **Next Step:** Proceed to [04 — Docker Engine Installation](04-docker.md) to set up your container runtime!
