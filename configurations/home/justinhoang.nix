{
  pkgs,
  lib,
  ...
}:
{
  # Allow unfree packages like VSCode
  nixpkgs.config.allowUnfree = true;

  home = {
    username = "justinhoang";
    homeDirectory = lib.mkDefault "/${if pkgs.stdenv.isDarwin then "Users" else "home"}/justinhoang";
    stateVersion = "24.11";
  };
}
