{
  users.users.admin = {
    # If you do, you can skip setting a root password by passing
    # '--no-root-passwd' to nixos-install. Be sure to change it (using
    # passwd) after rebooting!
    initialHashedPassword = "$y$j9T$sXZCGwjtugZIt/C2nU8bk/$D36OrIe3eyGSM7rPysbQI1OyT56TdtJZtcvnOne2Ge0";
    isNormalUser = true;
    extraGroups = [ "wheel" ];

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA12qTb88TMH/x1T2xST2kEviP+RGGQkv+EJFWPboxuv justinhoang@iphone15"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAtIwDjNB5ZxSK41V5Vm4wziJrjRl8VkzKmhnqR52vrU justinhoang@legion"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBBse2Ikd1n7K9MnQiXmC4kNdNOasAVBbgH01pozcsbm justinhoang@Justins-MacBook-Pro.local"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILBclQTbAA8JkwD5mV17zhuISaF5t6vliyOsEaRdMpsw justinhoang@fedora"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILSeaDq9Cb9lhnEPP6SHAJ8pJ2TPiF/y8hXpJtvsSCMk justinhoang@ipadProM2"
    ];
  };
}
