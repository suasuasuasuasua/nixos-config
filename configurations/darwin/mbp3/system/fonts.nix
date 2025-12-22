{ pkgs, ... }:
{
  fonts.packages =
    with pkgs;
    [
      # icon fonts
      material-design-icons
      font-awesome
    ]
    ++ (with pkgs.nerd-fonts; [
      # nerdfonts
      # https://github.com/NixOS/nixpkgs/blob/nixos-24.05/pkgs/data/fonts/nerdfonts/shas.nix
      # symbols icon only
      symbols-only
      # characters
      fira-code
      jetbrains-mono
      iosevka
    ]);
}
