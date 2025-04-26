{
  lib,
  options,
  config,
  pkgs,
  ...
}:
let
  cfg = config.home.gui.vscode;

  extensions =
    options.home.gui.vscode.extensions.default
    ++ lib.optionals (cfg.extensions != [ ]) cfg.extensions;
  keybindings =
    options.home.gui.vscode.keybindings.default
    ++ lib.optionals (cfg.keybindings != [ ]) cfg.keybindings;
  userSettings =
    options.home.gui.vscode.userSettings.default
    // lib.optionalAttrs (cfg.userSettings != { }) cfg.userSettings;
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
        enum (
          [
            vscode
            vscodium
          ]
          # Add the fhs versions for linux only
          ++ lib.optionals pkgs.stdenv.isLinux [
            vscode-fhs
            vscodium-fhs
          ]
        );
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

    programs.vscode = {
      inherit (cfg) package;
      inherit extensions keybindings userSettings;

      enable = true;
      enableExtensionUpdateCheck = false;
      enableUpdateCheck = false;
      mutableExtensionsDir = false;

      # TODO: profiles available in 25.05 unstable...
    };
  };
}
