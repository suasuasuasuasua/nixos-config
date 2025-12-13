# AdGuard Home Configuration

This directory contains the NixOS configuration for AdGuard Home, a network-wide ad and tracker blocker.

## Files

- **default.nix**: Main service configuration including ACME certificates and nginx reverse proxy
- **settings.nix**: AdGuard Home settings (DNS, TLS, filtering, etc.)
- **filters.nix**: Ad-blocking and tracking filter lists
- **rewrites.nix**: DNS rewrites for local services
- **DNS-ENCRYPTION.md**: Comprehensive guide to DNS encryption protocols

## Features

### DNS Encryption

This configuration enables multiple encrypted DNS protocols:

- **DNS-over-TLS (DoT)**: Port 853 - `tls://dns.sua.sh:853`
- **DNS-over-HTTPS (DoH)**: Port 443 - `https://dns.sua.sh/dns-query`
- **DNS-over-QUIC (DoQ)**: Port 853 (UDP)

See [DNS-ENCRYPTION.md](./DNS-ENCRYPTION.md) for detailed information about each protocol.

### SSL/TLS Certificates

Certificates are automatically provisioned and renewed via ACME (Let's Encrypt):
- Certificate for `dns.sua.sh` used for DoT/DoH/DoQ (AdGuard Home direct access)
- Certificate for `adguardhome.sua.sh` used for the web interface (via nginx reverse proxy)

### Access Points

- **Web Interface**: `https://adguardhome.sua.sh` (via nginx reverse proxy)
- **DNS-over-TLS (DoT)**: `tls://dns.sua.sh:853`
- **DNS-over-HTTPS (DoH)**: `https://dns.sua.sh:8443/dns-query`
- **DNS-over-QUIC (DoQ)**: `dns.sua.sh:853` (UDP)

### Ports

**TCP Ports:**
- 53: Standard DNS
- 68: DHCP client
- 443: HTTPS web interface (nginx reverse proxy to port 3000)
- 853: DNS-over-TLS (DoT)
- 3000: AdGuard Home web interface (localhost only, proxied by nginx)
- 8443: DNS-over-HTTPS (DoH) and direct HTTPS access to AdGuard Home

**UDP Ports:**
- 53: Standard DNS
- 67: DHCP server
- 68: DHCP client
- 853: DNS-over-QUIC (DoQ)

## Client Configuration

### Android
1. Go to Settings → Network & Internet → Private DNS
2. Select "Private DNS provider hostname"
3. Enter: `dns.sua.sh`

### iOS
Install a DNS-over-HTTPS profile or use apps like AdGuard app with custom DNS settings.

### Firefox
1. Settings → Privacy & Security → DNS over HTTPS
2. Set custom DNS: `https://dns.sua.sh:8443/dns-query`

### macOS/Linux
Add to `/etc/systemd/resolved.conf`:
```ini
[Resolve]
DNS=192.168.0.250
DNSOverTLS=yes
```

Or use `dns.sua.sh:853` for DoT if your resolver supports it.

### Windows 11
Settings → Network & Internet → Wi-Fi/Ethernet → DNS settings
- Add encrypted DNS: `dns.sua.sh`

## Security Features

- **Rate Limiting**: 20 queries per second per client
- **DNSSEC**: Disabled by default (can be enabled in settings.nix)
- **Blocked Queries**: Refuses ANY queries to prevent DNS amplification attacks
- **Trusted Proxies**: Only localhost/loopback
- **Force HTTPS**: Admin interface requires HTTPS
- **Allow Unencrypted DoH**: Disabled for security

## Upstream DNS

Currently configured to use Quad9 DNS over HTTPS:
- `https://dns10.quad9.net/dns-query`

Bootstrap DNS servers (for resolving the upstream DNS hostname):
- 9.9.9.10
- 149.112.112.10
- 2620:fe::10
- 2620:fe::fe:10

## Maintenance

### Updating Filters
Filters are automatically updated every 24 hours. Manual updates can be triggered from the web interface.

### Certificate Renewal
ACME certificates are automatically renewed by NixOS when they're close to expiration.

### Viewing Logs
```bash
journalctl -u adguardhome.service -f
```

## Modifying Configuration

1. Edit the relevant `.nix` file in this directory
2. Run `just switch` to rebuild the system
3. The service will automatically reload with new settings
