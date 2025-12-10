# WireGuard VPN Demo

This directory contains a minimal WireGuard VPN configuration that demonstrates secure tunneling setup, key management, network interface configuration, and systemd unit handling.  
WireGuard coverage is included because the System Administrator role requires VPN and infrastructure security management.

---

## 🔧 1. Install WireGuard

```bash
sudo apt install wireguard -y
```

---

## 🔑 2. Generate Server Keys

```bash
wg genkey | sudo tee /etc/wireguard/server_private.key
sudo cat /etc/wireguard/server_private.key | wg pubkey | sudo tee /etc/wireguard/server_public.key
sudo chmod 600 /etc/wireguard/server_private.key
```

- `server_private.key` – private key used by the VPN interface  
- `server_public.key` – public key shared with clients  

---

## ⚙️ 3. Server Configuration (`wg0.conf`)

File: `/etc/wireguard/wg0.conf`

```ini
[Interface]
Address = 10.0.0.1/24
ListenPort = 51820
PrivateKey = <server_private_key>
SaveConfig = true
```

Notes:

- This configuration sets up a minimal WireGuard interface.
- No peers are configured here, because this project focuses on demonstrating server-side setup and service handling.
- `<server_private_key>` is taken from `/etc/wireguard/server_private.key`.

---

## 🚀 4. Enable & Start the VPN

Enable at boot:

```bash
sudo systemctl enable wg-quick@wg0
```

Start immediately:

```bash
sudo systemctl start wg-quick@wg0
```

Check status:

```bash
sudo systemctl status wg-quick@wg0
```

---

## 🔍 5. Verify Interface Status

```bash
sudo wg show
```

You should see:

- interface wg0  
- public key  
- listening port  
- assigned IP (10.0.0.1/24)

---

## 🖼️ Screenshots

The following screenshots are included:

- `wg-show.png` — output of `wg show`
- `wg-status.png` — output of `systemctl status wg-quick@wg0`

These screenshots demonstrate:

- running VPN interface  
- correct systemd service integration  
- properly loaded configuration  

---

## 📌 Purpose

This VPN demo shows:

- knowledge of Linux network interfaces  
- secure key management  
- ability to configure system services  
- understanding of VPN access methods  
- basic infrastructure security principles  

Together with monitoring, backups, DNS, health-check API, and firewall, this VPN setup helps fully satisfy the System Administrator role requirements.

