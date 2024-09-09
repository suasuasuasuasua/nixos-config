{
  inputs,
  pkgs,
  ...
}: {
  # Need to enable zsh before we can actually use it. Home manager configs it,
  # but cannot set the login shell because that's root level operation
  programs.zsh.enable = true;

  users.users = {
    justin = {
      # If you do, you can skip setting a root password by passing '--no-root-passwd' to nixos-install.
      # Be sure to change it (using passwd) after rebooting!
      initialPassword = "password";
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "docker"
        "libvirtd"
      ];
      shell = pkgs.zsh;
    };
  };
}
