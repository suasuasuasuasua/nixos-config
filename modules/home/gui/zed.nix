{
  config,
  lib,
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
      userKeymaps = { };
      # settings
      # https://zed.dev/docs/configuring-zed
      userSettings = {
        "collaboration_panel" = {
          "button" = false;
        };
        "disable_ai" = true;
        "features" = {
          "edit_prediction_provider" = "none";
        };
        "preferred_line_length" = 80;
        "show_completions_on_input" = false;
        "soft_wrap" = "none";
        "tab_size" = 2;
        "title_bar" = {
          "show_sign_in" = false;
          "show_onboarding_banner" = false;
          "show_user_picture" = false;
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
