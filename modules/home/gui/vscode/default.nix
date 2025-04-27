{
  lib,
  options,
  config,
  pkgs,
  ...
}:
let
  cfg = config.home.gui.vscode;
  opts = options.home.gui.vscode;

  extensions =
    with lib;
    # add base extensions
    opts.extensions.default
    # add any additional extensions
    ++ optionals (cfg.extensions != [ ]) cfg.extensions
    # add any language specific extensions
    ++ builtins.foldl' (
      acc: name:
      optionals cfg.languages.${name}.enable (
        opts.languages.${name}.extensions.default
        # also add any additional language specific extensions
        ++ (optionals (opts.languages.${name}.extensions != [ ]) cfg.languages.${name}.extensions)
      )
      ++ acc
    ) [ ] (lib.attrNames cfg.languages);
  keybindings =
    with lib;
    # add base keybindings
    opts.keybindings.default
    # add any additional keybindings
    ++ optionals (cfg.keybindings != [ ]) cfg.keybindings
    # add any language specific keybindings
    ++ builtins.foldl' (
      acc: name:
      optionals cfg.languages.${name}.enable (
        opts.languages.${name}.keybindings.default
        # also add any additional language specific keybindings
        ++ (optionals (opts.languages.${name}.keybindings != [ ]) cfg.languages.${name}.keybindings)
      )
      ++ acc
    ) [ ] (lib.attrNames cfg.languages);
  userSettings =
    with lib;
    # add base userSettings
    opts.userSettings.default
    # add any additional userSettings
    // optionalAttrs (cfg.userSettings != { }) cfg.userSettings
    # add any language specific userSettings
    // builtins.foldl' (
      acc: name:
      optionalAttrs cfg.languages.${name}.enable (
        opts.languages.${name}.userSettings.default
        # also add any additional language specific userSettings
        // (optionalAttrs (opts.languages.${name}.userSettings != { }) cfg.languages.${name}.userSettings)
      )
      // acc
    ) { } (lib.attrNames cfg.languages);
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

    extensions = import ./extensions.nix { inherit lib pkgs; };
    languages = import ./language-specific.nix { inherit lib pkgs; };
    keybindings = import ./keybindings.nix { inherit lib pkgs; };
    userSettings = import ./userSettings.nix { inherit lib pkgs; };
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
