{
  # https://wiki.nixos.org/wiki/Storage_optimization
  nix = {
    optimise.automatic = true;
    optimise.dates = [
      "00:00"
      "12:00"
    ];

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };
}
