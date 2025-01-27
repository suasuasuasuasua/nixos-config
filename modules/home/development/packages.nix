# Packages related to development
{ pkgs, ... }:
{
  # TODO: not actually working on darwin
  home.packages = with pkgs; [
    # General
    tree

    # Command runner
    just

    # Test packages
    comma

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
}
