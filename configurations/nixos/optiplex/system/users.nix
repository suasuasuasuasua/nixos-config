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
            extraGroups = [ "wheel" ];
            shell = pkgs.zsh;

            openssh.authorizedKeys.keys = [
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBBse2Ikd1n7K9MnQiXmC4kNdNOasAVBbgH01pozcsbm justinhoang@Justins-MacBook-Pro.local"
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP5vx5WQe2m2fXDFhjnNeYYrY6OIR0y5X0nfdAAlchcl justinhoang@lab"
            ];
          };
        }
        // acc;
    in
    builtins.foldl' helper { } userConfigs;

}
