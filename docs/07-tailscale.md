# 07 — Tailscale VPN: Secure Zero-Config Remote Access

Tailscale creates a secure, encrypted mesh network (called a **tailnet**) between your server, phone, laptop, and other devices using the modern WireGuard protocol.

It enables you to access your homelab services, SSH terminal, and CasaOS dashboard from coffee shops, airports, or cellular data **without opening a single port on your home router**.

> **Official Tailscale Documentation:** [https://tailscale.com/docs/](https://tailscale.com/docs/)  
> **Linux Install Guide:** [https://tailscale.com/docs/install/linux](https://tailscale.com/docs/install/linux)

---

## 1. Why Tailscale is the Gold Standard for Homelabs

```text
┌─────────────────┐                                ┌─────────────────┐
│ Your Phone / Mac│                                │  Ubuntu Server  │
│ (Anywhere in    ├────────[ WireGuard Tunnel ]────► (Home Network,  │
│  the world)     │     (End-to-End Encrypted)     │  0 open ports!) │
└─────────────────┘                                └─────────────────┘
```

- **Zero Router Port Forwarding:** Immune to internet botnets scanning open ports.
- **Works Behind CGNAT:** Works even on restrictive mobile hotspots, 5G home internet, or Starlink.
- **MagicDNS:** Reach your server using friendly names like `http://homelab` instead of memorizing IP addresses.
- **Free for Personal Use:** Tailscale's free plan supports up to 100 devices and 3 users.

---

## 2. Step-by-Step Installation on Ubuntu Server

### Step A: Install the Tailscale Client
Run the official automated install script on your Ubuntu server:

```bash
curl -fsSL https://tailscale.com/install.sh | sh
```

### Step B: Authenticate the Server
Start Tailscale and generate an authentication link:

```bash
sudo tailscale up
```

You will see an output like:
```text
To authenticate, visit:
https://login.tailscale.com/a/0123456789abcdef
```

1. Copy that URL into your browser.
2. Sign in with your Google, GitHub, or Microsoft account.
3. Click **Connect** to authorize your server.

---

## 3. Verify Connection & MagicDNS

Check the assigned 100.x.y.z Tailscale IP address:

```bash
# Check status and connected devices on your tailnet
tailscale status

# View your server's Tailscale IPv4 address
tailscale ip -4
```

---

## 4. Connect from Your Client Devices (Phone, Laptop, Mac)

1. Download the **Tailscale app** on your phone (iOS / Android) or laptop (macOS / Windows / Linux) from [tailscale.com/download](https://tailscale.com/download).
2. Sign in with the **exact same account** you used for your server.
3. Flip the switch to **Connected**.
4. Test connectivity:
   - Disconnect your phone from home Wi-Fi (switch to cellular data 4G/5G).
   - In your phone's browser, open `http://<YOUR-SERVER-TAILSCALE-IP>` (e.g. `http://100.85.20.15`).
   - Your CasaOS dashboard or web services will load securely!

---

## 5. Supercharge Tailscale: Useful Features

### Feature A: Tailscale SSH (Passwordless, Zero-Key SSH)
Tailscale can handle SSH authentication automatically without managing individual SSH keys:

```bash
# Enable Tailscale SSH on your server
sudo tailscale set --ssh
```
Now, from any device connected to your tailnet, you can simply run:
```bash
tailscale ssh <username>@<server-name>
```

### Feature B: Subnet Router (Access all Home LAN devices remotely)
If you want to reach devices in your home that cannot install Tailscale (e.g., smart plugs, IP cameras, printer):

1. Enable IP forwarding on Ubuntu:
   ```bash
   echo 'net.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf
   echo 'net.ipv6.conf.all.forwarding = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf
   sudo sysctl -p /etc/sysctl.d/99-tailscale.conf
   ```
2. Advertise your home network subnet (replace `192.168.1.0/24` with your router subnet):
   ```bash
   sudo tailscale up --advertise-routes=192.168.1.0/24 --accept-routes
   ```
3. Open the [Tailscale Admin Console](https://login.tailscale.com/admin/machines), click the three dots (`...`) next to your server -> **Edit route settings**, and check the advertised subnet box.

### Feature C: Disable Key Expiry for Permanent Servers
By default, Tailscale expires device authentication every 180 days for security. For a 24/7 homelab server:
1. Go to [Tailscale Machines Admin](https://login.tailscale.com/admin/machines).
2. Click the `...` menu next to your server.
3. Select **Disable key expiry**.

---

## 6. Running Tailscale inside Docker (Alternative Method)

If you prefer running Tailscale as an isolated Docker container instead of a host package, see the ready-to-use template in [`docker/tailscale-compose.example.yml`](../docker/tailscale-compose.example.yml):

```bash
cd docker
cp tailscale-compose.example.yml docker-compose.tailscale.yml
# Add your TAILSCALE_AUTHKEY to .env and run:
docker compose -f docker-compose.tailscale.yml up -d
```

---

## 7. Useful Tailscale Commands

| Command | What it does |
|---|---|
| `tailscale status` | View active devices and their Tailscale IPs |
| `tailscale ip -4` | Display this machine's Tailscale IPv4 address |
| `tailscale ping <machine-name>` | Test latency and connectivity to another tailnet node |
| `sudo tailscale up` | Connect to the tailnet |
| `sudo tailscale down` | Disconnect from the tailnet |
| `tailscale netcheck` | Diagnose network, NAT traversal, and DERP relay performance |

👉 **Next Step:** Proceed to [08 — Cloudflare Tunnel Guide](08-cloudflare-tunnel.md) if you want to host public websites!
