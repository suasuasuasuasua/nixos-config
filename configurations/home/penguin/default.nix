{
  config,
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    "${inputs.self}/modules/home"
    "${inputs.self}/modules/home/cli"
    "${inputs.self}/modules/home/gui"

    ./nix.nix
    ./nixpkgs.nix
    # ./nixvim.nix
    ./stylix.nix
  ];

  # running debian 13!
  targets.genericLinux = {
    enable = true;
    # nixgl for GPU applications
    nixGL = {
      inherit (inputs.nixgl) packages;
      # no need for the offloading because this laptop doesn't have a discrete GPU
      defaultWrapper = "mesa";
      installScripts = [ "mesa" ];
    };
  };
  # patch for kde and qt (https://github.com/nix-community/stylix/issues/412)
  xdg.systemDirs.config = [ "/etc/xdg" ];

  custom.home = {
    cli = {
      bat.enable = true; # better cat
      btop.enable = true; # system monitor
      comma.enable = true; # try out programs with `,`
      devenv.enable = true; # easy dev environemnts
      direnv.enable = true; # switch dev environments with .envrc files
      fzf.enable = true; # fuzzy finder
      git.enable = true; # source control
      github.enable = true; # github cli integration
      gnupg.enable = true; # gpg key signing
      starship.enable = true;
      tmux.enable = true; # terminal multiplexer
      zsh.enable = true;
    };
    gui = {
      firefox = {
        enable = true;
        # NOTE: use firefox ESR for stability
        package = config.lib.nixGL.wrap pkgs.firefox-esr;
      };
      obs = {
        enable = true;
        package = config.lib.nixGL.wrap pkgs.obs-studio;
      };
      spotify.enable = true;
    };
  };

  home = {
    packages = with pkgs; [
      (config.lib.nixGL.wrap localsend)
    ];

    sessionVariables = {
      "EDITOR" = "vim";
    };
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
