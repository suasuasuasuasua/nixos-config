{
  pkgs,
  lib,
  username,
  ...
}:
{
  home = {
    inherit username;

    homeDirectory = lib.mkDefault "/${if pkgs.stdenv.isDarwin then "Users" else "home"}/${username}";
    # For macOS, $PATH must contain these.
    sessionPath = lib.mkIf pkgs.stdenv.isDarwin [
      "/etc/profiles/per-user/$USER/bin" # To access home-manager binaries
      "/nix/var/nix/profiles/system/sw/bin" # To access nix-darwin binaries
      "/usr/local/bin" # Some macOS GUI programs install here
    ];

    stateVersion = "24.11";
  };
}
