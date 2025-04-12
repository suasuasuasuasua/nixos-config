# NixOS Config

## Hosts

### [`mbp3`](./configurations/darwin/mbp3/README.md) (MacBook Pro M3 Max)

- Main daily driver (yes I'm an apple fanboy secretly)
- Love that `nix-darwin` allows you to use the same configuration

### [`lab`](./configurations/nixos/lab/README.md) (custom build)

- main server for services like `mealie`, `actual`, `jellyfin`, and more!
- nas with zfs pooled hdds and shared via `smb`

### [`Legion`](./configurations/nixos/legion/README.md) (custom build)

- For-fun NixOS on the Windows gaming computer. When I upgrade computers, I may
  run NixOS main driver, with Windows as the backup

### [`penguin`](./configurations/nixos/penguin/README.md) (Acer 713-3W Chromebook NixOS)

- Thin client notebook
- Mainly for web browsing, tinkering, note-taking, and light coding

### [`pi`](./configurations/nixos/pi/README.md) (Raspberry Pi Model 4B *(2GB RAM)*)

- *For fun* single board computer (acquired in college class)
- Runs simple services like `adguardhome`

## Development

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
   nix run .#activate
   ```

> Inspired by [this unified
> template](https://github.com/juspay/nixos-unified-template) and [this
> config](https://github.com/srid/nixos-config). See the template for more
> details on how to set it up!
