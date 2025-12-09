# DNS Zone Demo (Bind9)

This directory contains a sample DNS zone configuration for the domain `demo.local`.

## Records included:
- NS record for ns1.demo.local
- A records for ns1, web, api, mail
- MX record for mail.demo.local

Configured on Bind9 with:
- named.conf.local zone definition
- db.demo.local zone file

