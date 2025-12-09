# API Healthcheck (PHP)

Paprastas `health.php` endpoint'as, skirtas tikrinti API ir serverio būklę.

Grąžina JSON su:
- `status` (`OK` arba `DEGRADED`)
- `php_version`
- `server_time`
- `hostname`
- `database` (jei pavyksta prisijungti prie DB)

Papildomas `check.sh` skriptas komandų eilutėje kviečia endpointą ir išveda trumpą statusą, kuris gali būti naudojamas cron užduotyse ar monitoringui.

