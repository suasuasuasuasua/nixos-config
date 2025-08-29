{
  # https://nixos.wiki/wiki/Storage_optimization

  nix = {
    # Optimize the storage once in a while
    optimise.automatic = true;
    optimise.dates = [
      # Optional; allows customizing optimisation schedule
      "00:00"
      "12:00"
    ];

    # Automatic garbage collection
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };
}
