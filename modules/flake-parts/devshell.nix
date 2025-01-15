{ inputs, ... }:
{
  imports = [
    (inputs.git-hooks + /flake-module.nix)
  ];
  perSystem = { pkgs, ... }: {
    devShells.default = pkgs.mkShell {
      name = "nixos-unified-template-shell";
      meta.description = "Shell environment for modifying this Nix configuration";
      packages = with pkgs; [
        git
        pre-commit
        commitizen

        just
        nixd

        markdownlint-cli
        nixfmt-rfc-style
      ];
    };

    pre-commit.settings = {
      hooks = {
        # Nix
        nixpkgs-fmt.enable = true;
        deadnix.enable = true;
        flake-checker.enable = true;

        # Git
        commitizen.enable = true;
        ripsecrets.enable = true;

        # Docs
        typos.enable = true;
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
