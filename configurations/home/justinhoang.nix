{
  inputs,
  outputs,
  pkgs,
  lib,
  ...
}:
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs outputs; };

    users."justinhoang" = {
      home = {
        username = "justinhoang";
        homeDirectory = lib.mkDefault "/${if pkgs.stdenv.isDarwin then "Users" else "home"}/justinhoang";
        stateVersion = "24.11";
      };
    };
  };
}
