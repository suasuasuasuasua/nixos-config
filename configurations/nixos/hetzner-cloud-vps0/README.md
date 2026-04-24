# VPS

A Hetzner VPS that acts as a public reverse proxy for lab services via a
WireGuard tunnel. Lab services stay private; the VPS terminates TLS and
forwards traffic over the tunnel.

Currently proxying and serving the following:

- [gitea.sua.dev](https://gitea.sua.dev)
- [sua.dev](https://sua.dev)

## Notes

1. Sign up for an account on Hetzner

1. Perform all identity verifications

1. Create a new server of any kind

   - Get ipv4 address if needed
   - Prefer US based server
   - Add pub keys

1. Run the deployment script

   ```bash
   nix run github:nix-community/nixos-anywhere -- \
       --flake .#hetzner-cloud-vps0 \
       ipaddress
   ```

1. Redeploy the configuration

   ```bash
   just deploy hetzner-cloud-vps0 <user>@<ip>
   ```
