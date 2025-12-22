{
  pkgs,
  userConfigs,
  ...
}:
{
  # Create /etc/zshrc that loads the nix-darwin environment.
  # this is required if you want to use darwin's default shell - zsh
  programs.zsh.enable = true;
  environment.shells = with pkgs; [ zsh ];

  # For home-manager to work.
  users.users =
    let
      helper =
        acc:
        { username, ... }:
        {
          ${username} = {
            home = "/Users/${username}";
          };
        }
        // acc;
    in
    builtins.foldl' helper { } userConfigs;
}
