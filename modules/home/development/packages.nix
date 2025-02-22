# Packages related to development
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.home.development.packages;
in
{
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
      comma
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
  };
}
