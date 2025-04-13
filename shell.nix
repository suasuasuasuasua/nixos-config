{
  self,
  pkgs,
  ...
}:
let
  inherit (pkgs) system;
in
pkgs.mkShell {
  # enable the shell hooks
  inherit (self.checks.git-hooks-check.${system}) shellHook;

  # define the programs available when running `nix develop`
  # add the packages from the git-hooks list too
  buildInputs = self.checks.git-hooks-check.${system}.enabledPackages;
  packages = with pkgs; [
    # cli
    btop # system monitoring
    fastfetch # system information

    # commands
    just # command runner

    # lsp
    nil # lsp 1
    nixd # lsp 2
    nixfmt-rfc-style # nix formatter
    markdownlint-cli # markdown linter

    # nix support
    home-manager
    nix
    nix-output-monitor # nix output monitor
    nvd # nix/nixos package version diff tool

    # source control
    commitizen # templated commits and bumping
    git # source control program
  ];
}
