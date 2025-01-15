# Configurations

The `configurations` directory is organized in the following way.

```
❯ tree configurations/
configurations/
├── home
│   ├── <user1.nix>
│   ├── <...>
│   └── <userN.nix>
├── nixos
│   ├── penguin
│   │   ├── configuration.nix
│   │   ├── default.nix
│   │   └── hardware-configuration.nix
│   ├── <host2.nix>
│   ├── <...>
│   └── <hostN.nix>
└── README.md
```

- Inside of `home` are the user profiles and user-specific configurations.
- Inside of `nixos` are the hosts and host-specific configurations.
  - Think hardware configurations and other quirks.
