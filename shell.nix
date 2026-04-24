{ self, pkgs, ... }:
let
  inherit (pkgs.stdenv.hostPlatform) system;
in
pkgs.mkShellNoCC {
  # enable the shell hooks
  inherit (self.checks.${system}.git-hooks-check) shellHook;

  # define the programs available when running `nix develop`
  # add the packages from the git-hooks list too
  buildInputs = self.checks.${system}.git-hooks-check.enabledPackages;
  packages = with pkgs; [
    bat
    btop
    caligula
    commitizen
    fastfetch
    git
    home-manager
    just
    markdownlint-cli
    marksman
    nh
    nil
    nix-output-monitor
    nixd
    nixfmt
    nvd
    opentofu
    sops
    tokei
    vim-startuptime
  ];
}
