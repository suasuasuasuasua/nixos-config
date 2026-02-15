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
    overlays = builtins.attrValues outputs.overlays ++ [
      (_: super: {
        inetutils = super.inetutils.overrideAttrs (attrs: rec {
          version = "2.6";
          src = super.fetchurl {
            url = "mirror://gnu/${attrs.pname}/${attrs.pname}-${version}.tar.xz";
            hash = "sha256-aL7b/q9z99hr4qfZm8+9QJPYKfUncIk5Ga4XTAsjV8o=";
          };
        });
      })
    ];
  };

  nix.enable = false;
}
