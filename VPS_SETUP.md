# VPS + WireGuard Setup Guide

This guide walks through setting up a VPS to expose Gitea publicly while
keeping your home lab private.

## Architecture

```text
Public Internet →
  VPS nginx (10.1.0.1:443) →
    WireGuard tunnel →
      Lab (10.1.0.2:3001 Gitea)
```

## Prerequisites

- A VPS with NixOS support (Hetzner Cloud recommended)
- Your home lab `lab` server already configured with NixOS
- Namecheap domain (`sua.dev`) configured

## Step 1: Generate WireGuard Keys

On your home lab, generate a keypair for the new setup:

```bash
wg genkey | tee /tmp/lab_private_key | wg pubkey > /tmp/lab_public_key
```

Generate a keypair for the VPS (do this on a secure machine, or after VPS is
set up):

```bash
wg genkey | tee /tmp/vps_private_key | wg pubkey > /tmp/vps_public_key
```

## Step 2: Update VPS Configuration Files

### 1. Update `configurations/nixos/vps/services/wireguard.nix`

Replace `REPLACE_WITH_LAB_PUBLIC_KEY` with the lab public key from step 1:

```nix
labPublicKey = "YOUR_LAB_PUBLIC_KEY_HERE";
```

### 2. Create `configurations/nixos/vps/secrets.yaml`

Add the VPS private key to sops secrets:

```yaml
wireguard:
  vps_private_key: YOUR_VPS_PRIVATE_KEY_HERE
```

Then encrypt it with sops (you may need to set up sops first):

```bash
sops -e configurations/nixos/vps/secrets.yaml \
  > configurations/nixos/vps/secrets.yaml
```

### 3. Update `configurations/nixos/vps/hardware-configuration.nix`

On the VPS, after initial NixOS install, generate the hardware config:

```bash
nixos-generate-config --root / \
  --file configurations/nixos/vps/hardware-configuration.nix
```

## Step 3: Update Lab Configuration

### 1. Update WireGuard Interface

Replace your current
`configurations/nixos/lab/services/wireguard/interfaces.nix` with the content
from `interfaces-updated.nix`:

```bash
cp configurations/nixos/lab/services/wireguard/interfaces-updated.nix \
  configurations/nixos/lab/services/wireguard/interfaces.nix
```

### 2. Update Values in `interfaces.nix`

Replace the placeholders in the updated config:

- `REPLACE_WITH_VPS_PUBLIC_KEY` → VPS public key from step 1
- `VPS_PUBLIC_IP` → Your VPS's public IP address

Example:

```nix
peers = [
  {
    name = "vps-server";
    publicKey = "abc123def456...";  # VPS public key
    endpoint = "203.0.113.42:51820";  # VPS public IP
    allowedIPs = [ "10.1.0.0/24" ];
    persistentKeepalive = 25;
  }
];
```

### 3. Update Lab WireGuard Default Config

Update `configurations/nixos/lab/services/wireguard/default.nix` - lab no
longer needs to be a NAT server:

Remove or comment out the NAT section (since lab is now a client):

```nix
# Remove this block - lab is a client now, not a server
# networking.nat = {
#   enable = true;
#   externalInterface = "enp4s0";
#   internalInterfaces = [ "wg0" ];
# };
```

**But keep existing clients on lab!** If you want your phone/laptop still
connecting to lab's old WireGuard:

- Keep lab's old WireGuard interface (or set up a separate one)
- Lab can be both a client of VPS AND have its own local clients

## Step 4: Update DNS

In Namecheap, update the CNAME record for `gitea.sua.dev`:

**Before (pointing to home):**

- Name: `gitea`
- Value: `vpn-sua.duckdns.org`

**After (pointing to VPS):**

- Name: `gitea`
- Value: `vps.sua.dev` (or your VPS provider's domain, or the VPS IP directly)

Or create an A record pointing directly to the VPS IP.

## Step 5: Deploy

### On Lab

```bash
sudo nixos-rebuild switch --flake .#lab
```

Lab will reconnect to the VPS and get the VPN IP `10.1.0.2`.

### On VPS

After VPS is provisioned with NixOS, ensure the flake is available:

```bash
cd /root/path/to/nix-config
sudo nixos-rebuild switch --flake .#vps
```

## Step 6: Verify

### Check Lab WireGuard Connection

```bash
wg show wg0  # Should show active connection to VPS
ip addr show wg0  # Should show 10.1.0.2
```

### Check VPS WireGuard

```bash
ssh justinhoang@VPS_IP
wg show wg0  # Should show lab peer connected
```

### Test Gitea Proxy

```bash
curl https://gitea.sua.dev  # Should reach lab's gitea through VPS
```

## Troubleshooting

**Lab can't connect to VPS:**

- Verify WireGuard keys are correct
- Check VPS firewall allows 51820 UDP
- Verify VPS public IP in lab's config
- Check lab has outbound internet access

**nginx shows upstream timeout:**

- Verify lab is connected to VPN (check `wg show`)
- Ping lab from VPS: `ping 10.1.0.2`

**SSL certificate issues:**

- VPS nginx manages the cert for `gitea.sua.dev`
- Lab's gitea doesn't need the cert anymore (traffic is encrypted by nginx)
- Cert renewal happens on VPS

## Optional: Keep Lab's Local WireGuard

If you want your phone/laptop still connecting to lab directly:

Create a second interface on lab (`wg1`):

```nix
wg1 = {
  ips = [ "10.100.0.1/24" ];
  listenPort = 51821;
  # ... original server config with existing clients ...
};
```

This keeps both setups: lab as client to VPS + lab as server for local clients.
