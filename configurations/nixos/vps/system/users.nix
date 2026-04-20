{
  users.users.admin = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA12qTb88TMH/x1T2xST2kEviP+RGGQkv+EJFWPboxuv justinhoang@iphone15"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBBse2Ikd1n7K9MnQiXmC4kNdNOasAVBbgH01pozcsbm justinhoang@Justins-MacBook-Pro.local"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP5vx5WQe2m2fXDFhjnNeYYrY6OIR0y5X0nfdAAlchcl justinhoang@lab"
    ];
  };

  # Allow passwordless sudo for wheel group
  security.sudo.wheelNeedsPassword = false;
}
