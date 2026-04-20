# steps

1. sign up for an account on Hetzner
2. perform all identity verifications
3. create a new server of any kind
   - get ipv4 address if needed
   - prefer US based server
   - add pub keys

4. run the deployment script

    ```bash
    nix run github:nix-community/nixos-anywhere -- \
        --flake .#vps \
        ipaddress
    ```
