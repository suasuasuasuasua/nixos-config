{
  config,
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.self.homeManagerModules.base
    inputs.self.homeManagerModules.cli
    inputs.self.homeManagerModules.gui

    ./nix.nix
    ./nixpkgs.nix
    # ./nixvim.nix
    ./stylix.nix
  ];

  custom.home = {
    cli = {
      bat.enable = true; # better cat
      btop.enable = true; # system monitor
      comma.enable = true; # try out programs with `,`
      direnv.enable = true; # switch dev environments with .envrc files
      fzf.enable = true; # fuzzy finder
      # git.enable = true; # source control
      # github.enable = true; # github cli integration
      # gnupg.enable = true; # gpg key signing
      starship.enable = true;
      # tmux.enable = true; # terminal multiplexer
      # zsh.enable = true;
    };
    gui.firefox = {
      enable = true;
      # NOTE: use firefox ESR for stability
      package = config.lib.nixGL.wrap pkgs.firefox-esr;
    };
  };

  home = {
    packages = [
      pkgs.lazygit
      pkgs.devenv
    ];

    sessionVariables.EDITOR = "vim";
  };

  stylix.targets = {
    qt.enable = false;
    firefox = {
      enable = true;
      colorTheme.enable = true;
      profileNames = [
        "personal"
        "productivity"
      ];
    };
  };
}
