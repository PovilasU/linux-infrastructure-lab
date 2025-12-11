# Linux Infrastruktūros Laboratorija – Povilas

Sveiki atvykę į **Povilo Linux Infrastruktūros Laboratoriją** – pilnai sukonstruotą infrastruktūros projektą, demonstruojantį profesinius įgūdžius, reikalingus sistemų administratoriaus, DevOps ar IT infrastruktūros specialisto rolėms.

🎥 **Projekto video demo:**\
https://www.youtube.com/watch?v=Q01gAhVwjEw


Šis projektas buvo sukurtas taip, kad **100% atitiktų realų darbo aprašymą**, įskaitant:

- Linux (Debian/Ubuntu) administravimą  
- Web, DNS, MariaDB, Exim4 el. pašto servisus  
- VPN (WireGuard) ir saugumo valdymą  
- Monitoringą (Prometheus + Grafana + Node Exporter)  
- Atsarginių kopijų sistemą (Restic)  
- Healthcheck API kūrimą  
- Tinklo, serviso ir našumo diagnostiką  
- Sisteminį planavimą, diegimą ir dokumentavimą  

Projektas sukonstruotas kaip **mini įmonės IT infrastruktūra**, su realiais servisais, procesais, automatizacija ir profesionalia dokumentacija.

---

# 🗺️ Architektūros schema

```
                 +---------------------------+
                 |       Klientų įrenginiai  |
                 +-------------+-------------+
                               |
                               v
                   +-----------------------+
                   |        UFW Firewall   |
                   | 22,80,443,3000,9091   |
                   | 9100,51820 leidimai   |
                   +-----------+-----------+
                               |
                               v
+------------------------ Linux Serveris ------------------------+
|                                                              |
|  +-------------------+    +---------------------------+      |
|  |  Web (Apache)     |    |      Exim4 Paštas         |      |
|  |  Healthcheck API  |    |  Vietinis pristatymas     |      |
|  +---------+---------+    +-------------+-------------+      |
|            |                             |                  |
|            v                             v                  |
|    +---------------+             +----------------------+    |
|    | MariaDB       |             | Bind9 DNS Server     |    |
|    | DB testai     |             | demo.local zona      |    |
|    +-------+-------+             +----------+-----------+    |
|            |                                 |              |
|            v                                 v              |
|    +-------------------+       +---------------------------+ |
|    | Restic Backups    |       | WireGuard VPN (wg0)       | |
|    | Automatizacija    |       | saugus tunelis            | |
|    +-------------------+       +-------------+-------------+ |
|                                              |               |
|                                              v               |
|                                      +----------------+       |
|                                      | Monitoring     |       |
|                         +------------+ Prometheus     +-------+
|                         |            | Node Exporter  |
|                         |            | Grafana        |
|                         |            +----------------+
+--------------------------------------------------------------+
```

---

# 📁 Projekto struktūra

```
linux-infrastructure-lab/
│
├── monitoring/
│   ├── prometheus.yml
│   ├── node_exporter.service
│   ├── screenshots/
│
├── backups/
│   ├── backup.sh
│   ├── README.md
│   ├── screenshots/
│
├── dns/
│   ├── db.demo.local
│   ├── named.conf.local
│   ├── README.md
│   ├── screenshots/
│
├── email/
│   ├── README.md
│   ├── screenshots/
│
├── vpn/
│   ├── README.md
│   ├── screenshots/
│
├── security/
│   ├── firewall/
│       ├── ufw-rules.md
│       ├── screenshots/
│
├── api-healthcheck/
│   ├── public/health.php
│   ├── check.sh
│   ├── README.md
│   ├── screenshots/
│
└── README.md (šis failas)
```

---

# 🖥️ 1. Monitoringas  
**Prometheus + Grafana + Node Exporter**

### 🔧 Kas padaryta
- Įdiegtas Node Exporter
- Sukonfigūruotas Prometheus su `prometheus.yml`
- Grafana su Node Exporter dashboard ID: 1860
- Sukurtos systemd paslaugos

### 📸 Ekrano nuotraukos

![Grafana Dashboard](monitoring/screenshots/grafana-dashboard.png)  
![Prometheus Targets](monitoring/screenshots/prometheus-targets.png)  
![Node Exporter Metrics](monitoring/screenshots/node-exporter.png)

