{ pkgs, userConfigs, ... }:
{
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
              "wheel"
            ];
            shell = pkgs.zsh;
          };
        }
        // acc;
    in
    builtins.foldl' helper { } userConfigs;

  # Need to enable zsh before we can actually use it. Home manager configs it,
  # but cannot set the login shell because that's root level operation
  programs.zsh.enable = true;

}
