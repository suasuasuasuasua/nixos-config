{ inputs, ... }:
{
  imports = [
    inputs.treefmt-nix.flakeModule
  ];
  perSystem =
    { pkgs, ... }:
    {
      treefmt = {
        # nix
        programs = {
          nixfmt = {
            enable = pkgs.lib.meta.availableOn pkgs.stdenv.buildPlatform pkgs.nixfmt-rfc-style.compiler;
            package = pkgs.nixfmt-rfc-style;
          };

          # json
          jsonfmt.enable = true;

          # yaml
          yamlfmt.enable = true;

          # markdown
          mdformat.enable = true;

          # just
          just.enable = true;

        };
        # ignore certain files
        settings.global.excludes = [
          "*.png"
          ".envrc"
        ];
      };
    };
}
