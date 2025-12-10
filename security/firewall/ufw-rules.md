# UFW Firewall Configuration

The following firewall rules were applied to secure the Linux server:

## Default Policy
- Deny all incoming connections
- Allow all outgoing connections

## Allowed Services
- SSH (22/tcp)
- HTTP (80/tcp)
- HTTPS (443/tcp)
- Grafana (3000/tcp)
- Prometheus (9091/tcp)
- Node Exporter (9100/tcp)
- WireGuard VPN (51820/udp)

## Commands Used

```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing

sudo ufw allow 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow 3000/tcp
sudo ufw allow 9091/tcp
sudo ufw allow 9100/tcp
sudo ufw allow 51820/udp

sudo ufw enable
sudo ufw status verbose

