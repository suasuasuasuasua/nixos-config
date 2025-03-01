# Define the developer shell called with `nix develop`
{
  perSystem =
    { config, pkgs, ... }:
    {
      devShells.default = pkgs.mkShell {
        name = "nixos-config-shell";
        meta.description = "Dev environment for nixos-config";

        inputsFrom = [ config.pre-commit.devShell ];
        # Make sure to install the pre-commit hooks!
        shellHook = # bash
          ''
            ${config.pre-commit.installationScript}
          '';

        # Define the packages needed to develop the developer shell
        packages = with pkgs; [
          # source control
          git # source control program
          commitizen # templated commits and bumping

          # commands
          just # command runner

          # lsp
          nil # lsp 1 (don't ask)
          nixd # lsp 2 (don't ask)
          nixfmt-rfc-style # nix formatter
          markdownlint-cli # markdown linter

          # cli
          fastfetch # system information
          btop # system monitoring
        ];
      };
    };
}
