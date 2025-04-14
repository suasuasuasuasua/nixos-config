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
  inherit (self.checks.${system}.git-hooks-check) shellHook;

  # define the programs available when running `nix develop`
  # add the packages from the git-hooks list too
  buildInputs = self.checks.${system}.git-hooks-check.enabledPackages;
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
    nh # nix helper
    nix-output-monitor # nix output monitor
    nvd # nix/nixos package version diff tool

    # source control
    commitizen # templated commits and bumping
    git # source control program
  ];
}
