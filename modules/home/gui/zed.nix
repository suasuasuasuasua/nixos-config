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
      extensions = [ ];
      # keymaps
      userKeymaps = { };
      # settings
      userSettings = { };
      # # TODO: add user tasks when unstable hits
      # userTasks = { };
    };
  };
}
