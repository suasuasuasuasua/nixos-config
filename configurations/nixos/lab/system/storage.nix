{
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
