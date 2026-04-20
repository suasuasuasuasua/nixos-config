# VPS Disk configuration
# Adjust this based on your VPS provider's disk setup
# This is a basic example for a simple /dev/sda partition
{
  disko.devices = {
    disk.sda = {
      type = "disk";
      device = "/dev/sda";
      content = {
        type = "table";
        format = "msdos";
        partitions = [
          {
            name = "boot";
            type = "83";
            size = "1M";
            flags = [ "grub" ];
          }
          {
            name = "root";
            type = "83";
            size = "100%";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
            };
          }
        ];
      };
    };
  };
}
