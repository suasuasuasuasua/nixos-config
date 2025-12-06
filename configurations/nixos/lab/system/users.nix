{ pkgs, userConfigs, ... }:
{
  # Need to enable zsh before we can actually use it. Home manager configs it,
  # but cannot set the login shell because that's root level operation
  programs.zsh.enable = true;

  users.users =
    let
      helper =
        acc:
        { username, initialHashedPassword, ... }:
        {
          ${username} = {
            # If you do, you can skip setting a root password by passing
            # '--no-root-passwd' to nixos-install. Be sure to change it (using
            # passwd) after rebooting!
            inherit initialHashedPassword;

            isNormalUser = true;
            extraGroups = [
              "libvirtd"
              "podman"
              "samba"
              "syncthing"
              "wheel"
            ];
            shell = pkgs.zsh;

            openssh.authorizedKeys.keys = [
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBBse2Ikd1n7K9MnQiXmC4kNdNOasAVBbgH01pozcsbm justinhoang@Justins-MacBook-Pro.local"
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAtIwDjNB5ZxSK41V5Vm4wziJrjRl8VkzKmhnqR52vrU justinhoang@legion"
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIDrPJPSb9jrZf8KQD0zpieDZMCz/u4c7lU9zpJ6u9cZ justinhoang@penguin"
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA12qTb88TMH/x1T2xST2kEviP+RGGQkv+EJFWPboxuv justinhoang@iphone15"
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILSeaDq9Cb9lhnEPP6SHAJ8pJ2TPiF/y8hXpJtvsSCMk justinhoang@ipadProM2"
            ];
          };
        }
        // acc;
    in
    builtins.foldl' helper { } userConfigs;

}
