{
  users.users = {
    justin = {
      # If you do, you can skip setting a root password by passing '--no-root-passwd' to nixos-install.
      # Be sure to change it (using passwd) after rebooting!
      initialPassword = "password";
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "docker"
      ];
      shell = pkgs.zsh;
    };
  };
}
