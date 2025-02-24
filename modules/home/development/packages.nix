# Packages related to development
{
  flake,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (flake) inputs;

  cfg = config.home.development.packages;
in
{
  imports = [
    inputs.nix-index-database.hmModules.nix-index
  ];

  options.home.development.packages = {
    enable = lib.mkEnableOption "Enable general CLI tools";
    # TODO: add default set of packages or custom config
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # General
      tree

      # Command runner
      just

      # Test packages
      nvd

      # Neovim dependencies
      tree-sitter
      ripgrep
      fd
      # Optional lsp for md
      markdownlint-cli

      # System monitoring
      fastfetch
      onefetch
      btop
    ];

    programs.nix-index-database = {
      comma.enable = true;
    };
  };
}
