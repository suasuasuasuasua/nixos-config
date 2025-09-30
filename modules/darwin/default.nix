{
  outputs,
  config,
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
        ;
      inherit (pkgs.lib.lists) unique;

      packages = map (p: "${p.name}") config.environment.systemPackages;
      sortedUnique = sort lessThan (unique packages);
      formatted = concatStringsSep "\n" sortedUnique;
    in
    formatted;

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
  };

  nix.enable = false;
}
