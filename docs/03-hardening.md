# 03 — Base Server Hardening

## Create/verify a normal admin account

```bash
id
groups
sudo -v
```

Do daily administration from a normal account with `sudo`, not as root.

## SSH

Edit:

```bash
sudo nano /etc/ssh/sshd_config
```

Recommended principles:

- use SSH keys
- disable password authentication after confirming key access works
- do not permit direct root login
- keep SSH reachable through LAN/Tailscale rather than exposing it publicly

After changes:

```bash
sudo sshd -t
sudo systemctl restart ssh
```

**Do not disable password SSH until you have tested key-based login in another session.**

## Firewall

Ubuntu commonly uses UFW.

Check:

```bash
sudo ufw status verbose
```

Example baseline:

```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow OpenSSH
sudo ufw enable
```

If SSH is intended to be Tailscale-only, do not blindly open port 22 to the entire Internet. Configure rules according to your network.

## Automatic security updates

```bash
sudo apt install -y unattended-upgrades
sudo dpkg-reconfigure --priority=low unattended-upgrades
```

## Time synchronization

```bash
timedatectl status
```

## Security principle

Do not treat a firewall as a replacement for application authentication.

Use:

- strong passwords
- MFA where supported
- SSH keys
- least privilege
- regular updates
- backups
- private networking for admin interfaces
