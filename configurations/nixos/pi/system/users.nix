{
  users.users.admin = {
    # If you do, you can skip setting a root password by passing
    # '--no-root-passwd' to nixos-install. Be sure to change it (using
    # passwd) after rebooting!
    initialHashedPassword = "$y$j9T$sXZCGwjtugZIt/C2nU8bk/$D36OrIe3eyGSM7rPysbQI1OyT56TdtJZtcvnOne2Ge0";
    isNormalUser = true;
    extraGroups = [ "wheel" ];

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBBse2Ikd1n7K9MnQiXmC4kNdNOasAVBbgH01pozcsbm justinhoang@Justins-MacBook-Pro.local"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP5vx5WQe2m2fXDFhjnNeYYrY6OIR0y5X0nfdAAlchcl justinhoang@lab"
    ];
  };
}
