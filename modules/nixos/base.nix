{ inputs, ... }:
{
  imports = [
    inputs.self.sharedModules.overlays
    inputs.self.sharedModules.system-packages
    inputs.self.sharedModules.nix
  ];

  nix = {
    settings.trusted-users = [
      "root"
      "@wheel"
    ];

    channel.enable = false;
  };
}
