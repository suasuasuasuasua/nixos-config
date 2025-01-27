{ inputs, ... }:
{
  imports = [
    inputs.devenv.flakeModule
  ];
  perSystem =
    { pkgs, ... }:
    {
      devenv.shells.default = {
        packages = with pkgs; [
          git
          pre-commit
          commitizen

          just

          markdownlint-cli
        ];

        # Programming languages
        languages.nix.enable = true;

        # Devcontainer
        devcontainer = {
          enable = true;
          settings = {
            image = "ghcr.io/cachix/devenv:latest";
            customization.vscode.extensions = [
              "vscodevim.vim"
              "mkhl.direnv"
              "jnoortheen.nix-ide"
            ];
          };
        };

        # Enable pre-commit hooks
        git-hooks.hooks = {
          # Nix
          nixpkgs-fmt.enable = true;
          deadnix.enable = true;
          flake-checker.enable = true;

          # Git
          commitizen.enable = true;
          ripsecrets.enable = true;

          # Docs
          markdownlint.enable = true;

          # General
          check-added-large-files.enable = true;
          check-merge-conflicts.enable = true;
          end-of-file-fixer.enable = true;
          trim-trailing-whitespace.enable = true;
        };
      };
    };
}
