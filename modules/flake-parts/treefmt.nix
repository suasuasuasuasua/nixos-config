{ inputs, ... }:
{
  imports = [
    inputs.treefmt-nix.flakeModule
  ];
  perSystem =
    { pkgs, ... }:
    {
      treefmt = {
        # run the following programs on `nix fmt`
        programs = {
          nixfmt = {
            # format the nix files
            enable = pkgs.lib.meta.availableOn pkgs.stdenv.buildPlatform pkgs.nixfmt-rfc-style.compiler;
            package = pkgs.nixfmt-rfc-style;
          };

          # json
          jsonfmt.enable = true; # format json

          # yaml
          yamlfmt.enable = true; # format yaml

          # markdown
          mdformat.enable = true; # format markdown

          # just
          just.enable = true; # format just files

        };
        # ignore certain files
        settings.global.excludes = [
          "*.png"
          ".envrc"
        ];
      };
    };
}
