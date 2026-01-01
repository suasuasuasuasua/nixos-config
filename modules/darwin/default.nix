{
  config,
  outputs,
  pkgs,
  ...
}:
{
  # write a list of system packages to /etc/current-system-packages
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

      # Filter packages to only include derivations with a name attribute
      # This handles cases where strings (like store paths) are in systemPackages
      validPackages = filter (p: isAttrs p && hasAttr "name" p) config.environment.systemPackages;
      packages = map (p: "${p.name}") validPackages;
      sortedUnique = sort lessThan (unique packages);
      formatted = concatStringsSep "\n" sortedUnique;
    in
    formatted;

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
  };

  nix.enable = false;
}
