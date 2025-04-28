{
  inputs,
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
      optionals cfg.language-configurations.${name}.enable (
        opts.language-configurations.${name}.extensions.default
        # also add any additional language specific extensions
        ++ (optionals (
          cfg.language-configurations.${name}.extensions != [ ]
        ) cfg.language-configurations.${name}.extensions)
      )
      ++ acc
    ) [ ] (lib.attrNames cfg.language-configurations);
  keybindings =
    with lib;
    # add base keybindings
    opts.keybindings.default
    # add any additional keybindings
    ++ optionals (cfg.keybindings != [ ]) cfg.keybindings
    # add any language specific keybindings
    ++ builtins.foldl' (
      acc: name:
      optionals cfg.language-configurations.${name}.enable (
        opts.language-configurations.${name}.keybindings.default
        # also add any additional language specific keybindings
        ++ (optionals (
          cfg.language-configurations.${name}.keybindings != [ ]
        ) cfg.language-configurations.${name}.keybindings)
      )
      ++ acc
    ) [ ] (lib.attrNames cfg.language-configurations);
  userSettings =
    with lib;
    # add base userSettings
    opts.userSettings.default
    # add any additional userSettings
    // optionalAttrs (cfg.userSettings != { }) cfg.userSettings
    # add any language specific userSettings
    // builtins.foldl' (
      acc: name:
      optionalAttrs cfg.language-configurations.${name}.enable (
        opts.language-configurations.${name}.userSettings.default
        # also add any additional language specific userSettings
        // (optionalAttrs (
          cfg.language-configurations.${name}.userSettings != { }
        ) cfg.language-configurations.${name}.userSettings)
      )
      // acc
    ) { } (lib.attrNames cfg.language-configurations);

  profiles =
    {
      default = {
        inherit extensions keybindings userSettings;

        enableExtensionUpdateCheck = false;
        enableUpdateCheck = false;
      };
    }
    // builtins.foldl' (
      acc: name:
      with lib;
      # Add profiles that have been enabled
      optionalAttrs cfg.profiles.${name}.enable {
        ${name} = {
          extensions =
            # add base extensions
            opts.extensions.default
            # add extensions from cfg.profiles.${name}.extensions
            ++ optionals (cfg.profiles.${name}.extensions != [ ]) cfg.profiles.${name}.extensions
            # add extensions from cfg.profiles.${name}.languages
            ++ builtins.foldl' (
              acc: curr: opts.language-configurations.${curr}.extensions.default ++ acc
            ) [ ] cfg.profiles.${name}.languages;
          keybindings =
            # add base keybindings
            opts.keybindings.default
            # add keybindings from cfg.profiles.${name}.keybindings
            ++ optionals (cfg.profiles.${name}.keybindings != [ ]) cfg.profiles.${name}.keybindings
            # add keybindings from cfg.profiles.${name}.languages
            ++ builtins.foldl' (
              acc: curr: opts.language-configurations.${curr}.keybindings.default ++ acc
            ) [ ] cfg.profiles.${name}.languages;
          userSettings =
            # add base userSettings
            opts.userSettings.default
            # add userSettings from cfg.profiles.${name}.userSettings
            // optionalAttrs (cfg.profiles.${name}.userSettings != { }) cfg.profiles.${name}.userSettings
            # add userSettings from cfg.profiles.${name}.languages
            // builtins.foldl' (
              acc: curr: opts.language-configurations.${curr}.userSettings.default // acc
            ) { } cfg.profiles.${name}.languages;
        };
      }
      // acc
    ) { } (lib.attrNames cfg.profiles);
in
{
  # TODO: vscode profiles come out in 25.05...remove when stable hits
  disabledModules = [ "${inputs.home-manager}/modules/programs/vscode.nix" ];
  imports = [ "${inputs.home-manager-unstable}/modules/programs/vscode.nix" ];

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
    keybindings = import ./keybindings.nix { inherit lib pkgs; };
    userSettings = import ./userSettings.nix { inherit lib pkgs; };

    # TODO: add globalSnippets and languageSnippets
    # TODO: add userTasks

    language-configurations = import ./language-configurations.nix { inherit lib pkgs; };
    profiles = import ./profiles.nix { inherit lib pkgs; };
  };

  config = lib.mkIf cfg.enable {
    home.sessionVariables = lib.mkIf pkgs.stdenv.isLinux {
      NIXOS_OZONE_WL = "1";
    };

    programs.vscode = {
      inherit (cfg) package;
      inherit profiles;

      enable = true;
      mutableExtensionsDir = false;
    };
  };
}
