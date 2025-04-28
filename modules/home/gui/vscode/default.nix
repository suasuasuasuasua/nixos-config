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

  # TODO: stolen code from 25.05 unstable...remove when merged
  toSentenceCase =
    let
      inherit (builtins)
        isString
        substring
        stringLength
        typeOf
        ;
    in
    with lib.strings;
    str:
    lib.throwIfNot (isString str)
      "toSentenceCase does only accepts string values, but got ${typeOf str}"
      (
        let
          firstChar = substring 0 1 str;
          rest = substring 1 (stringLength str) str;
        in
        addContextFrom str (toUpper firstChar + toLower rest)
      );

  profiles = builtins.foldl' (
    acc: profile:
    with lib;
    # Pretty print the name
    # jq: 1 compile error related to spaces in profile name
    # https://github.com/nix-community/home-manager/issues/6929
    let
      profile-name =
        if profile == "default" then
          profile
        else
          strings.concatStringsSep " " (map toSentenceCase (strings.splitString "-" profile));
    in
    # Add profiles that have been enabled
    optionalAttrs cfg.profiles.${profile}.enable {
      ${profile-name} = {
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

    # global extensions, keybindings, and userSettings
    extensions = import ./extensions.nix { inherit lib pkgs; };
    keybindings = import ./keybindings.nix { inherit lib pkgs; };
    userSettings = import ./userSettings.nix { inherit lib pkgs; };
    language-configurations = import ./language-configurations.nix { inherit lib pkgs; };

    # TODO: add globalSnippets and languageSnippets
    # TODO: add userTasks

    # per-profile extensions, keybindings, and userSettings
    profiles = import ./profiles.nix { inherit options lib pkgs; };
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
