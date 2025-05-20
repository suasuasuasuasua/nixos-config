# NixOS Config

| [![.github/workflows/flake-checker.yml](https://github.com/suasuasuasuasua/nixos-config/actions/workflows/flake-checker.yml/badge.svg)](https://github.com/suasuasuasuasua/nixos-config/actions/workflows/flake-checker.yml) | [![built with nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org) |
|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------|

## Hosts

### [`lab`](./configurations/nixos/lab/README.md) (custom build)

- Main server for services like `mealie`, `actual`, `jellyfin`, and more!
- NAS with ZFS pooled hdds and shared via `smb`

### [`legion`](./configurations/nixos/legion/README.md) (pre-built)

- Main drivers Windows 11 but experimenting with NixOS
- Gaming is the main factor stopping me from running full NixOS

### [`mbp3`](./configurations/darwin/mbp3/README.md) (MacBook Pro M3 Max)

- Main daily driver (yes I'm an apple fanboy secretly)
- Love that `nix-darwin` allows you to use the same configuration

### [`penguin`](./configurations/nixos/penguin/README.md) (Acer 713-3W Chromebook NixOS)

- Thin client notebook
- Mainly for web browsing, tinkering, note-taking, and light coding

### [`pi`](./configurations/nixos/pi/README.md) (Raspberry Pi Model 4B *(2GB RAM)*)

- *For fun* single board computer (acquired in college class)
- Runs simple services like `adguardhome`

## Setup

### NixOS

The initial setup is pretty simple now thanks to `disko`.

1. Boot the [minimal disk ISO](https://nixos.org/download/) onto a computer

1. Connect to the Internet

   ```bash
   # Enter sudo mode
   sudo -i

   # Start the service
   systemctl start wpa_supplicant.service

   # Use the CLI to connect
   wpa_cli

   > add_network 0
   > set_network 0 ssid "<network name>"
   > set_network 0 psk "<password>"
   > enable_network 0

   nix-shell -p disko
   ```

1. Run the `disko` utility

   ```bash
   # Add the program to the path
   nix-shell -p disko

   CONFIG_PATH="github:suasuasuasuasua/nixos-config" # or you could clone locally first
   NAME="penguin" # for example
   disko --mode disko --flake "${CONFIG_PATH}"#"${NAME}"
   nixos-install --no-channel-copy --no-root-password --flake "${CONFIG_PATH}"#"${NAME}"
   ```

1. Prepare the passwords and ZFS pools

   ```bash
   # Set your password
   nixos-enter --root /mnt -c "passwd ${USERNAME}"

   # Export the zpools so that they can be used by the actual computer (not the
   # installer!)
   zpool export -a

   # Reboot to your new system!
   reboot
   ```

1. Initialize Samba (`smb`) (as root)

   ```bash
   # Add a user and a password
   smbpasswd -a ${USERNAME}
   smbpasswd -e ${USERNAME}

   # Make the samba group
   groupadd samba

   # Add the user to the samba group
   usermod -a -G justinhoang samba

   # Make the zshare owned by samba and writable
   chgrp -R samba /zshare
   chmod -R 775 /zshare
   ```

1. Make changes and rebuild the system

   ```bash
   # Rebuild the system after any changes!
   just switch
   ```

### Darwin

The setup for `darwin` machines is much simpler. Make sure to connect to the
internet before beginning.

1. Install `nix` on the machine. You may be prompted to install developer tools
   (like `git`, `xcode`, etc.), so make sure to accept and be patient.

   ```bash
   curl -fsSL https://install.determinate.systems/nix | sh -s -- install
   ```

1. Install `nix-darwin`

   ```bash
   # To use Nixpkgs 25.05:
   sudo nix run nix-darwin/nix-darwin-25.05#darwin-rebuild -- switch
   ```

1. Install the configuration from GitHub

   ```bash
   # switch to the mbp3 device for example
   darwin-rebuild switch --flake github:suasuasuasuasua/nixos-config#mbp3
   ```
