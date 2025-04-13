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
    extraSpecialArgs = {
      inherit inputs outputs;
    };

    users."justinhoang" = {
      home = {
        username = "justinhoang";

        homeDirectory = lib.mkDefault "/${if pkgs.stdenv.isDarwin then "Users" else "home"}/justinhoang";
        # For macOS, $PATH must contain these.
        sessionPath = lib.mkIf pkgs.stdenv.isDarwin [
          "/etc/profiles/per-user/$USER/bin" # To access home-manager binaries
          "/nix/var/nix/profiles/system/sw/bin" # To access nix-darwin binaries
          "/usr/local/bin" # Some macOS GUI programs install here
        ];

        stateVersion = "24.11";
      };
    };
  };
}
