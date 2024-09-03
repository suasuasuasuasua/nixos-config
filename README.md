# NixOS Configuration

My current configuration is based on this [starter repo](https://github.com/Misterio77/nix-starter-configs).

To start, install `git` and `nix-flakes`

```bash
# Should be 2.4+
nix --version
export NIX_CONFIG="experimental-features = nix-command flakes"

# Update flakes
nix flake update

# Apply system configurations
nixos-rebuild switch --flake .#nixos
```
