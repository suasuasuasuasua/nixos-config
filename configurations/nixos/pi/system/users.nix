{
  users.users.justinhoang = {
    # If you do, you can skip setting a root password by passing
    # '--no-root-passwd' to nixos-install. Be sure to change it (using
    # passwd) after rebooting!
    initialHashedPassword = "$y$j9T$sXZCGwjtugZIt/C2nU8bk/$D36OrIe3eyGSM7rPysbQI1OyT56TdtJZtcvnOne2Ge0";
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };
}
