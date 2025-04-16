# https://nixos.wiki/wiki/Laptop
{
  # General power management
  powerManagement.enable = true;

  # Prevent overheating
  services.thermald.enable = true;
}
