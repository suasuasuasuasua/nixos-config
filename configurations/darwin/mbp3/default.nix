{
  self,
  inputs,
  pkgs,
  userConfigs,
  ...
}:
{
  # A module that automatically imports everything else in the parent folder.
  imports = [
    # nix setup
    inputs.lix-module.nixosModules.default

    ./brew.nix
    ./config.nix
    ./home.nix
    ./nixpkgs.nix
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

  nix = {
    optimise = {
      automatic = true;
      interval = [
        # at midnight everyday
        {
          Hour = 0;
          Minute = 0;
        }
      ];
    };

    # Automatic garbage collection
    gc = {
      automatic = true;
      interval = [
        # at midnight every week start
        {
          Hour = 0;
          Minute = 0;
          Weekday = 7;
        }
      ];
      options = "--delete-older-than 30d";
    };

    # enable cross platform builds
    # https://nixcademy.com/posts/macos-linux-builder/
    linux-builder = {
      enable = true;

      # https://github.com/nix-darwin/nix-darwin/issues/1192
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      ephemeral = true;
      maxJobs = 4;
      config = {
        virtualisation = {
          darwin-builder = {
            diskSize = 40 * 1024;
            memorySize = 8 * 1024;
          };
          cores = 8;
        };
        boot.binfmt.emulatedSystems = [ "x86_64-linux" ];
      };
    };
  };

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
