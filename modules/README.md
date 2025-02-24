# Modules

The `modules` directory is organized in the following way.

```text
❯ tree modules/
modules/
├── flake-parts
│   ├── devshell.nix
│   ├── ...
│   └── toplevel.nix
├── home
│   ├── default.nix
│   └── ...
├── nixos
│   ├── default.nix
│   └── ...
└── README.md

```

- Inside of `flake-parts` are the setup files for the whole configuration
  - Generally don't mess with these files unless you know what you're doing!
- Inside of `home` are the user specific programs and configurations.
- Inside of `nixos` are the system wide programs and configurations.
