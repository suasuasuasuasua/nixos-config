{ config, lib, ... }:
{
  environment.etc."current-system-packages".text =
    let
      validPackages = builtins.filter (
        p: builtins.isAttrs p && builtins.hasAttr "name" p
      ) config.environment.systemPackages;
      packages = map (p: p.name) validPackages;
    in
    builtins.concatStringsSep "\n" (lib.naturalSort (lib.unique packages));
}
