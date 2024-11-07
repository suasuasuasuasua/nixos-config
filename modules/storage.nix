{
  # https://nixos.wiki/wiki/Storage_optimization

  # Optimize the storage once in a while
  nix.optimise.automatic = true;
  nix.optimise.dates = [
    # Optional; allows customizing optimisation schedule
    "00:00"
    "12:00"
  ];

  # Optimise on each build -- results in slower build :)
  nix.settings.auto-optimise-store = true;

  # Automatic garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
}
