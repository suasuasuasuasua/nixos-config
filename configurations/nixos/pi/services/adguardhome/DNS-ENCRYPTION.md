# DNS Encryption in AdGuard Home

## What is DNS Encryption?

DNS (Domain Name System) encryption is a method of securing DNS queries and responses to prevent eavesdropping, tampering, and manipulation. Traditional DNS queries are sent in plain text, making them vulnerable to:

- **Man-in-the-Middle (MITM) attacks**: Attackers can intercept and modify DNS responses
- **DNS spoofing**: Malicious actors can redirect users to fake websites
- **Privacy leaks**: ISPs and network operators can monitor all your DNS queries
- **Censorship**: Network operators can block access to specific domains

## Why is DNS Encryption Important?

1. **Privacy Protection**: Encrypted DNS prevents ISPs, network administrators, and other third parties from seeing which websites you're visiting
2. **Security**: Protects against DNS hijacking and spoofing attacks
3. **Integrity**: Ensures DNS responses haven't been tampered with in transit
4. **Bypass Censorship**: Can help circumvent DNS-based blocking in restricted networks
5. **Compliance**: Required for certain security standards and regulations

## DNS Encryption Protocols

### DNS-over-TLS (DoT)

**Port**: 853  
**Standard**: RFC 7858 (2016)

**How it works**: DoT uses TLS (Transport Layer Security) to encrypt DNS traffic, similar to HTTPS but on a dedicated port (853).

**Advantages**:
- Dedicated port makes it easy to identify and prioritize DNS traffic
- Well-established TLS protocol
- Good firewall support
- Lower overhead than DoH

**Disadvantages**:
- Easy to block (dedicated port 853)
- May be blocked by restrictive firewalls
- Less commonly supported by operating systems than DoH

**Use cases**: Best for networks where you control the firewall and want efficient, dedicated encrypted DNS.

### DNS-over-HTTPS (DoH)

**Port**: 443  
**Standard**: RFC 8484 (2018)

**How it works**: DoH encapsulates DNS queries in HTTPS requests, making them indistinguishable from regular web traffic.

**Advantages**:
- Harder to block (uses standard HTTPS port 443)
- Looks like regular web traffic
- Better for bypassing restrictive networks
- Wide client support (browsers, OS)

**Disadvantages**:
- Higher overhead (HTTP headers + TLS)
- More difficult to monitor/debug
- Mixing DNS with web traffic can complicate network management

**Use cases**: Best for privacy-focused users, mobile devices, and environments with restrictive firewalls.

### DNS-over-QUIC (DoQ)

**Port**: 853 (UDP)  
**Standard**: RFC 9250 (2022)

**How it works**: DoQ uses QUIC protocol (the basis of HTTP/3) for encrypted DNS over UDP.

**Advantages**:
- Faster connection establishment than TCP-based protocols
- Better performance on unreliable networks
- Built-in connection migration (good for mobile)
- Lower latency

**Disadvantages**:
- Newer protocol with less client support
- May be blocked by firewalls that don't recognize QUIC
- More complex to implement and debug

**Use cases**: Best for modern networks and mobile devices where performance is critical.

### HTTPS (for Web Interface)

**Port**: 443  
**Protocol**: Standard HTTPS

**How it works**: Secures the AdGuard Home web administration interface using TLS.

**Purpose**: Protects the admin credentials and configuration from eavesdropping when accessing the web interface.

## Protocol Comparison Table

| Feature | DoT | DoH | DoQ |
|---------|-----|-----|-----|
| **Port** | 853/TCP | 443/TCP | 853/UDP |
| **Protocol** | TLS over TCP | HTTPS | QUIC (UDP) |
| **Year** | 2016 | 2018 | 2022 |
| **Overhead** | Low | Medium | Low |
| **Latency** | Low | Medium | Very Low |
| **Blockability** | Easy | Hard | Medium |
| **Client Support** | Good | Excellent | Limited |
| **Network Transparency** | High | Low | Medium |
| **Mobile Performance** | Good | Good | Excellent |

## Tradeoffs and Recommendations

### Use DoT if:
- You control your network infrastructure
- You want efficient, low-overhead DNS encryption
- You need easy network monitoring and debugging
- Your clients support DoT

### Use DoH if:
- You're on a restrictive network
- Privacy is your top priority
- You want maximum compatibility
- Your clients are browsers or modern OS

### Use DoQ if:
- You have modern clients
- Performance is critical
- You're on mobile/unreliable networks
- You want the latest technology

### Use Multiple Protocols:
For maximum flexibility, enable all protocols and let clients choose what works best for their environment.

## Implementation in This Configuration

This AdGuard Home instance is configured with:

1. **DNS-over-TLS (DoT)** on port 853
2. **DNS-over-HTTPS (DoH)** on port 8443
3. **DNS-over-QUIC (DoQ)** on port 853 (UDP)
4. **HTTPS** for the web interface on port 443 (via nginx reverse proxy)

The configuration uses Let's Encrypt certificates via ACME, automatically renewed and managed by NixOS.

### Connection Examples

Once configured, clients can connect using:

**DoT**:
```
tls://dns.sua.sh:853
```

**DoH**:
```
https://dns.sua.sh:8443/dns-query
```

**Web Interface**:
```
https://adguardhome.sua.sh
```

## Security Considerations

1. **Certificate Validity**: Ensure certificates are properly renewed via ACME
2. **Port Forwarding**: Only expose necessary ports (53, 443, 853)
3. **Access Control**: Use `allowed_clients` to restrict who can use your DNS
4. **Rate Limiting**: Already configured to prevent abuse
5. **DNSSEC**: Consider enabling for additional validation
6. **Logging**: Monitor query logs for suspicious activity

## References

- [RFC 7858 - DNS over TLS](https://datatracker.ietf.org/doc/html/rfc7858)
- [RFC 8484 - DNS Queries over HTTPS](https://datatracker.ietf.org/doc/html/rfc8484)
- [RFC 9250 - DNS over Dedicated QUIC](https://datatracker.ietf.org/doc/html/rfc9250)
- [AdGuard Home Encryption Documentation](https://github.com/AdguardTeam/AdGuardHome/wiki/Encryption)
