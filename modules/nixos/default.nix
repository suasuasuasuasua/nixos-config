{ config, pkgs, ... }:
{
  imports =
    with builtins;
    map (fn: ./${fn}) (filter (fn: fn != "default.nix") (attrNames (readDir ./.)));

  # write a list of system packages to /etc/current-system-packages
  environment.etc."current-system-packages".text =
    let
      packages = builtins.map (p: "${p.name}") config.environment.systemPackages;
      sortedUnique = builtins.sort builtins.lessThan (pkgs.lib.lists.unique packages);
      formatted = builtins.concatStringsSep "\n" sortedUnique;
    in
    formatted;
}
