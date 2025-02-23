{
  pkgs,
  lib,
  ...
}:
{
  # Allow unfree packages like VSCode
  nixpkgs.config.allowUnfree = true;

  home.username = "justinhoang";
  home.homeDirectory = lib.mkDefault "/${
    if pkgs.stdenv.isDarwin then "Users" else "home"
  }/justinhoang";
  home.stateVersion = "24.11";
}
