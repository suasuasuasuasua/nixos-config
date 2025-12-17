{
  # https://nixos.wiki/wiki/Storage_optimization

  # Optimize the storage once in a while
  nix = {
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

  # https://wiki.nixos.org/wiki/USB_storage_devices
  #
  # - udiskctl status
  #   - find all available disks
  # - udiskctl mount -b path/to/the/drive
  #   - mount the drive
  #   - remember to mount the partition, not the whole thing
  #   - the location is under /run/media/$USER
  # - udiskctl unmount -b path/to/the/drive
  #   - unmount the drive
  services.udisks2.enable = true;
}
