# Services

## Ports

- 22 (ssh)
- 53 (dns - adguard home)
- 80 (nginx)
- 443 (nginx)
- 853 (dns-over-tls, dns-over-quic)
- 3000 (adguard home web interface)
- 4000 (uptime kuma)
- 5353 (avahi)
- 8443 (dns-over-https)
- 61208 (glances)

## DNS Encryption

AdGuard Home is configured with encrypted DNS protocols:

- **DNS-over-TLS (DoT)**: `tls://dns.sua.sh:853`
- **DNS-over-HTTPS (DoH)**: `https://dns.sua.sh:8443/dns-query`
- **DNS-over-QUIC (DoQ)**: Port 853 (UDP)

See [adguardhome/DNS-ENCRYPTION.md](./adguardhome/DNS-ENCRYPTION.md) for details.
