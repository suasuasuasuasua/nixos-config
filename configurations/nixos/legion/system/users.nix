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
              "podman" # Added for rootless podman support
              "wheel"
            ];
            shell = pkgs.zsh;

            # Enable rootless podman by allocating subordinate UIDs/GIDs
            # See /docs/rootless-podman.md for detailed explanation
            subUidRanges = [
              {
                startUid = 100000;
                count = 65536;
              }
            ];
            subGidRanges = [
              {
                startGid = 100000;
                count = 65536;
              }
            ];
          };
        }
        // acc;
    in
    builtins.foldl' helper { } userConfigs;

  # Need to enable zsh before we can actually use it. Home manager configs it,
  # but cannot set the login shell because that's root level operation
  programs.zsh.enable = true;

}
