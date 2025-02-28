{ flake, ... }:
let
  inherit (flake) inputs;
  inherit (inputs) self;
in
{
  imports = [
    (self + "/modules/shared")

    # config
    ./config.nix
    ./home.nix
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";

  system = {
    configurationRevision = self.rev or self.diretyRev or null;
    stateVersion = 6;
  };
}
