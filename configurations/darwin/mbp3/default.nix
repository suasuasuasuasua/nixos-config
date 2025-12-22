{ self, ... }:
{
  imports = [
    ./home
    ./services
    ./system

    ./brew.nix
    ./config.nix
    ./stylix.nix
  ];

  system = {
    configurationRevision = self.rev or self.dirtyRev or null;
    stateVersion = 5;
  };
}
