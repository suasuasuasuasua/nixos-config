{
  users.users.admin = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  # Allow passwordless sudo for wheel group
  security.sudo.wheelNeedsPassword = false;
}
