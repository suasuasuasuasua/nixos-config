{ inputs, ... }:
{
  imports = [
    inputs.devenv.flakeModule
    inputs.treefmt-nix.flakeModule
  ];
  perSystem =
    { pkgs, ... }:
    {
      devenv.shells.default = {
        devenv.root =
          let
            devenvRootFileContent = builtins.readFile inputs.devenv-root.outPath;
          in
          pkgs.lib.mkIf (devenvRootFileContent != "") devenvRootFileContent;

        name = "nixos-config";

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
          nixfmt-rfc-style.enable = true;
          # deadnix.enable = true; # kind of annoying in practice
          flake-checker.enable = true;
          statix.enable = true;

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
