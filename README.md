# NixOS Configuration

My current configuration is based on this [starter repo](https://github.com/Misterio77/nix-starter-configs).

To start, install `git` and `nix-flakes`

```bash
# Should be 2.4+
nix --version
export NIX_CONFIG="experimental-features = nix-command flakes"

# Use a shell with git
nix-shell -p git home-manager

# Update flakes
nix flake update ./nixos/
nix flake update ./home-manager/

# Update the hardware configuration
cp /etc/nixos/hardware-configuration.nix ./nixos/hardware-configuration.nix

# Apply system configurations for a default system
sudo nixos-rebuild switch --flake .#default

# Apply the home manager configurations system
home-manager switch -b backup --flake .#justin
```