---

# 💾 2. Atsarginės kopijos (Restic)

### 🔧 Kas padaryta
- Sukurtas `backup.sh` skriptas
- Restic saugykla /repo (failų sistema)
- Atsarginės kopijos kasdien per cron
- Log'ai `/var/log/restic-backup.log`

### Komanda inicijuoti repozitoriją:
```
restic init -r /repo
```

### Komanda atlikti kopiją:
```
restic backup /etc /var/www /home
```

### 📸 Screenshot
![Restic Log](backups/screenshots/backup-log.png)

---

# 🌐 3. DNS – Bind9

### 🔧 Kas padaryta:
- Sukurta zona: **demo.local**
- Įrašai: A, NS, MX, CNAME
- Zona validuota `named-checkzone`

### 📸 Screenshot
![DNS Zone File](dns/screenshots/dns-zone.png)  
![dig Query](dns/screenshots/dig-query.png)

---

# ✉️ 4. El. paštas – Exim4

### 🔧 Kas padaryta:
- Sukonfigūruota vietinė pašto sistema
- Pristatymas į `/var/mail/povilas`
- Testavimas komanda:
```
echo "Testas" | mail -s "Tema" povilas
```

### 📸 Screenshot
![Exim Config](email/screenshots/exim4-config.png)  
![Mail Delivery](email/screenshots/exim4-mail.png)

---

# 🔐 5. Firewall – UFW

### 🔧 Atidaryti portai:
```
22 (SSH)
80, 443 (Web)
3000 (Grafana)
9091 (Prometheus)
9100 (Node Exporter)
51820 (WireGuard VPN)
```

### 📸 Screenshot
![UFW Status](security/firewall/screenshots/ufw-status.png)

---

# 🕸️ 6. VPN – WireGuard

### 🔧 Kas padaryta:
- Sugeneruoti raktai:
```
wg genkey | sudo tee server_private.key
sudo cat server_private.key | wg pubkey | sudo tee server_public.key
```

- Sukurtas `/etc/wireguard/wg0.conf`

### Minimalus serverio konfigas:
```
[Interface]
Address = 10.0.0.1/24
ListenPort = 51820
PrivateKey = <server_private_key>
```

### Paleidimas:
```
sudo systemctl enable wg-quick@wg0
sudo systemctl start wg-quick@wg0
```

### 📸 Screenshot
![WG Show](vpn/screenshots/wg-show.png)  
![WG Status](vpn/screenshots/wg-status.png)

---

# 🧪 7. Healthcheck API – PHP

### 🔧 Kas padaryta:
- Apache virtual host
- `/health/health.php` scriptas tikrina:
  - PHP veikimą
  - MariaDB ryšį
  - Serverio laiką
  - Hostname

### Testavimas:
```
curl http://localhost/health/health.php
./check.sh
```

### 📸 Screenshot
![Health Output](api-healthcheck/screenshots/health-output.png)

---

# 🗄️ 8. MariaDB

- MariaDB instaliacija  
- Sukurtas DB naudotojas  
- API tikrina MySQL prisijungimą  

### Komanda testuoti:
```
mysql -u root -p -e "SHOW DATABASES;"
```

---

# 🔒 9. Saugumo priemonės

- UFW firewall  
- WireGuard VPN  
- Restic šifruotos kopijos  
- Apriboti servisų leidimai  
- Konfigūruoti systemd servisai  
- Vengta root teisių ten, kur nereikia  

---

# 🎯 10. Darbo aprašymo atitikimas

Šis projektas įrodo:

✔ Gebėjimą administruoti Linux sistemas  
✔ Gebėjimą valdyti Exim4, DNS, web serverius  
✔ VPN konfiguravimą ir priežiūrą  
✔ Monitoringą ir našumo analizę  
✔ Saugumo praktikų taikymą  
✔ Atsarginių kopijų strategijos įgyvendinimą  
✔ Incidentų diagnostiką  
✔ Dokumentaciją ir procesų valdymą  

---

# 👨‍💻 Autorius
**Povilas**  
Linux sistemų administratorius & PHP programuotojas  

Šis projektas yra mano profesinio portfolio dalis.

---

# 📄 Licencija
Projektą leidžiama naudoti mokymosi ir demonstraciniais tikslais.
