{ pkgs, username, ... }:
{
  home.username = username;
  home.homeDirectory =
    let
      root = if pkgs.stdenv.isDarwin then "/Users" else "/home";
    in
    "${root}/${username}";
}
