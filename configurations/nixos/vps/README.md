# VPS

A Hetzner VPS that acts as a public reverse proxy for lab services via a
WireGuard tunnel. Lab services stay private; the VPS terminates TLS and
forwards traffic over the tunnel.

## Architecture

```text
Public Internet
  → VPS nginx (sua.dev, TLS)
    → WireGuard tunnel (10.101.0.0/24)
      → Lab services (10.101.0.2)
```

Currently proxied services:

| Domain          | Lab target        |
|-----------------|-------------------|
| `gitea.sua.dev` | `10.101.0.2:3001` |

## WireGuard tunnel

| Machine | Interface | IP              |
|---------|-----------|----             |
| VPS     | `wg0`     | `10.101.0.1/24` |
| Lab     | `wg1`     | `10.101.0.2/24` |

VPS is the listener (`listenPort = 51820`). Lab initiates the connection and
sends keepalives every 25 seconds (lab is behind NAT).

Private keys are managed with sops:

- VPS key: `configurations/nixos/vps/secrets.yaml` → `wireguard/private_key`
- Lab key: `configurations/nixos/lab/secrets.yaml` → `wireguard/private_key`

## Deploying

```bash
# From nix-config on any machine with access
nixos-rebuild switch --flake .#vps --target-host admin@vps.sua.dev
```

## Verifying the tunnel

On VPS:

```bash
sudo wg show wg0
# Should show lab peer with a recent handshake and transfer stats
ping 10.101.0.2
```

On lab:

```bash
sudo wg show wg1
# Should show VPS peer with persistent keepalive every 25 seconds
ping 10.101.0.1
```

## Adding a new proxied service

1. Add a `virtualHosts` entry in `services/nginx.nix` pointing to `10.101.0.2:<port>`
1. Ensure the service port is open on lab's firewall
1. Rebuild VPS
