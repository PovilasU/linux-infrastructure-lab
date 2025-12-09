# Linux Infrastructure Lab

Šis projektas – mano mini infrastruktūros laboratorija, skirta pademonstruoti Linux sistemų administravimo ir PHP backend įgūdžius.

Projektas sukurtas kaip demo potencialiam darbdaviui, dirbant hibridinėje pozicijoje: **Systems Engineer / PHP Developer**.

## Komponentai

### 1. Monitoring (Prometheus + Node Exporter + Grafana)

- Įdiegtas **Node Exporter** Linux serverio metrikų surinkimui.
- **Prometheus** renka duomenis iš `localhost:9100`.
- **Grafana** naudoja Prometheus kaip data source ir rodo CPU, RAM, disk, network grafiką.
- Importuotas „Node Exporter Full“ dashboard (ID: 1860).

Failai:
- `monitoring/node_exporter.service`
- `monitoring/prometheus.yml`
- `monitoring/screenshots/` – Grafana dashboard ekrano nuotrauka.

### 2. Backup sistema (Restic)

- Naudojamas **Restic** atsarginių kopijų darymui.
- Backup’inami katalogai: `/etc`, `/var/www`, `/home`.
- Sukurtas `backup.sh` skriptas su retencijos politika:
  - 7 daily
  - 4 weekly
  - 6 monthly
- Sukurtas cron job kiekvienai dienai 03:00.
- Rezultatai rašomi į `/var/log/restic-backup.log`.

Failai / idėja:
- `backups/README.md` – dokumentacija.

### 3. DNS (Bind9 demo zona)

- Įdiegtas **Bind9** DNS serveris.
- Sukurta pavyzdinė zona `demo.local` su:
  - NS įrašu `ns1.demo.local`
  - A įrašais `ns1`, `web`, `api`, `mail`
  - MX įrašu `mail.demo.local`.

Failai:
- `dns/db.demo.local`
- `dns/named.conf.local`
- `dns/README.md`

### 4. Healthcheck API (PHP be framework'o)

- Sukurtas paprastas `health.php` endpoint’as, grąžinantis JSON su:
  - `status`
  - `php_version`
  - `server_time`
  - `hostname`
  - `database` (jei prisijungimas pavyksta)
- Papildomas CLI skriptas `check.sh` periodiškai kviečia endpointą ir fiksuoja, ar sistema veikia **OK**, ar yra **DEGRADED**.

Šiuo metu DB testas specialiai paliktas taip, kad klaidos atveju grąžintų `status = "DEGRADED"` – tai leidžia parodyti, kaip healthcheck aptinka problemą su duomenų baze.

Failai:
- `api-healthcheck/public/health.php`
- `api-healthcheck/check.sh`
- `api-healthcheck/README.md`

## Naudotos technologijos

- **OS:** Linux (Ubuntu/Debian)
- **Monitoring:** Prometheus, Node Exporter, Grafana
- **Backup:** Restic
- **DNS:** Bind9
- **Web serveris:** Apache
- **Kalba:** PHP 8
- **DB:** MariaDB (healthcheck testui)
- **Versijavimas:** Git

## Tikslas

Šiuo projektu noriu parodyti, kad galiu:

- administruoti Linux serverius,
- diegti ir konfigūruoti monitoringą,
- užtikrinti atsarginių kopijų darymą,
- konfigūruoti DNS,
- kurti ir palaikyti backend / healthcheck API,
- dirbti hibridinėje sistemos administratoriaus ir PHP programuotojo pozicijoje.

