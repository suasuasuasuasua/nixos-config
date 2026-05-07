{ config, pkgs, ... }:
{
  environment.etc."current-system-packages".text =
    let
      inherit (builtins)
        lessThan
        map
        sort
        concatStringsSep
        filter
        isAttrs
        hasAttr
        ;
      inherit (pkgs.lib.lists) unique;

      validPackages = filter (p: isAttrs p && hasAttr "name" p) config.environment.systemPackages;
      packages = map (p: "${p.name}") validPackages;
      sortedUnique = sort lessThan (unique packages);
    in
    concatStringsSep "\n" sortedUnique;
}
