# NixOS Configuration

My current configuration is based on this [starter repo](https://github.com/Misterio77/nix-starter-configs).

To start, install `git` and `nix-flakes`

```bash
# Use a shell with git
nix-shell -p git home-manager

# Should be 2.4+ for these features
nix --version
export NIX_CONFIG="experimental-features = nix-command flakes"

# Update flakes
nix flake update

# Update the hardware configuration
cp /etc/nixos/hardware-configuration.nix ./hosts/.../hardware-configuration.nix

# Apply system configurations for a default system
sudo nixos-rebuild switch --flake .

# Apply the home manager configurations system
home-manager switch -b backup --flake .
```

## Nix Darwin Extension

Use the nix installer from Determinate Systems. It provides nice features like
a transparent installation, sets up the volume for the nix, has an easy
uninstall script, etc.

```bash
curl --proto '=https' --tlsv1.2 -sSf -L \
     https://install.determinate.systems/nix | sh -s -- install
```
