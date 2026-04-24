# Hetzner Cloud VPS 1

A Hetzner VPS that functions as a gitea runner.

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
       --flake .#hetzner-cloud-vps1 \
       ipaddress
   ```

1. Redeploy the configuration

   ```bash
   just deploy hetzner-cloud-vps0 <user>@<ip>
   ```
