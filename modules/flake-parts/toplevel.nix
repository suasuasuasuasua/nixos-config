# Top-level flake glue to get our configuration working
{ inputs, ... }:

{
  imports = [
    inputs.nixos-unified.flakeModules.default
    inputs.nixos-unified.flakeModules.autoWire
    inputs.treefmt-nix.flakeModule
  ];
  perSystem =
    {
      self',
      pkgs,
      lib,
      ...
    }:
    # Eval the treefmt modules from ./treefmt.nix
    {
      treefmt = {
        # nix
        programs.nixfmt.enable = pkgs.lib.meta.availableOn pkgs.stdenv.buildPlatform pkgs.nixfmt-rfc-style.compiler;
        programs.nixfmt.package = pkgs.nixfmt-rfc-style;

        # json
        programs.jsonfmt.enable = true;

        # yaml
        programs.yamlfmt.enable = true;

        # markdown
        programs.mdformat.enable = true;

        # just
        programs.just.enable = true;

        # ignore certain files
        settings.global.excludes = [
          "*.png"
          ".envrc"
        ];
      };

      # Enables 'nix run' to activate.
      packages.default = self'.packages.activate;
    };
}
