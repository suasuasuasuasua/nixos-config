{ inputs, pkgs, ... }:
{
  home-manager.users.justinhoang = {
    imports = [
      inputs.self.homeManagerModules.cli
      inputs.self.homeManagerModules.gui

      ./nixvim.nix
    ];

    custom.home = {
      cli = {
        bat.enable = true;
        btop.enable = true;
        comma.enable = true;
        direnv.enable = true;
        fzf.enable = true;
        git.enable = true;
        github.enable = true;
        gnupg.enable = true;
        starship.enable = true;
        tmux.enable = true;
        zsh.enable = true;
      };
      gui = {
        alacritty.enable = true;
        firefox.enable = true;
      };
    };

    systemd.user.services.sway-headless = {
      Unit = {
        Description = "Sway Wayland compositor (headless)";
        After = [ "default.target" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.sway}/bin/sway";
        Environment = [
          "WLR_BACKENDS=headless"
          "WLR_RENDERER=pixman"
          "WAYLAND_DISPLAY=wayland-1"
          "XDG_SESSION_TYPE=wayland"
          "XDG_CURRENT_DESKTOP=sway"
        ];
        Restart = "on-failure";
      };
      Install.WantedBy = [ "default.target" ];
    };

    services.wayvnc = {
      enable = true;
      autoStart = true;
      systemdTarget = "sway-session.target";
      settings = {
        address = "0.0.0.0";
        port = 5900;
      };
    };

    home.stateVersion = "25.11";
    home.packages = [ pkgs.devenv ];

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
  };
}
