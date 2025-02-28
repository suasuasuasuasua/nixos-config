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
        packages = with pkgs; [
          # source control
          git
          pre-commit
          commitizen

          # commands
          just

          # lsp
          nixd
          markdownlint-cli

          # cli
          bunnyfetch
          fastfetch
          btop
          powertop
        ];
      };
    };
}
