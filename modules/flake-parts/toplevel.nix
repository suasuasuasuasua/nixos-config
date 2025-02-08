# Top-level flake glue to get our configuration working
{ inputs, ... }:

{
  imports = [
    inputs.nixos-unified.flakeModules.default
    inputs.nixos-unified.flakeModules.autoWire
  ];
  perSystem =
    {
      self',
      system,
      config,
      pkgs,
      ...
    }:
    {
      # Enables 'nix run' to activate.
      packages.default = self'.packages.activate;

      _module.args = {
        pkgsUnstable = import inputs.nixpkgs-unstable {
          inherit (pkgs.stdenv.hostPlatform) system;
          inherit (config.nixpkgs) config;
        };
      };
    };
}
