# NixOS Config

## Hosts

### `penguin` (Acer 713-3W Chromebook NixOS)

- Thin client notebook
- Mainly for web browsing, tinkering, note-taking, and light coding

## Development

The initial setup is pretty simple now thanks to `disko`.

1. Boot the [minimal disk ISO](https://nixos.org/download/) onto a computer
2. Clone the repository from GitHub

   ```bash
   # First get `git` since it isn't a default package
   nix-shell -p git

   # Clone the repo
   git clone https://github.com/suasuasuasuasua/nixos-config /tmp/nixos-config
   ```

3. Use `disko` to partition and format the drive

   ```bash
   sudo nix --experimental-features "nix-command flakes"    \
        run github:nix-community/disko/latest               \
        -- --mode destroy,format,mount                      \
        # replace the HOSTNAME with the name duh            \
        /tmp/nixos-config/configuration/nixos/${HOSTNAME}/disko.nix

   # Ensure that it worked
   mount | grep /mnt
   ```

4. Install the NixOS onto the system

   ```bash
   # Move the system config into the /mnt dir
   mv /tmp/nixos-config /mnt/etc/nixos

   # Navigate over to the /mnt directory
   cd /mnt

   # Install NixOS with some $HOSTNAME
   nixos-install --flake ./nixos-config#${HOSTNAME}
   ```

5. Make changes and rebuild the system

   ```bash
   # Rebuild the system after any changes!
   nix run
   ```

## Overview

Welcome to my NixOS config! This repo contains configuration files that defines
computers and profiles that I use. The configuration includes development tools,
general purpose applications (think web browsing, chat, video editing, etc.),
desktop environments, and more. Defining my systems in this way allows for
greater reproducibility, reliability, and elegance. Gone are the days of
forgetting obscure changes you made months ago because every configuration is
plainly expressed in `nix`.

What's nice about `nix` is sheer amount of [packages](https://search.nixos.org/)
available for use. For example, it's as simple as `nix-shell -p cowsay` to get
up and running with any program in my shell (even GUI ones though this is
sometimes unstable). I regularly search through `nixpkgs` to see new programs
that I'm learning about, and 99% of the time these programs are natively
supported; and if the package isn't there, you can make a packaging request or
do it yourself. What I probably like the best about NixOS is organizing the
modules into logical files; it scratches a part of my brain like no other distro
can do.

That isn't to say that `nix` and NixOS are the greatest things on the planet.
The learning curve is so steep that it probably requires you to have 3 Ph.D's,
but that's beside the point. I've stared at infinite recursions (thank you
functional programming), crazy error logs, and near non-existent documentation.
The module and flake system is super confusing too, and I've spent a long time
following import-traces; a lot of it still feels like wizardry. I've sunk (far
too) many hours to count at this point **organizing** the modules, researching
what options and pacakges are available, and learning best practices from other
users.

I have to admit though that it has been rewarding and definitely changed the way
that I look at computers and software engineering. As an aside, it's more than
just a NixOS configuration since *any* Linux distrubition may at least use the
`home-manager` setup, and MacOS can use `nix-darwin` and `home-manager`. NixOS
is just where I personally started somewhere in the Fall of 2024.

> Inspired by the [this unified
> template](https://github.com/juspay/nixos-unified-template) and [this
> config](https://github.com/srid/nixos-config). See the template for more details
> on how to set it up!
