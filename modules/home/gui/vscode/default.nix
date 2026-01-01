{
  config,
  lib,
  options,
  pkgs,
  ...
}:
let
  cfg = config.custom.home.gui.vscode;
  opts = options.custom.home.gui.vscode;

  # TODO: stolen code from vscode.nix -- find out how to reference it using
  # options
  jsonFormat = pkgs.formats.json { };
  keybindingSubmodule =
    let
      inherit (lib.types)
        listOf
        submodule
        nullOr
        str
        ;
    in
    listOf (submodule {
      options = {
        key = lib.mkOption {
          type = str;
          example = "ctrl+c";
          description = "The key or key-combination to bind.";
        };

        command = lib.mkOption {
          type = str;
          example = "editor.action.clipboardCopyAction";
          description = "The VS Code command to execute.";
        };

        when = lib.mkOption {
          type = nullOr str;
          default = null;
          example = "textInputFocus";
          description = "Optional context filter.";
        };

        # https://code.visualstudio.com/docs/getstarted/keybindings#_command-arguments
        args = lib.mkOption {
          type = nullOr jsonFormat.type;
          default = null;
          example = {
            direction = "up";
          };
          description = "Optional arguments for a command.";
        };
      };
    });

  profiles = builtins.foldl' (
    acc: profile:
    let
      inherit (lib) mkIf optionals optionalAttrs;
    in
    # Add profiles that have been enabled
    optionalAttrs cfg.profiles.${profile}.enable {
      ${profile} = {
        # Add options _only_ for default profile
        enableExtensionUpdateCheck = mkIf (profile == "default") false;
        enableUpdateCheck = mkIf (profile == "default") false;

        extensions =
          # add base extensions
          opts.extensions.default
          # add any global extensions
          ++ optionals (cfg.extensions != [ ]) cfg.extensions
          # add extensions from the profile extensions list
          ++ optionals (cfg.profiles.${profile}.extensions != [ ]) cfg.profiles.${profile}.extensions
          # add extensions from the profile languages
          ++ builtins.foldl' (
            acc: language-name: opts.language-configurations.${language-name}.extensions.default ++ acc
          ) [ ] cfg.profiles.${profile}.languages;
        keybindings =
          # add base keybindings
          opts.keybindings.default
          # add any global keybindings
          ++ optionals (cfg.keybindings != [ ]) cfg.keybindings
          # add keybindings from the profile keybindings
          ++ optionals (cfg.profiles.${profile}.keybindings != [ ]) cfg.profiles.${profile}.keybindings
          # add keybindings from the profile languages
          ++ builtins.foldl' (
            acc: language-name: opts.language-configurations.${language-name}.keybindings.default ++ acc
          ) [ ] cfg.profiles.${profile}.languages;
        userSettings =
          # add base userSettings
          opts.userSettings.default
          # add any global additional userSettings
          // optionalAttrs (cfg.userSettings != { }) cfg.userSettings
          # add userSettings from the profile userSettings
          // optionalAttrs (cfg.profiles.${profile}.userSettings != { }) cfg.profiles.${profile}.userSettings
          # add userSettings from the profile languages
          // builtins.foldl' (
            acc: curr: opts.language-configurations.${curr}.userSettings.default // acc
          ) { } cfg.profiles.${profile}.languages;
      };
    }
    // acc
  ) { } (lib.attrNames cfg.profiles);
in
{
  options.custom.home.gui.vscode = {
    enable = lib.mkEnableOption "Enable Visual Studio Code";

    package = lib.mkOption {
      # NOTE: fhs version exists
      # workaround in macOS if app does not automatically run
      # 1. settings>privacy&security>security
      # 2. click allow app
      type = lib.types.enum (
        (with pkgs; [
          vscode
          vscodium
          unstable.vscode
          unstable.vscodium
        ])
        # Add the fhs versions for linux only
        ++ lib.optionals pkgs.stdenv.isLinux (
          with pkgs;
          [
            vscode-fhs
            vscodium-fhs
            unstable.vscode-fhs
            unstable.vscodium-fhs
          ]
        )
      );
      default = pkgs.vscodium;
    };

    # global extensions, keybindings, and userSettings
    extensions = import ./extensions.nix { inherit lib pkgs; };
    keybindings = import ./keybindings.nix { inherit lib pkgs keybindingSubmodule; };
    userSettings = import ./userSettings.nix { inherit lib pkgs; };
    language-configurations = import ./language-configurations.nix {
      inherit
        lib
        pkgs
        jsonFormat
        keybindingSubmodule
        ;
    };

    # TODO: add globalSnippets and languageSnippets
    # TODO: add userTasks

    # per-profile extensions, keybindings, and userSettings
    profiles = import ./profiles.nix {
      inherit
        options
        lib
        pkgs
        jsonFormat
        keybindingSubmodule
        ;
    };
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
