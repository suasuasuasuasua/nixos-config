{ lib, ... }:
{
  boot.loader.grub = {
    enable = true;
    devices = lib.mkForce [ "/dev/sda" ];
  };
}
