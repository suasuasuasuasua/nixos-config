{ flake, pkgs, ... }:
let
  inherit (flake) inputs;
  inherit (inputs) self;
in
{
  imports = [
    (self + /modules/nixos/shared)

    # config
    ./config.nix
    ./home.nix
    ./brew.nix
    ./system.nix
  ];

  # For home-manager to work.
  users.users.justinhoang = {
    home = "/Users/justinhoang";
  };

  nix = {
    # enable cross platform builds
    linux-builder = {
      enable = true;
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      config = {
        # multi-core builds
        virtualisation.cores = 8;
      };
    };
  };

  # Create /etc/zshrc that loads the nix-darwin environment.
  # this is required if you want to use darwin's default shell - zsh
  programs.zsh.enable = true;
  environment.shells = [
    pkgs.zsh
  ];

  # Fonts
  fonts = {
    packages = with pkgs; [
      # icon fonts
      material-design-icons
      font-awesome
      # nerdfonts
      # https://github.com/NixOS/nixpkgs/blob/nixos-24.05/pkgs/data/fonts/nerdfonts/shas.nix
      (nerdfonts.override {
        fonts = [
          # symbols icon only
          "NerdFontsSymbolsOnly"
          # Characters
          "FiraCode"
          "JetBrainsMono"
          "Iosevka"
        ];
      })
    ];
  };

  # Set your time zone.
  time.timeZone = "America/Denver";

  nixpkgs.hostPlatform = "aarch64-darwin";
  system = {
    configurationRevision = self.rev or self.dirtyRev or null;
    stateVersion = 5;
  };
}
