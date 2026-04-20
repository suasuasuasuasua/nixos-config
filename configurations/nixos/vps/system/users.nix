{
  users.users.justinhoang = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  # Allow passwordless sudo for wheel group
  security.sudo.wheelNeedsPassword = false;
}
