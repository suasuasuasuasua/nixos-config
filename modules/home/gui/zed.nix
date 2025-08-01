{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.home.gui.zed;
in
{
  options.custom.home.gui.zed = {
    enable = lib.mkEnableOption "zed";
  };

  config = lib.mkIf cfg.enable {
    programs.zed-editor = {
      enable = true;
      # the remote collaboration integration
      installRemoteServer = false;
      # a list of strings for the extensions
      # https://github.com/zed-industries/extensions/tree/main/extensions
      extensions = [ "nix" ];
      # keymaps
      userKeymaps = [
        {
          "context" = "vim_mode == insert";
          "bindings" = {
            "j k" = "vim::NormalBefore";
            "J k" = "vim::NormalBefore";
            "j K" = "vim::NormalBefore";
            "J K" = "vim::NormalBefore";
          };
        }
        {
          "context" = "Dock";
          "bindings" = {
            "ctrl-w h" = "workspace::ActivatePaneLeft";
            "ctrl-w l" = "workspace::ActivatePaneRight";
            "ctrl-w k" = "workspace::ActivatePaneUp";
            "ctrl-w j" = "workspace::ActivatePaneDown";
          };
        }
        (lib.optionalAttrs pkgs.stdenv.isLinux {
          "context" = "Editor && !menu";
          "bindings" = {
            "ctrl-b" = "workspace::ToggleLeftDock"; # vim default: page up
            "ctrl-f" = "buffer_search::Deploy"; # vim default: page down
          };
        })
      ];
      userSettings = {
        "collaboration_panel" = {
          "button" = false;
        };
        "disable_ai" = true;
        "features" = {
          "edit_prediction_provider" = "none";
        };
        "load_direnv" = "shell_hook";
        "lsp" = {
          "nil" = {
            "initialization_options" = {
              "formatting"."command" = [
                "nixfmt"
                "--quiet"
                "--"
              ];
            };
          };
        };
        "preferred_line_length" = 80;
        "show_completions_on_input" = false;
        "soft_wrap" = "none";
        "tab_size" = 4;
        "telemetry" = {
          "diagnostics" = false;
          "metrics" = false;
        };
        "title_bar" = {
          "show_sign_in" = false;
          "show_onboarding_banner" = false;
          "show_user_picture" = false;
        };
        "vim_mode" = true;
        "vim" = {
          "use_system_clipboard" = "never";
        };
        "wrap_guides" = [
          80
          81
        ];
      };
      # # TODO: add user tasks when unstable hits
      # userTasks = { };
    };
  };
}
