{ flake, ... }:
let
  inherit (flake) inputs;
  inherit (inputs) self;
in
{
  imports = [
    (self + /modules/nixos/shared)

    # config
    ./config.nix
    ./home.nix
  ];

  # For home-manager to work.
  users.users.justinhoang = {
    home = "/Users/justinhoang";
  };

  nixpkgs.hostPlatform = "aarch64-darwin";

  system = {
    configurationRevision = self.rev or self.dirtyRev or null;
    stateVersion = 5;
  };
}
