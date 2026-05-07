{
  inputs,
  lib,
  pkgs,
  userConfig,
  ...
}:
{
  imports = [
    inputs.self.sharedModules.overlays
    inputs.self.sharedModules.nix
  ];

  nix = {
    # standalone home-manager manages its own nix package
    package = pkgs.nix;

    settings = {
      trusted-users = [
        "root"
        "${userConfig.username}"
      ];

      # darwin specific extra platform builders
      extra-platforms = lib.mkIf pkgs.stdenv.isDarwin "aarch64-darwin x86_64-darwin";
    };
  };
}
