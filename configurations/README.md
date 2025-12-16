# Configurations

The `configurations` directory is organized in the following way.

```text
❯ tree configurations/
configurations/
├── darwin
│   ├── <host1.nix>
│   ├── <...>
│   └── <hostN.nix>
├── home
│   ├── <user1.nix>
│   ├── <...>
│   └── <userN.nix>
├── nixos
│   ├── <host1.nix>
│   ├── <...>
│   └── <hostN.nix>
└── README.md
```

- Inside of `darwin` are the actual user configurations for `nix-darwin`
machines
- Inside of `home` are the actual user profiles and user-specific configurations
for home-manager only machines.
- Inside of `nixos` are the hosts and host-specific configurations for NixOS
machines.
