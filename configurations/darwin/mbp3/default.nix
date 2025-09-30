{
  self,
  pkgs,
  userConfigs,
  ...
}:
{
  imports = [
    ./home
    ./services

    ./brew.nix
    ./config.nix
    ./nixpkgs.nix
    ./stylix.nix
    ./system.nix
  ];

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

  # Create /etc/zshrc that loads the nix-darwin environment.
  # this is required if you want to use darwin's default shell - zsh
  programs.zsh.enable = true;
  environment.shells = with pkgs; [
    zsh
  ];

  # Fonts
  fonts = {
    packages =
      with pkgs;
      [
        # icon fonts
        material-design-icons
        font-awesome
      ]
      ++ (with pkgs.nerd-fonts; [
        # nerdfonts
        # https://github.com/NixOS/nixpkgs/blob/nixos-24.05/pkgs/data/fonts/nerdfonts/shas.nix
        # symbols icon only
        symbols-only
        # characters
        fira-code
        jetbrains-mono
        iosevka
      ]);
  };

  # Set your time zone.
  time.timeZone = "America/Denver";

  nixpkgs.hostPlatform = "aarch64-darwin";
  system = {
    configurationRevision = self.rev or self.dirtyRev or null;
    stateVersion = 5;
  };
}
