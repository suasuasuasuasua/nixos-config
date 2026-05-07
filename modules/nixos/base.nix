{ inputs, userConfigs, ... }:
{
  imports = [
    inputs.self.sharedModules.overlays
    inputs.self.sharedModules.system-packages
    inputs.self.sharedModules.nix
  ];

  nix = {
    settings.trusted-users = [
      "root"
    ]
    ++ map ({ username, ... }: username) userConfigs;

    channel.enable = false;
  };
}
