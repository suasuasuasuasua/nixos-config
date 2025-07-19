{ lib, ... }:
{
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "betterttv"
      "drawio"
      "obsidian"
      "spotify"
    ];

}
