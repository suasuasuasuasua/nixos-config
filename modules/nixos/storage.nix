{
  # Optimize the storage once in a while
  nix.optimise.automatic = true;
  nix.optimise.dates = [
    # Optional; allows customizing optimisation schedule
    "00:00"
    "12:00"
  ];
}
