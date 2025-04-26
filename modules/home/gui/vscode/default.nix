{
  lib,
  options,
  config,
  pkgs,
  ...
}:
let
  cfg = config.home.gui.vscode;
in
{
  options.home.gui.vscode = {
    enable = lib.mkEnableOption "Enable Visual Studio Code";

    package = lib.mkOption {
      # NOTE: fhs version exists
      # workaround in macOS if app does not automatically run
      # 1. settings>privacy&security>security
      # 2. click allow app
      type =
        with lib.types;
        with pkgs;
        enum [
          vscode
          # vscode-fhs
          vscodium
          vscodium-fhs
        ];
      default = pkgs.vscodium;
    };

    extensions = import ./extensions.nix {
      inherit lib pkgs;
    };
    keybindings = import ./keybindings.nix {
      inherit lib pkgs;
    };
    userSettings = import ./userSettings.nix {
      inherit lib pkgs;
    };
  };

  config = lib.mkIf cfg.enable {
    home.sessionVariables = lib.mkIf pkgs.stdenv.isLinux {
      NIXOS_OZONE_WL = "1";
    };

    programs.vscode = with lib; {
      inherit (cfg) package;

      enable = true;
      enableExtensionUpdateCheck = false;
      enableUpdateCheck = false;
      mutableExtensionsDir = false;

      extensions =
        options.home.gui.vscode.extensions.default
        ++ lists.flatten (optional (cfg.extensions != [ ]) cfg.extensions);
      keybindings =
        options.home.gui.vscode.keybindings.default
        ++ lists.flatten (optional (cfg.keybindings != [ ]) cfg.keybindings);
      userSettings =
        options.home.gui.vscode.userSettings.default
        // optionalAttrs (cfg.userSettings != { }) cfg.userSettings;

      # TODO: profiles available in 25.05 unstable...
    };
  };
}
